import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_summary.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class MileageDetailsViewModel extends BaseViewModel {
  final budgetingService = serviceLocator<BudgetingService>();

  MileageDetailsViewModel({required this.budgetIndex});

  final int budgetIndex;
  MileageSummary summary = const MileageSummary();
  String? refreshError;

  Budget? get budget {
    final budgets = budgetingService.budgetingModel?.budget ?? [];
    return budgetIndex >= 0 && budgetIndex < budgets.length ? budgets[budgetIndex] : null;
  }

  String get carName {
    final car = budget?.carId;
    final name = [car?.carMake, car?.carModel].whereType<String>().join(' ').trim();
    return name.isNotEmpty ? name : (budget?.carName ?? 'Your car');
  }

  /// Rebuilds from the budgets already in memory, which a mileage update refreshes.
  void load() {
    summary = MileageSummary.fromBudget(budget);
    if (budget != null) budgetingService.getCurrentTotalValue(index: budgetIndex);
    notifyListeners();
  }

  Future<void> refresh() async {
    refreshError = null;
    try {
      await budgetingService.getBudgets();
    } catch (e) {
      refreshError = 'Could not refresh mileage. Pull down to try again.';
    }
    load();
  }
}
