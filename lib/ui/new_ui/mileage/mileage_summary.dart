import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';

String formatKm(int? value) => value == null ? '--' : '${NumberFormat.decimalPattern().format(value)} km';

String formatLogDate(DateTime? date) =>
    date == null ? 'Date not recorded' : DateFormat('d MMM yyyy, h:mm a').format(date.toLocal());

class MileageLogEntry {
  final MileageDatum datum;
  final int? reading;

  /// Distance from the previous logged reading; null for the first log or an unreadable one.
  final int? distanceSincePrevious;

  const MileageLogEntry({required this.datum, this.reading, this.distanceSincePrevious});
}

/// Mileage figures for one car's budget, derived from its odometer logs.
class MileageSummary {
  /// Newest first.
  final List<MileageLogEntry> entries;
  final double? fuelEfficiency;

  const MileageSummary({this.entries = const [], this.fuelEfficiency});

  factory MileageSummary.fromBudget(Budget? budget) {
    final logs = budget?.mileageData ?? [];
    final chronological = <MileageLogEntry>[];
    int? previous;

    // Logs are stored oldest first, in the order they were added.
    for (final datum in logs) {
      final reading = parseReading(datum.odometerReading);
      chronological.add(MileageLogEntry(
        datum: datum,
        reading: reading,
        distanceSincePrevious: reading != null && previous != null ? reading - previous : null,
      ));
      if (reading != null) previous = reading;
    }

    final entries = chronological.reversed.toList();
    final distance = MileageSummary(entries: entries).distanceTracked;
    return MileageSummary(
      entries: entries,
      fuelEfficiency: _fuelEfficiency(distance, budget?.fueling),
    );
  }

  static int? parseReading(String? value) {
    if (value == null) return null;
    return int.tryParse(value.replaceAll(RegExp(r'[,\s]'), ''));
  }

  static double? _fuelEfficiency(int distance, List<Fueling>? fueling) {
    if (distance <= 0 || fueling == null) return null;
    var litres = 0.0;
    for (final fuel in fueling) {
      if (fuel.price != null && (fuel.pricePerLiter ?? 0) > 0) {
        litres += fuel.price! / fuel.pricePerLiter!;
      }
    }
    return litres > 0 ? distance / litres : null;
  }

  bool get isEmpty => entries.isEmpty;

  MileageLogEntry? get latest => entries.isEmpty ? null : entries.first;

  int? get currentReading {
    for (final entry in entries) {
      if (entry.reading != null) return entry.reading;
    }
    return null;
  }

  int? get firstReading {
    for (final entry in entries.reversed) {
      if (entry.reading != null) return entry.reading;
    }
    return null;
  }

  int get distanceTracked {
    final first = firstReading;
    final current = currentReading;
    if (first == null || current == null) return 0;
    return current - first;
  }

  int? get lastTripDistance => latest?.distanceSincePrevious;
}
