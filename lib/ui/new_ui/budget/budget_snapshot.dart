import 'package:mobile_auto_drive/models/budgeting_model.dart';

/// How a car's spending sits against its budget.
enum BudgetStatus {
  /// No budget has been set, so there is nothing to measure against.
  notSet,

  /// Under 75% of the budget used.
  onTrack,

  /// Between 75% and 100% used.
  nearLimit,

  /// More spent than budgeted.
  over,
}

/// The numbers the budget card and screen show for one car, read
/// defensively from a [Budget] so missing lists or amounts count as zero.
class BudgetSnapshot {
  const BudgetSnapshot({
    this.spent = 0,
    this.limit = 0,
    this.fuel = 0,
    this.servicing = 0,
    this.repairs = 0,
    this.fuelCount = 0,
    this.servicingCount = 0,
    this.repairCount = 0,
  });

  factory BudgetSnapshot.fromBudget(Budget? budget) {
    if (budget == null) return const BudgetSnapshot();

    int sum(Iterable<int?> prices) => prices.fold(0, (total, price) => total + (price ?? 0));

    final fueling = budget.fueling ?? const <Fueling>[];
    final servicing = budget.servicing ?? const <Servicing>[];
    final repairing = budget.repairing ?? const <Repairing>[];

    return BudgetSnapshot(
      spent: budget.currentSpending ?? 0,
      limit: budget.budget ?? 0,
      fuel: sum(fueling.map((e) => e.price)),
      servicing: sum(servicing.map((e) => e.price)),
      repairs: sum(repairing.map((e) => e.price)),
      fuelCount: fueling.length,
      servicingCount: servicing.length,
      repairCount: repairing.length,
    );
  }

  final int spent;
  final int limit;
  final int fuel;
  final int servicing;
  final int repairs;
  final int fuelCount;
  final int servicingCount;
  final int repairCount;

  bool get hasLimit => limit > 0;

  /// What is left to spend; negative when over budget.
  int get remaining => limit - spent;

  /// Share of the budget used, capped at 1 for drawing a progress bar.
  double get progress => hasLimit ? (spent / limit).clamp(0.0, 1.0) : 0.0;

  /// Share of the budget used as a whole percentage. Can exceed 100.
  int get percentUsed => hasLimit ? (spent * 100 / limit).round() : 0;

  /// Total of the logged fuel, servicing and repair entries.
  int get categorised => fuel + servicing + repairs;

  BudgetStatus get status {
    if (!hasLimit) return BudgetStatus.notSet;
    if (spent > limit) return BudgetStatus.over;
    if (spent >= limit * 0.75) return BudgetStatus.nearLimit;
    return BudgetStatus.onTrack;
  }
}
