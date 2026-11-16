import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One recorded point on a drive's route.
class DrivePoint {
  const DrivePoint(this.lat, this.lng, this.time, this.speedMs);

  final double lat;
  final double lng;
  final DateTime time;
  final double speedMs;

  List<num> toJson() => [lat, lng, time.millisecondsSinceEpoch, double.parse(speedMs.toStringAsFixed(2))];

  factory DrivePoint.fromJson(List<dynamic> j) => DrivePoint(
        (j[0] as num).toDouble(),
        (j[1] as num).toDouble(),
        DateTime.fromMillisecondsSinceEpoch((j[2] as num).toInt()),
        (j[3] as num).toDouble(),
      );
}

/// The numbers for one drive, live or finished.
class DriveStats {
  const DriveStats({
    required this.duration,
    this.movingTime = Duration.zero,
    this.distanceMeters = 0,
    this.currentSpeedKmh,
    this.topSpeedKmh = 0,
    this.hardBrakes = 0,
    this.rapidAccelerations = 0,
  });

  final Duration duration;

  /// Time spent above walking pace, so traffic stops don't drag the average down.
  final Duration movingTime;
  final double distanceMeters;

  /// Null until the first good GPS fix arrives.
  final double? currentSpeedKmh;
  final double topSpeedKmh;
  final int hardBrakes;
  final int rapidAccelerations;

  double get distanceKm => distanceMeters / 1000;

  Duration get stoppedTime {
    final stopped = duration - movingTime;
    return stopped.isNegative ? Duration.zero : stopped;
  }

  /// Average speed while moving; falls back to the whole drive before any
  /// moving time has been recorded.
  double get averageSpeedKmh {
    final time = movingTime > Duration.zero ? movingTime : duration;
    final hours = time.inMilliseconds / Duration.millisecondsPerHour;
    return hours <= 0 ? 0 : distanceKm / hours;
  }

  /// 0–100: starts at 100 and loses points for harsh braking, harsh
  /// acceleration and very high speed.
  int get smoothnessScore {
    var score = 100 - hardBrakes * 8 - rapidAccelerations * 5;
    if (topSpeedKmh > 120) score -= 10;
    return score.clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
        'durationMs': duration.inMilliseconds,
        'movingMs': movingTime.inMilliseconds,
        'distance': distanceMeters,
        'topSpeedKmh': topSpeedKmh,
        'hardBrakes': hardBrakes,
        'rapidAccelerations': rapidAccelerations,
      };

  factory DriveStats.fromJson(Map<String, dynamic> j) => DriveStats(
        duration: Duration(milliseconds: (j['durationMs'] as num?)?.toInt() ?? 0),
        movingTime: Duration(milliseconds: (j['movingMs'] as num?)?.toInt() ?? 0),
        distanceMeters: (j['distance'] as num?)?.toDouble() ?? 0,
        topSpeedKmh: (j['topSpeedKmh'] as num?)?.toDouble() ?? 0,
        hardBrakes: (j['hardBrakes'] as num?)?.toInt() ?? 0,
        rapidAccelerations: (j['rapidAccelerations'] as num?)?.toInt() ?? 0,
      );
}

Map<String, dynamic> _carToJson(CarId car) => {
      'id': car.sId,
      'make': car.carMake,
      'model': car.carModel,
      'year': car.carYear,
    };

CarId _carFromJson(Map<String, dynamic>? j) => CarId(
      sId: j?['id'] as String?,
      carMake: j?['make'] as String?,
      carModel: j?['model'] as String?,
    )..carYear = j?['year'] as String?;

/// A finished drive, kept in the local drive history.
class DriveRecord {
  const DriveRecord({
    required this.car,
    required this.startedAt,
    required this.endedAt,
    required this.stats,
    this.route = const [],
  });

  final CarId car;
  final DateTime startedAt;
  final DateTime endedAt;
  final DriveStats stats;
  final List<DrivePoint> route;

  Map<String, dynamic> toJson() => {
        'car': _carToJson(car),
        'startedAt': startedAt.millisecondsSinceEpoch,
        'endedAt': endedAt.millisecondsSinceEpoch,
        'stats': stats.toJson(),
        'route': route.map((p) => p.toJson()).toList(),
      };

  factory DriveRecord.fromJson(Map<String, dynamic> j) => DriveRecord(
        car: _carFromJson(j['car'] as Map<String, dynamic>?),
        startedAt: DateTime.fromMillisecondsSinceEpoch((j['startedAt'] as num).toInt()),
        endedAt: DateTime.fromMillisecondsSinceEpoch((j['endedAt'] as num).toInt()),
        stats: DriveStats.fromJson((j['stats'] as Map).cast<String, dynamic>()),
        route: ((j['route'] as List?) ?? const [])
            .map((p) => DrivePoint.fromJson(p as List<dynamic>))
            .toList(),
      );
}

/// A drive in progress for one car, with everything needed to resume it
/// after the app restarts.
class DriveSession {
  DriveSession({required this.car, required this.startedAt});

  final CarId car;
  final DateTime startedAt;

  double distanceMeters = 0;
  int movingMs = 0;
  double topSpeedMs = 0;
  int hardBrakes = 0;
  int rapidAccelerations = 0;
  final List<DrivePoint> route = [];

  /// Smoothed speed for display; null until the first good fix.
  double? currentSpeedMs;

  /// The last fix distance was measured from.
  DrivePoint? anchor;
  double anchorAccuracy = 0;

  /// The last accepted fix, for timing and speed changes.
  DateTime? lastFixAt;
  double? lastRawSpeedMs;
  DateTime? lastHardBrakeAt;
  DateTime? lastRapidAccelAt;

  DriveStats statsAt(DateTime now) => DriveStats(
        duration: now.difference(startedAt),
        movingTime: Duration(milliseconds: movingMs),
        distanceMeters: distanceMeters,
        currentSpeedKmh: currentSpeedMs == null ? null : currentSpeedMs! * 3.6,
        topSpeedKmh: topSpeedMs * 3.6,
        hardBrakes: hardBrakes,
        rapidAccelerations: rapidAccelerations,
      );

  Map<String, dynamic> toJson() => {
        'car': _carToJson(car),
        'startedAt': startedAt.millisecondsSinceEpoch,
        'distance': distanceMeters,
        'movingMs': movingMs,
        'topSpeedMs': topSpeedMs,
        'hardBrakes': hardBrakes,
        'rapidAccelerations': rapidAccelerations,
        'lastFixAt': lastFixAt?.millisecondsSinceEpoch,
        'route': route.map((p) => p.toJson()).toList(),
      };

  factory DriveSession.fromJson(Map<String, dynamic> j) {
    final session = DriveSession(
      car: _carFromJson(j['car'] as Map<String, dynamic>?),
      startedAt: DateTime.fromMillisecondsSinceEpoch((j['startedAt'] as num).toInt()),
    )
      ..distanceMeters = (j['distance'] as num?)?.toDouble() ?? 0
      ..movingMs = (j['movingMs'] as num?)?.toInt() ?? 0
      ..topSpeedMs = (j['topSpeedMs'] as num?)?.toDouble() ?? 0
      ..hardBrakes = (j['hardBrakes'] as num?)?.toInt() ?? 0
      ..rapidAccelerations = (j['rapidAccelerations'] as num?)?.toInt() ?? 0;
    final lastFix = j['lastFixAt'] as num?;
    if (lastFix != null) session.lastFixAt = DateTime.fromMillisecondsSinceEpoch(lastFix.toInt());
    session.route.addAll(((j['route'] as List?) ?? const []).map((p) => DrivePoint.fromJson(p as List<dynamic>)));
    // Distance resumes from the next fix, not from where the app stopped.
    return session;
  }
}

/// Tracks whether a car is in drive mode, measures the drive from GPS, and
/// keeps the drive and a local drive history across app restarts. One
/// instance is shared app-wide so every screen sees the same drive.
class DriveSessionService extends ChangeNotifier {
  DriveSessionService({
    Stream<Position> Function()? positions,
    Future<String?> Function()? ensureLocation,
    DateTime Function()? clock,
  })  : _positions = positions ?? _gpsPositions,
        _ensureLocation = ensureLocation ?? _askForLocation,
        _clock = clock ?? DateTime.now;

  final Stream<Position> Function() _positions;
  final Future<String?> Function() _ensureLocation;
  final DateTime Function() _clock;

  static const activeKey = 'drive.active';
  static const historyKey = 'drive.history';
  static const historyLimit = 30;
  static const routeLimit = 400;

  /// Fixes less accurate than this (metres) are not used for distance.
  static const maxAccuracyMeters = 30.0;

  /// Faster than this between fixes (~300 km/h) means the GPS jumped.
  static const maxPlausibleSpeedMs = 85.0;

  /// Above walking pace (5 km/h) counts as moving.
  static const movingSpeedMs = 1.4;

  /// A change in speed this sharp (m/s²) is harsh braking or acceleration.
  static const hardBrakeMs2 = -3.5;
  static const rapidAccelMs2 = 3.0;

  /// A drive shorter than this (metres) never really moved, so it is
  /// dropped instead of filed in the history.
  static const minDriveMeters = 100.0;

  /// A saved drive with no fixes for this long is finished, not resumed.
  static const staleAfter = Duration(hours: 6);

  DriveSession? _session;
  StreamSubscription<Position>? _subscription;
  DateTime? _lastSavedAt;
  bool _restored = false;

  /// Why GPS is not giving good readings right now, if it isn't.
  String? gpsIssue;

  final List<DriveRecord> history = [];

  DriveSession? get session => _session;
  bool get isDriving => _session != null;

  /// The car currently in drive mode, if any.
  CarId? get drivingCar => _session?.car;

  DriveStats get stats => _session?.statsAt(_clock()) ?? const DriveStats(duration: Duration.zero);

  /// Loads the drive history and resumes a drive the app was closed during.
  /// Safe to call more than once.
  Future<void> restore() async {
    if (_restored) return;
    _restored = true;

    final prefs = await SharedPreferences.getInstance();
    try {
      final saved = prefs.getString(historyKey);
      if (saved != null) {
        history
          ..clear()
          ..addAll((jsonDecode(saved) as List).map((j) => DriveRecord.fromJson((j as Map).cast<String, dynamic>())));
      }
    } catch (error) {
      debugPrint('Drive: could not read history $error');
    }

    final active = prefs.getString(activeKey);
    if (active == null || _session != null) {
      notifyListeners();
      return;
    }

    try {
      final session = DriveSession.fromJson((jsonDecode(active) as Map).cast<String, dynamic>());
      final lastSeen = session.lastFixAt ?? session.startedAt;
      _session = session;
      if (_clock().difference(lastSeen) > staleAfter) {
        // Abandoned long ago: file it at the last moment we heard from it.
        await _finish(endedAt: lastSeen);
        return;
      }
      final problem = await _ensureLocation();
      if (problem == null) {
        _listen();
      } else {
        gpsIssue = problem;
      }
    } catch (error) {
      debugPrint('Drive: could not resume drive $error');
      await prefs.remove(activeKey);
      _session = null;
    }
    notifyListeners();
  }

  /// Puts [car] in drive mode and starts tracking. Returns why it could not
  /// start (e.g. location is off), or null on success.
  Future<String?> start(CarId car) async {
    if (isDriving) return null;

    final problem = await _ensureLocation();
    if (problem != null) return problem;

    _session = DriveSession(car: car, startedAt: _clock());
    gpsIssue = null;
    _listen();
    notifyListeners();
    await _save(force: true);
    return null;
  }

  /// Ends drive mode, files the drive in the history and returns it.
  /// Returns null when nothing was driving or the car never moved.
  Future<DriveRecord?> stop() => _finish(endedAt: _clock());

  Future<DriveRecord?> _finish({required DateTime endedAt}) async {
    final session = _session;
    if (session == null) return null;

    await _subscription?.cancel();
    _subscription = null;
    _session = null;
    gpsIssue = null;

    final full = session.statsAt(endedAt);
    final record = DriveRecord(
      car: session.car,
      startedAt: session.startedAt,
      endedAt: endedAt,
      stats: DriveStats(
        duration: full.duration,
        movingTime: full.movingTime,
        distanceMeters: full.distanceMeters,
        topSpeedKmh: full.topSpeedKmh,
        hardBrakes: full.hardBrakes,
        rapidAccelerations: full.rapidAccelerations,
      ),
      route: _thin(session.route, routeLimit),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(activeKey);

    // No GPS movement: nothing worth keeping.
    if (record.stats.distanceMeters < minDriveMeters) {
      notifyListeners();
      return null;
    }

    history.insert(0, record);
    if (history.length > historyLimit) history.removeRange(historyLimit, history.length);
    notifyListeners();
    await prefs.setString(historyKey, jsonEncode(history.map((r) => r.toJson()).toList()));
    return record;
  }

  /// Drives in the history for [car], newest first.
  List<DriveRecord> historyFor(CarId? car) =>
      car?.sId == null ? const [] : history.where((r) => r.car.sId == car!.sId).toList();

  void _listen() {
    _subscription?.cancel();
    _subscription = _positions().listen(
      onPosition,
      onError: (Object error) {
        gpsIssue = 'No GPS signal';
        debugPrint('Drive: location error $error');
        notifyListeners();
      },
    );
  }

  /// Folds one GPS fix into the drive. Public for tests.
  @visibleForTesting
  void onPosition(Position p) {
    final session = _session;
    if (session == null) return;

    // Out-of-order or repeated fixes add nothing.
    final lastAt = session.lastFixAt;
    if (lastAt != null && !p.timestamp.isAfter(lastAt)) return;

    if (!p.accuracy.isFinite || p.accuracy > maxAccuracyMeters) {
      gpsIssue = 'Weak GPS signal';
      notifyListeners();
      return;
    }
    gpsIssue = null;

    final reported = p.speed.isFinite && p.speed >= 0 ? p.speed : null;
    final point = DrivePoint(p.latitude, p.longitude, p.timestamp, reported ?? 0);
    final anchor = session.anchor;

    if (anchor == null) {
      session
        ..anchor = point
        ..anchorAccuracy = p.accuracy
        ..lastFixAt = p.timestamp
        ..lastRawSpeedMs = reported
        // Unknown until a second fix if the GPS reports no speed.
        ..currentSpeedMs = reported;
      session.route.add(point);
      _changed(p.timestamp);
      return;
    }

    final segment = Geolocator.distanceBetween(anchor.lat, anchor.lng, p.latitude, p.longitude);
    final sinceAnchor = p.timestamp.difference(anchor.time).inMilliseconds / 1000;
    final derived = sinceAnchor > 0 ? segment / sinceAnchor : 0.0;

    // A jump no car could make: drop the fix and keep measuring from the anchor.
    if (derived > maxPlausibleSpeedMs) return;

    final speed = reported ?? derived;
    final sinceLast = p.timestamp.difference(lastAt!).inMilliseconds / 1000;

    // Parked or crawling: the position wobbles by about the fixes' own error
    // even when the GPS speed (which is far steadier) says we're stopped, so
    // only count the move once it clearly exceeds that error. Distance is
    // measured from the anchor, so a slow crawl is still counted once it's
    // far enough.
    final noise = (p.accuracy + session.anchorAccuracy) / 2;
    final drifting = speed < movingSpeedMs && segment < 2 * noise;
    if (!drifting) {
      session.distanceMeters += segment;
      session
        ..anchor = point
        ..anchorAccuracy = p.accuracy;
      final lastRoute = session.route.isEmpty ? null : session.route.last;
      if (lastRoute == null ||
          Geolocator.distanceBetween(lastRoute.lat, lastRoute.lng, p.latitude, p.longitude) >= 15) {
        session.route.add(point);
      }
    }

    // Gaps longer than 30 s (tunnel, app paused) aren't counted as moving.
    if (sinceLast > 0 && sinceLast <= 30 && speed >= movingSpeedMs) {
      session.movingMs += (sinceLast * 1000).round();
    }

    // Top speed needs two fixes in a row at that speed, so one spike can't set it.
    final previous = session.lastRawSpeedMs;
    if (previous != null) {
      session.topSpeedMs = math.max(session.topSpeedMs, math.min(previous, speed));
    }

    // Harsh braking / acceleration from consecutive speeds a few seconds apart.
    if (previous != null && sinceLast >= 0.5 && sinceLast <= 5) {
      final accel = (speed - previous) / sinceLast;
      final now = p.timestamp;
      if (accel <= hardBrakeMs2 && previous > 5 && _cooledDown(session.lastHardBrakeAt, now)) {
        session.hardBrakes++;
        session.lastHardBrakeAt = now;
      } else if (accel >= rapidAccelMs2 && _cooledDown(session.lastRapidAccelAt, now)) {
        session.rapidAccelerations++;
        session.lastRapidAccelAt = now;
      }
    }

    // Lightly smoothed for display; snaps to zero when stopped.
    final shown = session.currentSpeedMs ?? speed;
    session.currentSpeedMs = speed < 0.5 ? 0 : shown * 0.4 + speed * 0.6;
    session
      ..lastRawSpeedMs = speed
      ..lastFixAt = p.timestamp;

    _changed(p.timestamp);
  }

  bool _cooledDown(DateTime? last, DateTime now) => last == null || now.difference(last).inSeconds >= 5;

  void _changed(DateTime fixTime) {
    notifyListeners();
    _save(at: fixTime);
  }

  /// Saves the drive in progress, at most once per 10 seconds of GPS time
  /// unless [force]d.
  Future<void> _save({DateTime? at, bool force = false}) async {
    final session = _session;
    if (session == null) return;
    final now = at ?? _clock();
    if (!force && _lastSavedAt != null && now.difference(_lastSavedAt!).abs() < const Duration(seconds: 10)) return;
    _lastSavedAt = now;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(activeKey, jsonEncode(session.toJson()));
    } catch (error) {
      debugPrint('Drive: could not save drive $error');
    }
  }

  /// Keeps at most [limit] points, evenly spread, always keeping the ends.
  static List<DrivePoint> _thin(List<DrivePoint> points, int limit) {
    if (points.length <= limit) return List.of(points);
    final step = (points.length - 1) / (limit - 1);
    return [for (var i = 0; i < limit; i++) points[(i * step).round()]];
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Fixes every second at navigation accuracy. A foreground service on
  /// Android and background updates on iOS keep it going with the screen off.
  static LocationSettings _settings() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
          intervalDuration: const Duration(seconds: 1),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationTitle: 'Drive mode is on',
            notificationText: 'Motorby is tracking your trip.',
            notificationChannelName: 'Drive mode',
            enableWakeLock: true,
            setOngoing: true,
          ),
        );
      case TargetPlatform.iOS:
        return AppleSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          activityType: ActivityType.automotiveNavigation,
          distanceFilter: 0,
          pauseLocationUpdatesAutomatically: false,
          showBackgroundLocationIndicator: true,
          allowBackgroundLocationUpdates: true,
        );
      default:
        return const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 0);
    }
  }

  static Stream<Position> _gpsPositions() => Geolocator.getPositionStream(locationSettings: _settings());

  static Future<String?> _askForLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return 'Turn on location services to start driving.';
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return 'Allow location access so we can track your drive.';
    }
    return null;
  }
}
