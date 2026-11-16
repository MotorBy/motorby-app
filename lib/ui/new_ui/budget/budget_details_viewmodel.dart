import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_snapshot.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class BudgetDetailsViewModel extends BaseViewModel {
  BudgetDetailsViewModel({required this.budgetIndex});

  final budgetingService = serviceLocator<BudgetingService>();

  final int budgetIndex;
  BudgetSnapshot snapshot = const BudgetSnapshot();
  String? refreshError;

  Budget? get budget {
    final budgets = budgetingService.budgetingModel?.budget ?? const <Budget>[];
    return budgetIndex >= 0 && budgetIndex < budgets.length ? budgets[budgetIndex] : null;
  }

  String get carName {
    final car = budget?.carId;
    final name = [car?.carMake, car?.carModel, car?.carYear]
        .whereType<String>()
        .where((part) => part.trim().isNotEmpty)
        .join(' ');
    return name.isNotEmpty ? name : (budget?.carName ?? 'Your car');
  }

  /// Rebuilds from the budgets already in memory, which a budget update refreshes.
  void load() {
    snapshot = BudgetSnapshot.fromBudget(budget);
    notifyListeners();
  }

  Future<void> refresh() async {
    refreshError = null;
    try {
      await budgetingService.getBudgets();
    } catch (_) {
      refreshError = 'Could not refresh your budget. Pull down to try again.';
    }
    load();
  }
}
