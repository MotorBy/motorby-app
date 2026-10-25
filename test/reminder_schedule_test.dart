import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/notification_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_details_viewmodel.dart';
import 'package:mobile_auto_drive/utils/reminder_schedule.dart';

/// A reminder due on a local calendar day, stored the way the create form
/// stores it: local midnight as a UTC instant.
ReminderPayload reminderOn(
  int year,
  int month,
  int day, {
  String? time = '9:00 AM',
  String frequency = 'once',
  String id = 'r1',
  int? remindBefore = 0,
  bool push = true,
  String? budgetId,
}) {
  return ReminderPayload(
    id: id,
    title: 'Oil change',
    description: 'Synthetic 5W-30',
    category: 'Maintenance',
    budgetId: budgetId,
    dueDate: DateTime(year, month, day).toUtc(),
    dueTime: time,
    frequency: frequency,
    notificationPreferences: NotificationPreferences(
      push: push,
      email: false,
      sms: true,
      remindMeBefore: remindBefore,
    ),
  );
}

void main() {
  group('parseDueTime', () {
    test('reads 12-hour times the way the time picker formats them', () {
      expect(parseDueTime('2:30 PM'), (hour: 14, minute: 30));
      expect(parseDueTime('9:05 am'), (hour: 9, minute: 5));
      expect(parseDueTime('9:05 a.m.'), (hour: 9, minute: 5));
    });

    test('gets midnight and noon right', () {
      expect(parseDueTime('12:00 AM'), (hour: 0, minute: 0));
      expect(parseDueTime('12:15 PM'), (hour: 12, minute: 15));
    });

    test('reads 24-hour times, with or without seconds', () {
      expect(parseDueTime('14:30'), (hour: 14, minute: 30));
      expect(parseDueTime('07:45:00'), (hour: 7, minute: 45));
    });

    test('rejects nonsense instead of guessing', () {
      expect(parseDueTime(null), isNull);
      expect(parseDueTime(''), isNull);
      expect(parseDueTime('soon'), isNull);
      expect(parseDueTime('25:00'), isNull);
      expect(parseDueTime('13:00 PM'), isNull);
      expect(parseDueTime('10:75'), isNull);
    });
  });

  test('formatDueTime round-trips through parseDueTime', () {
    for (final h in [0, 9, 12, 13, 23]) {
      final text = formatDueTime(h, 7);
      expect(parseDueTime(text), (hour: h, minute: 7), reason: text);
    }
    expect(formatDueTime(0, 0), '12:00 AM');
    expect(formatDueTime(14, 30), '2:30 PM');
  });

  group('reminderDueAt', () {
    test('combines the stored day with the time, on the local calendar', () {
      final due = reminderDueAt(reminderOn(2026, 10, 26, time: '2:30 PM'));
      expect(due, DateTime(2026, 10, 26, 14, 30));
    });

    test('does not slip a day because the date is stored in UTC', () {
      // Local midnight on the 26th is the 25th in UTC east of Greenwich.
      final due = reminderDueAt(reminderOn(2026, 10, 26, time: '12:00 AM'));
      expect(due!.day, 26);
    });

    test('falls back to 9am when no time was chosen', () {
      expect(reminderDueAt(reminderOn(2026, 10, 26, time: null)),
          DateTime(2026, 10, 26, 9, 0));
    });

    test('is null without a date', () {
      expect(reminderDueAt(ReminderPayload(id: 'x')), isNull);
    });
  });

  group('upcomingOccurrences', () {
    final now = DateTime(2026, 10, 25, 12, 0);

    test('a one-off reminder in the future fires once', () {
      expect(upcomingOccurrences(reminderOn(2026, 10, 27), now: now),
          [DateTime(2026, 10, 27, 9)]);
    });

    test('a one-off reminder in the past fires never', () {
      expect(upcomingOccurrences(reminderOn(2026, 10, 1), now: now), isEmpty);
    });

    test('daily reminders roll forward past today', () {
      final r = reminderOn(2026, 10, 1, frequency: 'daily');
      expect(upcomingOccurrences(r, now: now), [
        DateTime(2026, 10, 26, 9),
        DateTime(2026, 10, 27, 9),
        DateTime(2026, 10, 28, 9),
      ]);
    });

    test('a daily reminder later today still fires today', () {
      final r = reminderOn(2026, 10, 1, frequency: 'daily', time: '6:00 PM');
      expect(upcomingOccurrences(r, now: now, count: 1), [DateTime(2026, 10, 25, 18)]);
    });

    test('weekly reminders keep their weekday', () {
      // 1 Oct 2026 is a Thursday.
      final r = reminderOn(2026, 10, 1, frequency: 'weekly');
      final next = upcomingOccurrences(r, now: now);
      expect(next.first, DateTime(2026, 10, 29, 9));
      expect(next.every((d) => d.weekday == DateTime.thursday), isTrue);
    });

    test('monthly reminders clamp to short months and spring back', () {
      final r = reminderOn(2026, 1, 31, frequency: 'monthly');
      final next = upcomingOccurrences(r, now: DateTime(2026, 1, 31, 10), count: 3);
      expect(next, [
        DateTime(2026, 2, 28, 9), // no 31st in February
        DateTime(2026, 3, 31, 9), // back to the 31st
        DateTime(2026, 4, 30, 9),
      ]);
    });

    test('frequency is matched case-insensitively', () {
      final r = reminderOn(2026, 10, 1, frequency: 'Daily');
      expect(upcomingOccurrences(r, now: now, count: 1), [DateTime(2026, 10, 26, 9)]);
    });
  });

  group('alertTimeFor', () {
    final now = DateTime(2026, 10, 25, 12, 0);

    test('subtracts the lead time', () {
      expect(alertTimeFor(DateTime(2026, 10, 26, 9), 30, now), DateTime(2026, 10, 26, 8, 30));
    });

    test('a lead that has already passed alerts straight away, not never', () {
      final alert = alertTimeFor(DateTime(2026, 10, 25, 12, 10), 60, now);
      expect(alert.isAfter(now), isTrue);
      expect(alert.difference(now), lessThan(const Duration(minutes: 1)));
    });
  });

  group('notificationIdFor', () {
    test('is stable, so a re-sync replaces instead of duplicating', () {
      expect(notificationIdFor('abc', 0), notificationIdFor('abc', 0));
    });

    test('differs per occurrence and per reminder', () {
      expect(notificationIdFor('abc', 0), isNot(notificationIdFor('abc', 1)));
      expect(notificationIdFor('abc', 0), isNot(notificationIdFor('abd', 0)));
    });

    test('fits an Android notification id', () {
      for (var i = 0; i < 50; i++) {
        final id = notificationIdFor('reminder-$i', i % 3);
        expect(id, greaterThan(0));
        expect(id, lessThanOrEqualTo(0x7fffffff));
      }
    });
  });

  test('describeLead reads naturally', () {
    expect(describeLead(0), 'At the due time');
    expect(describeLead(30), '30 minutes before');
    expect(describeLead(60), '1 hour before');
    expect(describeLead(120), '2 hours before');
    expect(describeLead(1440), '1 day before');
  });

  group('planReminderAlerts', () {
    final now = DateTime(2026, 10, 25, 12, 0);

    test('schedules the next few occurrences of each reminder', () {
      final plan = planReminderAlerts([
        reminderOn(2026, 10, 1, frequency: 'daily', id: 'a'),
        reminderOn(2026, 10, 30, id: 'b'),
      ], now: now);

      expect(plan.where((a) => a.reminder.id == 'a').length, kOccurrencesPerReminder);
      expect(plan.where((a) => a.reminder.id == 'b').length, 1);
    });

    test('skips reminders with push turned off', () {
      final plan = planReminderAlerts([reminderOn(2026, 10, 30, push: false)], now: now);
      expect(plan, isEmpty);
    });

    test('skips reminders that have passed', () {
      expect(planReminderAlerts([reminderOn(2026, 1, 1)], now: now), isEmpty);
    });

    test('applies each reminder\'s own lead time', () {
      final plan = planReminderAlerts([reminderOn(2026, 10, 30, remindBefore: 60)], now: now);
      expect(plan.single.occurrence, DateTime(2026, 10, 30, 9));
      expect(plan.single.alertAt, DateTime(2026, 10, 30, 8));
    });

    test('is soonest first and stays under the platform cap', () {
      final many = List.generate(
        40,
        (i) => reminderOn(2026, 10, 1, frequency: 'daily', id: 'r$i'),
      );
      final plan = planReminderAlerts(many, now: now);

      expect(plan.length, kMaxPendingReminderAlerts);
      for (var i = 1; i < plan.length; i++) {
        expect(plan[i].alertAt.isBefore(plan[i - 1].alertAt), isFalse);
      }
    });

    test('alert text names the due time when it fires early', () {
      final alert = planReminderAlerts(
          [reminderOn(2026, 10, 30, remindBefore: 30, time: '2:00 PM')], now: now).single;
      expect(alert.title, 'Oil change');
      expect(alert.body, 'Due at 2:00 PM · Synthetic 5W-30');
    });
  });

  group('NotificationTarget', () {
    test('survives a round trip through the notification payload', () {
      const target = NotificationTarget(type: NotificationTarget.reminder, id: 'r9');
      final back = NotificationTarget.decode(target.encode());
      expect(back?.type, 'reminder');
      expect(back?.id, 'r9');
    });

    test('ignores payloads that are not ours', () {
      expect(NotificationTarget.decode(null), isNull);
      expect(NotificationTarget.decode(''), isNull);
      expect(NotificationTarget.decode('not json'), isNull);
      expect(NotificationTarget.decode('{"foo":1}'), isNull);
    });

    test('reads a push payload that uses reminder_id', () {
      final t = NotificationTarget.fromRemoteData({'type': 'reminder', 'reminder_id': 'r2'});
      expect(t?.id, 'r2');
    });
  });

  group('ReminderPayload parsing', () {
    test('reads the lead time the create form has always sent', () {
      final r = ReminderPayload.fromJson({
        '_id': 'r1',
        'notification_preferences': {'push': true, 'remind_me_before': 45},
      });
      expect(r.remindBeforeMinutes, 45);
    });

    test('defaults to 30 minutes and push on, matching the create form', () {
      final r = ReminderPayload.fromJson({'_id': 'r1'});
      expect(r.remindBeforeMinutes, 30);
      expect(r.pushEnabled, isTrue);
    });

    test('no longer crashes on a reminder without metadata', () {
      expect(() => ReminderPayload.fromJson({'_id': 'r1'}), returnsNormally);
      expect(ReminderPayload.fromJson({'_id': 'r1'}).toJson()['metadata'], isNull);
    });

    test('finds the car through metadata on older reminders', () {
      final r = ReminderPayload.fromJson({
        '_id': 'r1',
        'metadata': {'budget_id': 'b7', 'category': 'Fueling'},
      });
      expect(r.linkedBudgetId, 'b7');
      expect(r.effectiveCategory, 'Fueling');
    });
  });

  group('ReminderDraft', () {
    test('starts with no changes', () {
      final r = reminderOn(2026, 10, 30, time: '2:30 PM', frequency: 'weekly');
      expect(ReminderDraft.from(r).changesFrom(r), isEmpty);
    });

    test('lists exactly what was edited', () {
      final r = reminderOn(2026, 10, 30);
      final d = ReminderDraft.from(r)
        ..title = 'Brake check'
        ..hour = 15
        ..budgetId = 'b2';
      expect(d.changesFrom(r), ['title', 'time', 'car']);
    });

    test('saves in the shape the create form uses', () {
      final r = reminderOn(2026, 10, 30, time: '2:30 PM', frequency: 'weekly', remindBefore: 60);
      final payload = ReminderDraft.from(r).toPayload();

      expect(payload['due_time'], '2:30 PM');
      expect(payload['frequency'], 'weekly');
      expect(DateTime.parse(payload['due_date']).toLocal(), DateTime(2026, 10, 30));
      expect(payload['notification_preferences']['remind_me_before'], 60);
    });

    test('leaves email and SMS preferences as they were', () {
      final r = reminderOn(2026, 10, 30); // email false, sms true
      final prefs = (ReminderDraft.from(r)..push = false).toPayload()['notification_preferences'];
      expect(prefs['push'], isFalse);
      expect(prefs['email'], isFalse);
      expect(prefs['sms'], isTrue);
    });
  });
}
