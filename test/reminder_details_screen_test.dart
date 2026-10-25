import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/notification_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_screen.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/in_app_notification.dart';

final corolla = CarId(
  sId: 'car-1',
  carMake: 'Toyota',
  carModel: 'Corolla',
  carYear: '2019',
  registrationNumber: 'LND-123-AB',
  images: [],
  carDocuments: [],
);

final civic = CarId(
  sId: 'car-2',
  carMake: 'Honda',
  carModel: 'Civic',
  carYear: '2021',
  images: [],
  carDocuments: [],
);

ReminderPayload reminder({String? budgetId = 'b1', bool push = true}) {
  final now = DateTime.now();
  final inThreeDays = DateTime(now.year, now.month, now.day + 3);
  return ReminderPayload(
    id: 'r1',
    title: 'Oil change',
    description: 'Synthetic 5W-30, check the filter too',
    category: 'Maintenance',
    budgetId: budgetId,
    dueDate: inThreeDays.toUtc(),
    dueTime: '2:30 PM',
    frequency: 'weekly',
    notificationPreferences: NotificationPreferences(push: push, remindMeBefore: 60),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    await PersistenceService.getInstance();
  });

  setUp(() {
    // Two cars in the garage; the reminder points at the first.
    serviceLocator<BudgetingService>().budgetingModel = BudgetingModel(
      statusCode: 200,
      budget: [
        Budget(sId: 'b1', carId: corolla),
        Budget(sId: 'b2', carId: civic),
      ],
    );
    serviceLocator<ReminderService>().reminderListModel =
        ReminderListModel(statusCode: 200, message: 'ok', data: [reminder()]);
  });

  Widget host(Widget child) => MaterialApp(
        navigatorKey: NotificationService.navigatorKey,
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context,
                width: size.width, height: size.height, allowFontScaling: true);
            return child;
          },
        ),
      );

  Future<void> pumpDetails(WidgetTester tester, ReminderPayload r) async {
    await tester.pumpWidget(host(ReminderDetailsScreen(reminder: r)));
    await tester.pumpAndSettle();
  }

  group('details', () {
    testWidgets('shows what the reminder is and when', (tester) async {
      await pumpDetails(tester, reminder());

      expect(find.text('Oil change'), findsOneWidget);
      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Due in 3 days'), findsOneWidget);
      expect(find.text('2:30 PM'), findsOneWidget);
      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Synthetic 5W-30, check the filter too'), findsOneWidget);
    });

    testWidgets('shows how and when it will alert', (tester) async {
      await pumpDetails(tester, reminder());

      expect(find.text('1 hour before'), findsOneWidget);
      expect(find.text('On'), findsOneWidget);
      expect(find.text('Next alert'), findsOneWidget);
    });

    testWidgets('names the car it is connected to', (tester) async {
      await pumpDetails(tester, reminder());

      expect(find.text('Toyota Corolla 2019'), findsOneWidget);
      expect(find.text('LND-123-AB'), findsOneWidget);
    });

    testWidgets('says plainly when no car is linked', (tester) async {
      await pumpDetails(tester, reminder(budgetId: null));

      expect(find.text('Not linked to a car. Tap Edit to choose one.'), findsOneWidget);
    });

    testWidgets('says so when the linked car has been removed', (tester) async {
      await pumpDetails(tester, reminder(budgetId: 'gone'));

      expect(find.textContaining('no longer in your garage'), findsOneWidget);
    });

    testWidgets('a reminder with push off has no next alert', (tester) async {
      await pumpDetails(tester, reminder(push: false));

      expect(find.text('Off'), findsOneWidget);
      expect(find.text('Turned off'), findsOneWidget);
    });

    testWidgets('can be opened from just an id, as a notification tap does',
        (tester) async {
      await tester.pumpWidget(host(const ReminderDetailsScreen(reminderId: 'r1')));
      await tester.pumpAndSettle();

      expect(find.text('Oil change'), findsOneWidget);
    });
  });

  group('editing', () {
    Future<void> startEditing(WidgetTester tester) async {
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
    }

    XButton saveButton(WidgetTester tester) => tester.widget<XButton>(find.byType(XButton));

    testWidgets('Edit switches to a form filled with the current values',
        (tester) async {
      await pumpDetails(tester, reminder());
      await startEditing(tester);

      expect(find.text('Edit reminder'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Oil change'), findsOneWidget);
      expect(find.text('Toyota Corolla 2019'), findsOneWidget);
      expect(find.text('1 hour before'), findsOneWidget);
    });

    testWidgets('Save stays off until something changes', (tester) async {
      await pumpDetails(tester, reminder());
      await startEditing(tester);

      expect(saveButton(tester).onPressed, isNull);

      await tester.enterText(find.widgetWithText(TextFormField, 'Oil change'), 'Brake check');
      await tester.pump();

      expect(saveButton(tester).onPressed, isNotNull);
    });

    testWidgets('an empty title is called out next to the field', (tester) async {
      await pumpDetails(tester, reminder());
      await startEditing(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'Oil change'), '');
      await tester.pump();

      expect(find.text('Give the reminder a title'), findsOneWidget);
    });

    testWidgets('Cancel throws the edits away', (tester) async {
      await pumpDetails(tester, reminder());
      await startEditing(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'Oil change'), 'Brake check');
      await tester.pump();
      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Reminder'), findsOneWidget);
      expect(find.text('Oil change'), findsOneWidget);
      expect(find.text('Brake check'), findsNothing);
    });

    testWidgets('the car can be moved to another car or unlinked', (tester) async {
      await pumpDetails(tester, reminder());
      await startEditing(tester);

      await tester.tap(find.text('Toyota Corolla 2019'));
      await tester.pumpAndSettle();

      expect(find.text('Which car is this for?'), findsOneWidget);
      expect(find.text('No car'), findsOneWidget);
      expect(find.text('Honda Civic 2021'), findsOneWidget);

      await tester.tap(find.text('Honda Civic 2021'));
      await tester.pumpAndSettle();

      expect(find.text('Honda Civic 2021'), findsOneWidget);
      expect(saveButton(tester).onPressed, isNotNull);
    });

    testWidgets('push notifications can be switched off', (tester) async {
      await pumpDetails(tester, reminder());
      await startEditing(tester);

      await tester.ensureVisible(find.byType(Switch));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('No alert will be shown for this reminder'), findsOneWidget);
    });
  });

  group('reminder list', () {
    testWidgets('tapping a reminder opens its details', (tester) async {
      await tester.pumpWidget(host(const ReminderScreen(isFromQuickActions: true)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Oil change'));
      await tester.pumpAndSettle();

      expect(find.byType(ReminderDetailsScreen), findsOneWidget);
      expect(find.text('Toyota Corolla 2019'), findsOneWidget);
    });
  });

  group('in-app notification', () {
    testWidgets('appears over the current screen and opens on tap',
        (tester) async {
      await tester.pumpWidget(host(const Scaffold(body: Text('Home'))));
      var opened = false;

      final shown = NotificationService.instance.showInApp(
        title: 'Oil change',
        body: 'Due at 2:30 PM',
        target: const NotificationTarget(type: NotificationTarget.reminder, id: 'r1'),
      );
      NotificationService.onOpenTarget = (_) => opened = true;
      await tester.pumpAndSettle();

      expect(shown, isTrue);
      expect(find.text('Oil change'), findsOneWidget);
      expect(find.text('Due at 2:30 PM'), findsOneWidget);

      await tester.tap(find.text('Oil change'));
      await tester.pumpAndSettle();
      expect(opened, isTrue);
      NotificationService.onOpenTarget = null;
    });

    testWidgets('dismisses itself after a few seconds', (tester) async {
      await tester.pumpWidget(host(const Scaffold(body: Text('Home'))));

      NotificationService.instance.showInApp(title: 'Oil change', body: 'Due now');
      await tester.pumpAndSettle();
      expect(find.byType(InAppNotification), findsOneWidget);

      await tester.pump(InAppNotification.visibleFor + const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.byType(InAppNotification), findsNothing);
    });

    testWidgets('a newer alert replaces the one on screen', (tester) async {
      await tester.pumpWidget(host(const Scaffold(body: Text('Home'))));

      NotificationService.instance.showInApp(title: 'First', body: '');
      await tester.pumpAndSettle();
      NotificationService.instance.showInApp(title: 'Second', body: '');
      await tester.pumpAndSettle();

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);

      await tester.pump(InAppNotification.visibleFor + const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });
  });
}
