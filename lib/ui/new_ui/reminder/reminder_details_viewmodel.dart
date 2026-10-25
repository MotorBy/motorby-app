import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/utils/error_logging.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/reminder_schedule.dart';
import 'package:stacked/stacked.dart';

/// Categories offered when creating a reminder; kept in step with the create
/// form so an edited reminder can be anything a new one can.
const List<String> kReminderCategories = [
  'Maintenance', 'Changes', 'Repairs', 'Budget', 'Trips',
  'Breakdown', 'Fueling', 'Service', 'Insurance', 'Other',
];

const List<String> kReminderFrequencies = ['daily', 'weekly', 'monthly'];

String frequencyLabel(String? frequency) {
  final f = (frequency ?? '').trim();
  if (f.isEmpty) return 'Does not repeat';
  return f[0].toUpperCase() + f.substring(1).toLowerCase();
}

class ReminderDetailsViewModel extends BaseViewModel {
  final _reminderService = serviceLocator<ReminderService>();
  final _budgetingService = serviceLocator<BudgetingService>();

  ReminderPayload? reminder;

  /// Set while the screen is in edit mode. Holds the user's unsaved choices so
  /// Cancel can throw them away without touching [reminder].
  ReminderDraft? draft;

  bool get isEditing => draft != null;

  String? loadError;

  Future<void> init({ReminderPayload? initial, String? reminderId}) async {
    reminder = initial ?? _reminderService.reminderById(reminderId);
    notifyListeners();

    // Opened from a notification before the list was ever loaded.
    if (reminder == null && reminderId != null) {
      setBusy(true);
      try {
        await _reminderService.getReminders();
        reminder = _reminderService.reminderById(reminderId);
        if (reminder == null) loadError = 'This reminder no longer exists';
      } catch (e) {
        loadError = readableError(e);
      }
      setBusy(false);
    }

    // The car comes from the budget list; load it if nothing has yet.
    if (_budgetingService.budgetingModel == null) {
      try {
        await _budgetingService.getBudgets();
      } catch (_) {
        // The reminder still renders; the car card just says it is unknown.
      }
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // The connected car
  // ---------------------------------------------------------------------------

  List<Budget> get _budgets => _budgetingService.budgetingModel?.budget ?? const [];

  /// Budgets that actually have a car, i.e. what a reminder can be linked to.
  List<Budget> get linkableBudgets => _budgets.where((b) => b.carId != null).toList();

  Budget? budgetFor(String? budgetId) {
    if (budgetId == null) return null;
    for (final b in _budgets) {
      if (b.sId == budgetId) return b;
    }
    return null;
  }

  int? budgetIndexFor(String? budgetId) {
    final index = _budgets.indexWhere((b) => b.sId == budgetId);
    return index < 0 ? null : index;
  }

  Budget? get linkedBudget => budgetFor(reminder?.linkedBudgetId);

  CarId? get linkedCar => linkedBudget?.carId;

  /// True when the reminder names a budget we cannot find - usually a car that
  /// has since been deleted.
  bool get linkedCarMissing => reminder?.linkedBudgetId != null && linkedCar == null;

  // ---------------------------------------------------------------------------
  // Timing
  // ---------------------------------------------------------------------------

  DateTime? get dueAt => reminder == null ? null : reminderDueAt(reminder!);

  /// The next time this reminder is due, rolling repeats forward.
  DateTime? nextOccurrence({DateTime? now}) {
    if (reminder == null) return null;
    final next = upcomingOccurrences(reminder!, now: now ?? DateTime.now(), count: 1);
    return next.isEmpty ? null : next.first;
  }

  DateTime? nextAlert({DateTime? now}) {
    final at = now ?? DateTime.now();
    final next = nextOccurrence(now: at);
    if (next == null || reminder == null) return null;
    return alertTimeFor(next, reminder!.remindBeforeMinutes, at);
  }

  /// A one-off reminder whose time has passed.
  bool isPast({DateTime? now}) => dueAt != null && nextOccurrence(now: now) == null;

  // ---------------------------------------------------------------------------
  // Editing
  // ---------------------------------------------------------------------------

  void startEditing() {
    final r = reminder;
    if (r == null) return;
    draft = ReminderDraft.from(r);
    notifyListeners();
  }

  void cancelEditing() {
    draft = null;
    notifyListeners();
  }

  void updateDraft(void Function(ReminderDraft d) change) {
    if (draft == null) return;
    change(draft!);
    notifyListeners();
  }

  bool get hasDraftChanges =>
      draft != null && reminder != null && draft!.changesFrom(reminder!).isNotEmpty;

  /// Field-level problems with the draft, keyed by field, so the form can say
  /// what is wrong next to where it is wrong.
  Map<String, String> get draftErrors {
    final d = draft;
    if (d == null) return const {};
    final errors = <String, String>{};
    if (d.title.trim().isEmpty) errors['title'] = 'Give the reminder a title';
    if (d.date == null) errors['date'] = 'Pick a date';
    return errors;
  }

  Future<void> save({Function? onCallBack, Function(String? e)? onErrorBack}) async {
    final d = draft;
    final r = reminder;
    if (d == null || r == null || r.id == null) return;

    if (draftErrors.isNotEmpty) {
      onErrorBack?.call(draftErrors.values.first);
      return;
    }

    setBusyForObject('save', true);
    try {
      final updated = await _reminderService.updateReminder(
        id: r.id!,
        changes: d.toPayload(),
      );
      reminder = updated ?? r;
      draft = null;
      setBusyForObject('save', false);
      onCallBack?.call();
    } catch (e) {
      setBusyForObject('save', false);
      onErrorBack?.call(readableError(e));
    }
  }
}

/// The editable copy of a reminder.
class ReminderDraft {
  ReminderDraft({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.hour,
    required this.minute,
    required this.frequency,
    required this.budgetId,
    required this.remindBefore,
    required this.push,
    this.email,
    this.sms,
  });

  String title;
  String description;
  String category;

  /// Calendar day in local time.
  DateTime? date;
  int hour;
  int minute;
  String frequency;
  String? budgetId;
  int remindBefore;
  bool push;

  /// Not editable here; carried through so saving does not overwrite them.
  final bool? email;
  final bool? sms;

  factory ReminderDraft.from(ReminderPayload r) {
    final due = reminderDueAt(r);
    return ReminderDraft(
      title: r.title ?? '',
      description: r.description ?? '',
      category: r.effectiveCategory,
      date: due == null ? null : DateTime(due.year, due.month, due.day),
      hour: due?.hour ?? 9,
      minute: due?.minute ?? 0,
      frequency: (r.frequency ?? 'daily').toLowerCase(),
      budgetId: r.linkedBudgetId,
      remindBefore: r.remindBeforeMinutes,
      push: r.pushEnabled,
      email: r.notificationPreferences?.email,
      sms: r.notificationPreferences?.sms,
    );
  }

  String get dueTimeText => formatDueTime(hour, minute);

  /// What is different from [r], as display labels. Empty means unchanged.
  List<String> changesFrom(ReminderPayload r) {
    final original = ReminderDraft.from(r);
    return [
      if (title.trim() != original.title.trim()) 'title',
      if (description.trim() != original.description.trim()) 'description',
      if (category != original.category) 'category',
      if (date != original.date) 'date',
      if (hour != original.hour || minute != original.minute) 'time',
      if (frequency != original.frequency) 'frequency',
      if (budgetId != original.budgetId) 'car',
      if (remindBefore != original.remindBefore) 'alert',
      if (push != original.push) 'push',
    ];
  }

  /// The body sent to the backend, in the same shape the create form uses.
  Map<String, dynamic> toPayload() {
    final day = date!;
    return {
      'title': title.trim(),
      'description': description.trim(),
      'category': category,
      'budget_id': budgetId,
      // Local midnight as a UTC instant, exactly as the create form stores it.
      'due_date': DateTime(day.year, day.month, day.day).toUtc().toIso8601String(),
      'due_time': dueTimeText,
      'frequency': frequency,
      'notification_preferences': {
        'push': push,
        'email': email ?? true,
        'sms': sms ?? true,
        'remind_me_before': remindBefore,
      },
    };
  }
}
