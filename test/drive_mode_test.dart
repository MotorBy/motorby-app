import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/drive_session_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_viewmodel.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

final car = CarId(sId: 'car-1', carMake: 'Toyota', carModel: 'Corolla');
final t0 = DateTime(2026, 11, 14, 9);

/// ~111 m per 0.001° of latitude.
Position fix(double lat, {double lng = 3.0, double seconds = 0, double speedMs = 0, double accuracy = 5}) => Position(
      latitude: lat,
      longitude: lng,
      timestamp: t0.add(Duration(milliseconds: (seconds * 1000).round())),
      accuracy: accuracy,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: speedMs,
      speedAccuracy: 0,
    );

class Harness {
  final positions = StreamController<Position>.broadcast();
  DateTime now = t0;
  String? locationProblem;

  late final service = DriveSessionService(
    positions: () => positions.stream,
    ensureLocation: () async => locationProblem,
    clock: () => now,
  );

  Future<void> feed(List<Position> fixes) async {
    for (final f in fixes) {
      positions.add(f);
    }
    await pumpEventQueue();
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    await PersistenceService.getInstance();
  });

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  group('DriveSessionService measuring', () {
    test('puts the car in drive mode and adds up distance', () async {
      final h = Harness();
      expect(await h.service.start(car), isNull);
      expect(h.service.isDriving, isTrue);
      expect(h.service.drivingCar, car);

      await h.feed([
        fix(6.000, speedMs: 10),
        fix(6.001, seconds: 10, speedMs: 11),
        fix(6.002, seconds: 20, speedMs: 11),
      ]);
      h.now = t0.add(const Duration(minutes: 1));

      final stats = h.service.stats;
      expect(stats.distanceMeters, closeTo(222, 3));
      expect(stats.duration, const Duration(minutes: 1));
      expect(stats.movingTime, const Duration(seconds: 20));
      // Average is over moving time, so the wait before the first fix doesn't count.
      expect(stats.averageSpeedKmh, closeTo(40, 1));
    });

    test('ignores GPS drift while parked', () async {
      final h = Harness();
      await h.service.start(car);

      // Wobbling ~5–8 m around one spot with 10 m accuracy and no speed.
      await h.feed([
        for (var i = 0; i < 20; i++)
          fix(6.0 + (i.isEven ? 0.00005 : -0.00005), seconds: i.toDouble(), accuracy: 10),
      ]);

      expect(h.service.stats.distanceMeters, 0);
      expect(h.service.stats.movingTime, Duration.zero);
    });

    test('ignores fuzzy fixes and GPS jumps, and flags a weak signal', () async {
      final h = Harness();
      await h.service.start(car);

      await h.feed([fix(6.000), fix(6.001, seconds: 10, accuracy: 200)]);
      expect(h.service.gpsIssue, contains('Weak GPS'));

      await h.feed([fix(6.100, seconds: 11)]); // 11 km in 11 s
      expect(h.service.stats.distanceMeters, 0);
      expect(h.service.gpsIssue, isNull);
    });

    test('ignores out-of-order fixes', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([fix(6.000), fix(6.001, seconds: 10, speedMs: 11), fix(6.005, seconds: 5, speedMs: 11)]);

      expect(h.service.stats.distanceMeters, closeTo(111, 2));
    });

    test('uses the speed from movement when the GPS gives none', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([fix(6.000, speedMs: -1), fix(6.001, seconds: 10, speedMs: -1), fix(6.002, seconds: 20, speedMs: -1)]);

      expect(h.service.stats.currentSpeedKmh, closeTo(40, 1));
      expect(h.service.stats.movingTime, const Duration(seconds: 20));
    });

    test('needs two fixes in a row to set top speed, so one spike cannot', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([
        fix(6.000, speedMs: 20),
        fix(6.0002, seconds: 1, speedMs: 20),
        fix(6.0004, seconds: 2, speedMs: 60), // spike
        fix(6.0006, seconds: 3, speedMs: 20),
      ]);

      expect(h.service.stats.topSpeedKmh, closeTo(72, 0.1));
    });

    test('counts hard braking and quick starts once each', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([
        fix(6.0000, seconds: 0, speedMs: 20),
        fix(6.0002, seconds: 1, speedMs: 20),
        fix(6.0003, seconds: 2, speedMs: 14), // -6 m/s²: hard brake
        fix(6.0004, seconds: 3, speedMs: 9), // still braking, within cool-down
        fix(6.0005, seconds: 8, speedMs: 9),
        fix(6.0006, seconds: 9, speedMs: 13), // +4 m/s²: quick start
      ]);

      expect(h.service.stats.hardBrakes, 1);
      expect(h.service.stats.rapidAccelerations, 1);
      expect(h.service.stats.smoothnessScore, 87);
    });
  });

  group('DriveSessionService saving', () {
    test('does not start without location, and explains why', () async {
      final h = Harness()..locationProblem = 'Turn on location services to start driving.';

      expect(await h.service.start(car), 'Turn on location services to start driving.');
      expect(h.service.isDriving, isFalse);
    });

    test('stop files the drive in a history that survives a restart', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([fix(6.000, speedMs: 15), fix(6.009, seconds: 60, speedMs: 15)]);
      h.now = t0.add(const Duration(minutes: 2));

      final record = (await h.service.stop())!;
      expect(h.service.isDriving, isFalse);
      expect(record.car.sId, 'car-1');
      expect(record.stats.distanceKm, closeTo(1.0, 0.01));
      expect(record.route, hasLength(2));
      expect(await h.service.stop(), isNull);

      final reopened = Harness();
      await reopened.service.restore();
      expect(reopened.service.isDriving, isFalse);
      expect(reopened.service.history, hasLength(1));
      expect(reopened.service.history.first.stats.distanceKm, closeTo(1.0, 0.01));
      expect(reopened.service.historyFor(car), hasLength(1));
    });

    test('drops a drive where the car never moved', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([fix(6.0000), fix(6.0001, seconds: 30)]);

      expect(await h.service.stop(), isNull);
      expect(h.service.isDriving, isFalse);
      expect(h.service.history, isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(DriveSessionService.activeKey), isNull);
    });

    test('resumes a drive the app was closed during', () async {
      final h = Harness();
      await h.service.start(car);
      await h.feed([fix(6.000, speedMs: 15), fix(6.009, seconds: 60, speedMs: 15)]);

      final reopened = Harness()..now = t0.add(const Duration(minutes: 5));
      await reopened.service.restore();
      expect(reopened.service.isDriving, isTrue);
      expect(reopened.service.drivingCar!.carMake, 'Toyota');
      expect(reopened.service.stats.distanceKm, closeTo(1.0, 0.01));

      // Measuring picks up from the next fix, not from where the app stopped.
      await reopened.feed([fix(6.050, seconds: 300, speedMs: 15), fix(6.051, seconds: 310, speedMs: 15)]);
      expect(reopened.service.stats.distanceKm, closeTo(1.11, 0.01));
    });

    test('files a drive abandoned for hours instead of resuming it', () async {
      final prefs = await SharedPreferences.getInstance();
      final old = DriveSession(car: car, startedAt: t0)..distanceMeters = 4200;
      await prefs.setString(DriveSessionService.activeKey, jsonEncode(old.toJson()));

      final h = Harness()..now = t0.add(const Duration(hours: 9));
      await h.service.restore();

      expect(h.service.isDriving, isFalse);
      expect(h.service.history.single.stats.distanceKm, closeTo(4.2, 0.001));
      expect(prefs.getString(DriveSessionService.activeKey), isNull);
    });
  });

  group('DriveModeViewModel', () {
    test('formats the clock, lengths and dates', () {
      expect(DriveModeViewModel.formatClock(const Duration(minutes: 12, seconds: 4)), '12:04');
      expect(DriveModeViewModel.formatClock(const Duration(hours: 1, minutes: 5, seconds: 9)), '1:05:09');
      expect(DriveModeViewModel.formatLength(const Duration(seconds: 20)), '1 min');
      expect(DriveModeViewModel.formatLength(const Duration(hours: 1, minutes: 5)), '1 h 5 min');
      final now = DateTime(2026, 11, 16, 12);
      expect(DriveModeViewModel.formatWhen(DateTime(2026, 11, 16, 9, 5), now: now), 'Today, 09:05');
      expect(DriveModeViewModel.formatWhen(DateTime(2026, 11, 15, 18, 0), now: now), 'Yesterday, 18:00');
      expect(DriveModeViewModel.formatWhen(DateTime(2026, 11, 2, 7, 40), now: now), '2 Nov, 07:40');
      expect(DriveModeViewModel.carNameFor(null), 'Your car');
    });

    test('gives a short instruction for the speed and warns when fast', () {
      expect(DriveMood.forSpeed(null).title, 'Getting GPS…');
      expect(DriveMood.forSpeed(30).title, 'Drive safely');
      expect(DriveMood.forSpeed(140).title, 'Slow down');
      expect(DriveMood.forSpeed(80).level, DriveMoodLevel.calm);
      expect(DriveMood.forSpeed(140).level, DriveMoodLevel.alert);
    });

    test('ends the drive and describes it', () async {
      final h = Harness();
      await h.service.start(car);
      final model = DriveModeViewModel(driveService: h.service);
      await h.feed([
        fix(6.0000, speedMs: 20),
        fix(6.0002, seconds: 1, speedMs: 20),
        fix(6.0003, seconds: 2, speedMs: 13),
        fix(6.0012, seconds: 10, speedMs: 13),
      ]);

      expect(await model.endDrive(), isTrue);

      expect(model.showSummary, isTrue);
      expect(model.isDriving, isFalse);
      expect(model.isCalmDrive, isFalse);
      expect(model.summaryNote, '1 hard brake');
      expect(model.summaryLine, startsWith('0.1 km · '));
      model.dispose();
    });

    test('has no summary when the car never moved', () async {
      final h = Harness();
      await h.service.start(car);
      final model = DriveModeViewModel(driveService: h.service);
      await h.feed([fix(6.0000)]);

      expect(await model.endDrive(), isFalse);
      expect(model.showSummary, isFalse);
      model.dispose();
    });
  });

  group('DriveModeScreen', () {
    void usePhoneScreen(WidgetTester tester) {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
    }

    // The LIVE dot pulses forever, so pump fixed frames instead of settling.
    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
    }

    testWidgets('shows live stats, then a summary after ending the drive', (tester) async {
      usePhoneScreen(tester);
      final h = Harness();
      await tester.runAsync(() => h.service.start(car));

      await tester.pumpWidget(MaterialApp(home: DriveModeScreen(driveService: h.service)));
      await tester.pump();
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('Toyota Corolla'), findsOneWidget);
      expect(find.text('Getting GPS…'), findsOneWidget);
      expect(find.text('--'), findsOneWidget);

      h.service.onPosition(fix(6.000, speedMs: 12.5));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('45'), findsOneWidget);
      expect(find.text('Drive safely'), findsOneWidget);
      h.service.onPosition(fix(6.002, seconds: 18, speedMs: 12.5));
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('End drive'));
      await settle(tester);
      await tester.tap(find.text('End'));
      await tester.runAsync(() => pumpEventQueue());
      await settle(tester);

      expect(h.service.isDriving, isFalse);
      expect(find.text('Drive complete'), findsOneWidget);
      expect(find.text('0.2 km · 1 min'), findsOneWidget);
      expect(find.text('Smooth drive'), findsOneWidget);
      expect(find.text('100/100'), findsOneWidget);
    });

    testWidgets('goes straight back when the car never moved', (tester) async {
      usePhoneScreen(tester);
      final h = Harness();
      await tester.runAsync(() => h.service.start(car));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DriveModeScreen(driveService: h.service),
              )),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await settle(tester);
      h.service.onPosition(fix(6.000));
      await tester.pump();

      await tester.tap(find.text('End drive'));
      await settle(tester);
      await tester.tap(find.text('End'));
      await tester.runAsync(() => pumpEventQueue());
      await settle(tester);

      expect(h.service.isDriving, isFalse);
      expect(h.service.history, isEmpty);
      expect(find.text('Drive complete'), findsNothing);
      expect(find.byType(DriveModeScreen), findsNothing);
      expect(find.text('open'), findsOneWidget);
      expect(find.text('No movement detected. Drive not saved.'), findsOneWidget);
    });

    testWidgets('keeping on driving leaves drive mode on', (tester) async {
      usePhoneScreen(tester);
      final h = Harness();
      await tester.runAsync(() => h.service.start(car));

      await tester.pumpWidget(MaterialApp(home: DriveModeScreen(driveService: h.service)));
      await tester.tap(find.text('End drive'));
      await settle(tester);
      await tester.tap(find.text('Keep driving'));
      await settle(tester);

      expect(h.service.isDriving, isTrue);
      expect(find.text('LIVE'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('lists recent drives when nothing is in progress', (tester) async {
      usePhoneScreen(tester);
      final h = Harness();
      await tester.runAsync(() async {
        await h.service.start(car);
        h.service.onPosition(fix(6.000, speedMs: 15));
        h.service.onPosition(fix(6.009, seconds: 60, speedMs: 15));
        await h.service.stop();
      });

      await tester.pumpWidget(MaterialApp(home: DriveModeScreen(driveService: h.service)));
      await tester.runAsync(() => pumpEventQueue());
      await tester.pump();

      expect(find.text('No active drive'), findsOneWidget);
      expect(find.text('Recent drives'), findsOneWidget);
      expect(find.text('1.0 km'), findsOneWidget);
    });
  });
}
