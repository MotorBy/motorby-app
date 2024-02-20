import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

enum CurrentView {
  cars,
  sales
}

class HomeViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final budgetingService = serviceLocator<BudgetingService>();

  bool hasAddedCar = false;

  BudgetingModel? budgetingModel;

  final List<String>? totalList = [
    'Fueling',
    'Servicing',
    'Repairing',
    'Mileage',
    'Breakdown'
  ];

  final List<int>? totalCostingAndValue = [
    0,
    0,
    0,
    0,
    0
  ];

  int? currentTotalSpent = 0;
  int? totalCarsAdded = 0;
  int? currentBudgetViewIndex = 0;

  CurrentView? currentViewState = CurrentView.cars;

  Future init() async {
    await budgetingService.getBudgets();
    budgetingModel = budgetingService.budgetingModel;

    if(budgetingModel != null) {
      if(budgetingModel!.budget!.isNotEmpty) {

        hasAddedCar = true;
        totalCarsAdded = budgetingModel!.budget!.length;
        getCurrentTotalValue(index: 0);

      }
    }

    notifyListeners();
  }

  void updateToBudget() {

  }

  void removeCar() {

  }

  void getCurrentTotalValue({int? index}) {

    for (var element in budgetingModel!.budget![index!].fueling!) {
      totalCostingAndValue![0] = totalCostingAndValue![0] + element.price!;
    }

    for (var element in budgetingModel!.budget![index].servicing!) {
      totalCostingAndValue![1] = totalCostingAndValue![1] + element.price!;
    }

    for (var element in budgetingModel!.budget![index].repairing!) {
      totalCostingAndValue![2] = totalCostingAndValue![2] + element.price!;
    }

    totalCostingAndValue![3] = budgetingModel!.budget![index].mileage!;

    totalCostingAndValue![4] = budgetingModel!.budget![index].breakdowns!.length;

    currentTotalSpent = totalCostingAndValue![0] + totalCostingAndValue![1] + totalCostingAndValue![2];

    notifyListeners();

  }

  void onBudgetViewUpdated (int? v) {

    currentBudgetViewIndex = v;
    getCurrentTotalValue(index: 0);

    notifyListeners();
  }


  void updateCurrentViewState(){
    if(currentViewState == CurrentView.cars) {
      currentViewState = CurrentView.sales;
    } else {
      currentViewState = CurrentView.cars;
    }
    notifyListeners();
  }

  Future updateBudgetType({String? type}) async {
    await  budgetingService.updateOnBudget().then((value) {

    }).onError((error, stackTrace) {

    });
  }

  Map<String, dynamic> budgetData = {};
  String? date = '';

  void updateBudgetData({String? value, String? type}){
    if(type == "amount") {
      budgetData["amount"] = value;
    } else if (type == "date") {
      budgetData["date"] = value;
    } else if (type == "condition") {
      budgetData["condition"] = value;
    } else if (type == "location") {
      budgetData["location"] = value;
    } else if (type == "mile") {
      budgetData["mile"] = value;
    }  else if (type == "condition") {
      budgetData["condition"] = value;
    }  else if (type == "shop_name") {
      budgetData["shop_name"] = value;
    } else if(type == "price_per_liter") {
      budgetData["price_per_liter"] = value;
    }
    notifyListeners();
  }


}