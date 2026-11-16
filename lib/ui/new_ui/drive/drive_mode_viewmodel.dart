import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/drive_session_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_summary.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

enum DriveMoodLevel { calm, alert }

/// A short instruction for the current speed.
class DriveMood {
  const DriveMood(this.title, this.icon, [this.level = DriveMoodLevel.calm]);

  final String title;
  final IconData icon;
  final DriveMoodLevel level;

  factory DriveMood.forSpeed(double? kmh) {
    if (kmh == null) return const DriveMood('Getting GPS…', Icons.satellite_alt_rounded);
    if (kmh < 5) return const DriveMood('Ready to go', Icons.self_improvement_rounded);
    if (kmh < 50) return const DriveMood('Drive safely', Icons.location_city_rounded);
    if (kmh < 100) return const DriveMood('Stay steady', Icons.waves_rounded);
    if (kmh <= 120) return const DriveMood('Keep your distance', Icons.add_road_rounded);
    return const DriveMood('Slow down', Icons.speed_rounded, DriveMoodLevel.alert);
  }
}

class DriveModeViewModel extends BaseViewModel {
  DriveModeViewModel({DriveSessionService? driveService})
      : driveService = driveService ?? serviceLocator<DriveSessionService>();

  final DriveSessionService driveService;
  final budgetingService = serviceLocator<BudgetingService>();

  Timer? _clock;
  bool isEnding = false;

  /// The drive just ended, shown as the summary.
  DriveRecord? summary;

  // ---- Lifecycle ----

  Future<void> init() async {
    driveService.addListener(notifyListeners);
    // Ticks the drive clock.
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (driveService.isDriving) notifyListeners();
    });
    await driveService.restore();
  }

  @override
  void dispose() {
    _clock?.cancel();
    driveService.removeListener(notifyListeners);
    super.dispose();
  }

  // ---- Live drive ----

  bool get isDriving => driveService.isDriving;
  bool get showSummary => summary != null;
  DriveStats get stats => driveService.stats;
  String get carName => carNameFor(driveService.drivingCar);
  DriveMood get mood => DriveMood.forSpeed(stats.currentSpeedKmh);
  bool get isAlert => mood.level == DriveMoodLevel.alert;
  String? get gpsIssue => driveService.gpsIssue;
  String get clockText => formatClock(stats.duration);

  /// Ends the drive. Returns true when there is a summary to show, false
  /// when the car never moved and the screen should just close.
  Future<bool> endDrive() async {
    if (isEnding) return showSummary;
    isEnding = true;
    notifyListeners();
    summary = await driveService.stop();
    isEnding = false;
    notifyListeners();
    return showSummary;
  }

  // ---- Summary ----

  /// "12.4 km · 25 min"
  String get summaryLine {
    final s = summary?.stats;
    if (s == null) return '';
    return '${s.distanceKm.toStringAsFixed(1)} km · ${formatLength(s.duration)}';
  }

  /// No harsh moments and under 100 km/h the whole way.
  bool get isCalmDrive {
    final s = summary?.stats;
    return s != null && s.topSpeedKmh <= 100 && s.hardBrakes == 0 && s.rapidAccelerations == 0;
  }

  /// "Smooth drive" or "1 hard brake · Top 130 km/h".
  String get summaryNote {
    final s = summary?.stats;
    if (s == null) return '';
    if (isCalmDrive) return 'Smooth drive';
    return [
      if (s.hardBrakes > 0) '${s.hardBrakes} hard ${s.hardBrakes == 1 ? 'brake' : 'brakes'}',
      if (s.rapidAccelerations > 0) '${s.rapidAccelerations} quick ${s.rapidAccelerations == 1 ? 'start' : 'starts'}',
      if (s.topSpeedKmh > 100) 'Top ${s.topSpeedKmh.round()} km/h',
    ].join(' · ');
  }

  /// Where the finished drive's car sits in the budget list, for mileage.
  int? get summaryBudgetIndex {
    final id = summary?.car.sId;
    if (id == null) return null;
    final index = (budgetingService.budgetingModel?.budget ?? const <Budget>[])
        .indexWhere((b) => b.carId?.sId == id);
    return index < 0 ? null : index;
  }

  /// The last logged odometer reading plus this drive, as a nudge to log it.
  int? get estimatedOdometer {
    final index = summaryBudgetIndex;
    final s = summary?.stats;
    if (index == null || s == null) return null;
    final reading = MileageSummary.fromBudget(budgetingService.budgetingModel!.budget![index]).currentReading;
    return reading == null ? null : reading + s.distanceKm.round();
  }

  // ---- History ----

  List<DriveRecord> get recentDrives => driveService.history.take(5).toList();

  // ---- Formatting, shared with the quick actions sheet and home ----

  /// "Toyota Corolla", falling back to a friendly default.
  static String carNameFor(CarId? car) {
    final name = [car?.carMake, car?.carModel]
        .whereType<String>()
        .where((part) => part.trim().isNotEmpty)
        .join(' ');
    return name.isEmpty ? 'Your car' : name;
  }

  /// "12:04" under an hour, "1:05:09" over.
  static String formatClock(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours, m = d.inMinutes % 60, s = d.inSeconds % 60;
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  /// "25 min" or "1 h 5 min".
  static String formatLength(Duration d) {
    final h = d.inHours, m = d.inMinutes % 60;
    if (h == 0) return m <= 1 ? '1 min' : '$m min';
    return m == 0 ? '$h h' : '$h h $m min';
  }

  /// "Today, 09:15", "Yesterday, 18:02" or "12 Nov, 07:40".
  static String formatWhen(DateTime when, {DateTime? now}) {
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final day = DateUtils.dateOnly(when);
    final time = '${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}';
    if (day == today) return 'Today, $time';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday, $time';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${when.day} ${months[when.month - 1]}, $time';
  }
}
