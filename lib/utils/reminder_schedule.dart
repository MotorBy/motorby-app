import 'package:mobile_auto_drive/models/reminder_model.dart';

/// How far ahead repeating reminders are scheduled with the OS.
///
/// The app re-syncs every time the reminder list loads, so this only has to
/// cover the gap until the user next opens Motorby. iOS caps pending local
/// notifications at 64, which is why it is not open-ended.
const int kOccurrencesPerReminder = 3;
const int kMaxPendingReminderAlerts = 60;

/// Parses the time string the create form stores.
///
/// The form saves `TimeOfDay.format(context)`, so the shape depends on the
/// phone's locale: '2:30 PM', '14:30', and the occasional '14:30:00' from the
/// backend all turn up. Returns (hour, minute) in 24h, or null if unreadable.
({int hour, int minute})? parseDueTime(String? raw) {
  if (raw == null) return null;
  final text = raw.trim().toUpperCase().replaceAll('.', '');
  if (text.isEmpty) return null;

  final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?\s*(AM|PM)?$').firstMatch(text);
  if (match == null) return null;

  var hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  final period = match.group(3);

  if (minute > 59) return null;

  if (period != null) {
    if (hour < 1 || hour > 12) return null;
    if (period == 'AM' && hour == 12) hour = 0;
    if (period == 'PM' && hour != 12) hour += 12;
  } else if (hour > 23) {
    return null;
  }

  return (hour: hour, minute: minute);
}

/// Formats a time the same way regardless of locale, for display and for
/// sending back to the backend on edit.
String formatDueTime(int hour, int minute) {
  final period = hour >= 12 ? 'PM' : 'AM';
  final h12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$h12:${minute.toString().padLeft(2, '0')} $period';
}

/// The moment the reminder is due, in local time.
///
/// The date is stored as a UTC instant of *local* midnight (picking 26 Oct in
/// Lagos saves 2026-10-25T23:00Z), so it has to go back through toLocal()
/// before the calendar day is read, or every reminder lands a day early.
DateTime? reminderDueAt(ReminderPayload reminder) {
  final date = reminder.dueDate;
  if (date == null) return null;

  final local = date.toLocal();
  final time = parseDueTime(reminder.dueTime);

  return DateTime(
    local.year,
    local.month,
    local.day,
    time?.hour ?? 9, // no time chosen: a sensible morning default
    time?.minute ?? 0,
  );
}

/// Steps one repeat forward. Monthly clamps to the last day of shorter months
/// rather than spilling over (31 Jan -> 28/29 Feb, not 3 Mar).
DateTime _advance(DateTime from, String frequency) {
  switch (frequency) {
    case 'daily':
      return DateTime(from.year, from.month, from.day + 1, from.hour, from.minute);
    case 'weekly':
      return DateTime(from.year, from.month, from.day + 7, from.hour, from.minute);
    case 'monthly':
      final lastDay = DateTime(from.year, from.month + 2, 0).day;
      final day = from.day > lastDay ? lastDay : from.day;
      return DateTime(from.year, from.month + 1, day, from.hour, from.minute);
    default:
      return from;
  }
}

bool isRepeating(String? frequency) =>
    const {'daily', 'weekly', 'monthly'}.contains(frequency?.toLowerCase());

/// The next [count] times this reminder is due, strictly after [now].
///
/// A one-off reminder in the past yields nothing. A repeating one rolls
/// forward from its original due date, keeping the same day-of-month or
/// weekday, so a reminder created months ago still fires on its rhythm.
List<DateTime> upcomingOccurrences(
  ReminderPayload reminder, {
  required DateTime now,
  int count = kOccurrencesPerReminder,
}) {
  final first = reminderDueAt(reminder);
  if (first == null || count <= 0) return const [];

  final frequency = (reminder.frequency ?? '').toLowerCase();

  if (!isRepeating(frequency)) {
    return first.isAfter(now) ? [first] : const [];
  }

  // Keep the original day-of-month anchor for monthly so a reminder on the
  // 31st goes back to the 31st after passing through a short month.
  final anchorDay = first.day;
  var next = first;
  var guard = 0;
  while (!next.isAfter(now) && guard < 5000) {
    next = _advance(next, frequency);
    if (frequency == 'monthly') next = _reanchor(next, anchorDay);
    guard++;
  }

  final result = <DateTime>[];
  while (result.length < count) {
    result.add(next);
    next = _advance(next, frequency);
    if (frequency == 'monthly') next = _reanchor(next, anchorDay);
  }
  return result;
}

DateTime _reanchor(DateTime d, int anchorDay) {
  final lastDay = DateTime(d.year, d.month + 1, 0).day;
  final day = anchorDay > lastDay ? lastDay : anchorDay;
  return DateTime(d.year, d.month, day, d.hour, d.minute);
}

/// When to actually alert for an occurrence: the due time minus the user's
/// "remind me before" lead. Never earlier than [now] - a lead that has already
/// passed alerts immediately instead of being dropped.
DateTime alertTimeFor(DateTime occurrence, int remindBeforeMinutes, DateTime now) {
  final lead = remindBeforeMinutes < 0 ? 0 : remindBeforeMinutes;
  final alert = occurrence.subtract(Duration(minutes: lead));
  return alert.isBefore(now) ? now.add(const Duration(seconds: 5)) : alert;
}

/// A stable, positive 31-bit id per reminder occurrence, so re-syncing replaces
/// alerts instead of duplicating them. Android notification ids are int32.
int notificationIdFor(String reminderId, int occurrenceIndex) {
  var hash = 0x811c9dc5; // FNV-1a, deterministic across runs unlike hashCode
  for (final unit in '$reminderId#$occurrenceIndex'.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0x7fffffff;
  }
  return hash == 0 ? 1 : hash;
}

/// Human wording for the lead time, e.g. 30 -> '30 minutes before'.
String describeLead(int minutes) {
  if (minutes <= 0) return 'At the due time';
  if (minutes % 1440 == 0) {
    final days = minutes ~/ 1440;
    return '$days day${days == 1 ? '' : 's'} before';
  }
  if (minutes % 60 == 0) {
    final hours = minutes ~/ 60;
    return '$hours hour${hours == 1 ? '' : 's'} before';
  }
  return '$minutes minutes before';
}

/// Lead times offered in the editor.
const List<int> kLeadTimeOptions = [0, 15, 30, 60, 120, 1440];
