import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/utils/reminder_schedule.dart';
import 'package:mobile_auto_drive/widgets/in_app_notification.dart';
import 'package:timezone/timezone.dart' as tz;

/// What a notification tap should open. Encoded into the notification payload
/// so a tap works the same whether the app was open, backgrounded or killed.
class NotificationTarget {
  const NotificationTarget({required this.type, this.id});

  final String type;
  final String? id;

  static const reminder = 'reminder';

  Map<String, dynamic> toJson() => {'type': type, if (id != null) 'id': id};

  String encode() => json.encode(toJson());

  static NotificationTarget? decode(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final data = json.decode(payload);
      if (data is! Map || data['type'] == null) return null;
      return NotificationTarget(type: '${data['type']}', id: data['id']?.toString());
    } catch (_) {
      return null;
    }
  }

  static NotificationTarget? fromRemoteData(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    if (type == null) return null;
    return NotificationTarget(
      type: type,
      id: (data['id'] ?? data['reminder_id'])?.toString(),
    );
  }
}

class NotificationService with WidgetsBindingObserver {
  static NotificationService? _instance;
  static late FirebaseMessaging _messaging;
  static late FlutterLocalNotificationsPlugin _localNotifications;
  static String? fcmToken;

  /// Lets the service show in-app banners and open screens from a tap without
  /// holding a BuildContext. Wired into MaterialApp in main.dart.
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Opens the screen for a tapped notification. Registered by the UI layer
  /// (see main.dart) so this service does not import screens.
  static void Function(NotificationTarget target)? onOpenTarget;

  NotificationService._();

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  static const _reminderChannel = AndroidNotificationChannel(
    'reminders',
    'Reminders',
    description: 'Alerts for the reminders you set on your cars',
    importance: Importance.max,
  );

  bool _initialized = false;
  bool _canScheduleExact = false;

  /// Only show the in-app banner when someone is actually looking at the app.
  /// Dart timers keep running for a while after backgrounding, and a banner
  /// nobody sees would also swallow the system notification.
  bool _isForeground = true;

  /// Reminders currently in the schedule, so a tap or an in-app alert can say
  /// something useful even before the reminder list is reloaded.
  final Map<String, ReminderPayload> _scheduled = {};

  /// One timer per pending occurrence while the app is alive, used to raise
  /// the in-app banner at the same moment the OS would raise its own.
  final Map<int, Timer> _inAppTimers = {};

  NotificationTarget? _pendingLaunchTarget;

  Future<void> initialize() async {
    _messaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Request permission for iOS devices
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    fcmToken = await _messaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }

    // Configure local notifications
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final target = NotificationTarget.decode(details.payload);
        if (target != null) _open(target);
      },
    );

    await _prepareAndroid();

    // A reminder tapped while the app was killed: remember it and open it
    // once the first screen exists.
    final launch = await _localNotifications.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true) {
      _pendingLaunchTarget = NotificationTarget.decode(launch!.notificationResponse?.payload);
    }

    WidgetsBinding.instance.addObserver(this);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground push: the user is already in the app, so show it in-app
    // rather than dropping a system notification on top of what they are doing.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final shown = showInApp(
        title: message.notification?.title ?? 'Motorby',
        body: message.notification?.body ?? '',
        target: NotificationTarget.fromRemoteData(message.data),
      );
      if (!shown) _showNotification(message);
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final target = NotificationTarget.fromRemoteData(message.data);
      if (target != null) _open(target);
    });

    _initialized = true;
  }

  Future<void> _prepareAndroid() async {
    if (kIsWeb || !Platform.isAndroid) return;

    final android = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(_reminderChannel);
    // Android 13+ needs runtime consent before any notification shows.
    await android.requestNotificationsPermission();
    _canScheduleExact = await android.canScheduleExactNotifications() ?? false;
  }

  /// Opens whatever the app was launched for. Call once the navigator exists.
  void handleLaunchTarget() {
    final target = _pendingLaunchTarget;
    _pendingLaunchTarget = null;
    if (target != null) _open(target);
  }

  void _open(NotificationTarget target) {
    final open = onOpenTarget;
    if (open == null) {
      _pendingLaunchTarget = target;
      return;
    }
    open(target);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isForeground = state == AppLifecycleState.resumed;
  }

  // ---------------------------------------------------------------------------
  // Reminders
  // ---------------------------------------------------------------------------

  /// Brings the OS schedule in line with [reminders].
  ///
  /// Called whenever the reminder list loads or a reminder is saved. It clears
  /// every alert it previously scheduled and lays down the next few
  /// occurrences of each reminder, so edits, deletions and frequency changes
  /// all land without tracking individual changes.
  Future<void> syncReminders(List<ReminderPayload> reminders, {DateTime? now}) async {
    if (!_initialized) return;

    final at = now ?? DateTime.now();
    final plan = planReminderAlerts(reminders, now: at);

    await _cancelScheduledReminders();

    for (final alert in plan) {
      _scheduled[alert.reminder.id!] = alert.reminder;
      await _scheduleSystemAlert(alert);
      _armInAppTimer(alert, at);
    }
  }

  Future<void> _cancelScheduledReminders() async {
    for (final timer in _inAppTimers.values) {
      timer.cancel();
    }
    _inAppTimers.clear();

    final pending = await _localNotifications.pendingNotificationRequests();
    for (final request in pending) {
      if (NotificationTarget.decode(request.payload)?.type == NotificationTarget.reminder) {
        await _localNotifications.cancel(request.id);
      }
    }
    _scheduled.clear();
  }

  Future<void> _scheduleSystemAlert(ReminderAlert alert) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _reminderChannel.id,
        _reminderChannel.name,
        channelDescription: _reminderChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    );

    try {
      await _localNotifications.zonedSchedule(
        alert.notificationId,
        alert.title,
        alert.body,
        // An absolute instant: correct whatever zone the phone is in, without
        // needing the device's IANA zone name.
        tz.TZDateTime.from(alert.alertAt.toUtc(), tz.UTC),
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // Exact alarms need a user grant on Android 14+. Without it the alert
        // still comes, just within the OS's batching window.
        androidScheduleMode: _canScheduleExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        payload: NotificationTarget(
          type: NotificationTarget.reminder,
          id: alert.reminder.id,
        ).encode(),
      );
    } catch (e) {
      if (kDebugMode) print('Could not schedule reminder ${alert.reminder.id}: $e');
    }
  }

  /// While the app is running, raise the alert in-app at the same moment.
  /// If the user is looking at the app, the banner replaces the system
  /// notification instead of doubling up with it.
  void _armInAppTimer(ReminderAlert alert, DateTime now) {
    final wait = alert.alertAt.difference(now);
    // Dart timers are not meant for long waits; anything beyond a day is
    // re-armed by the next sync, which happens every time reminders load.
    if (wait.isNegative || wait > const Duration(hours: 24)) return;

    _inAppTimers[alert.notificationId] = Timer(wait, () async {
      _inAppTimers.remove(alert.notificationId);
      if (!_isForeground) return; // the OS notification will do it

      final shown = showInApp(
        title: alert.title,
        body: alert.body,
        target: NotificationTarget(type: NotificationTarget.reminder, id: alert.reminder.id),
        icon: Icons.notifications_active_rounded,
      );
      if (shown) await _localNotifications.cancel(alert.notificationId);
    });
  }

  /// Drops every reminder alert. Called on sign-out so the next person to use
  /// the phone is not alerted about someone else's car.
  Future<void> clearReminders() async {
    if (!_initialized) return;
    await _cancelScheduledReminders();
  }

  /// The reminder last scheduled under [id], if any.
  ReminderPayload? scheduledReminder(String? id) => id == null ? null : _scheduled[id];

  // ---------------------------------------------------------------------------
  // In-app
  // ---------------------------------------------------------------------------

  /// Shows a banner at the top of whatever screen is open. Returns false when
  /// there is nowhere to show it (no navigator yet), so the caller can fall
  /// back to a system notification.
  bool showInApp({
    required String title,
    required String body,
    NotificationTarget? target,
    IconData icon = Icons.notifications_rounded,
  }) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return false;

    InAppNotification.show(
      overlay,
      title: title,
      body: body,
      icon: icon,
      onTap: target == null ? null : () => _open(target),
    );
    return true;
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: json.encode(message.data),
    );
  }
}

/// One alert to lay down with the OS.
class ReminderAlert {
  const ReminderAlert({
    required this.reminder,
    required this.occurrence,
    required this.alertAt,
    required this.notificationId,
  });

  final ReminderPayload reminder;

  /// When the reminder is due.
  final DateTime occurrence;

  /// When to alert: the due time minus the lead.
  final DateTime alertAt;

  final int notificationId;

  String get title => reminder.title?.isNotEmpty == true ? reminder.title! : 'Reminder';

  String get body {
    final lead = reminder.remindBeforeMinutes;
    final when = lead > 0 && alertAt.isBefore(occurrence)
        ? 'Due at ${formatDueTime(occurrence.hour, occurrence.minute)}'
        : 'Due now';
    final description = reminder.description;
    return description == null || description.isEmpty ? when : '$when · $description';
  }
}

/// Works out every alert to schedule, without touching the plugin, so the
/// rules can be tested directly.
///
/// Skips reminders with push turned off or no id, takes the next few
/// occurrences of each, keeps the soonest overall within the platform cap.
List<ReminderAlert> planReminderAlerts(List<ReminderPayload> reminders, {required DateTime now}) {
  final alerts = <ReminderAlert>[];

  for (final reminder in reminders) {
    final id = reminder.id;
    if (id == null || id.isEmpty || !reminder.pushEnabled) continue;

    final occurrences = upcomingOccurrences(reminder, now: now);
    for (var i = 0; i < occurrences.length; i++) {
      alerts.add(ReminderAlert(
        reminder: reminder,
        occurrence: occurrences[i],
        alertAt: alertTimeFor(occurrences[i], reminder.remindBeforeMinutes, now),
        notificationId: notificationIdFor(id, i),
      ));
    }
  }

  alerts.sort((a, b) => a.alertAt.compareTo(b.alertAt));
  return alerts.length > kMaxPendingReminderAlerts
      ? alerts.sublist(0, kMaxPendingReminderAlerts)
      : alerts;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
  }
}
