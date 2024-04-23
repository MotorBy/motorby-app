import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

enum CurrentView {
  cars,
  sales
}

class HomeViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final persistentService = serviceLocator<PersistenceService>();
  final budgetingService = serviceLocator<BudgetingService>();
  final paymentService =  serviceLocator<AppPaymentService>();
  final salesService = serviceLocator<SalesService>();

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  bool hasAddedCar = false;

  BudgetingModel? budgetingModel;
  CarId? currentCar;
  List<File> addImagesList = [];

  final TextEditingController amountInputController = TextEditingController();
  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController priceInputController = TextEditingController();
  final TextEditingController addressInputController = TextEditingController();

  final List<String>? totalList = [
    'Fueling',
    'Servicing',
    'Repairing',
    'Mileage',
    'Breakdown'
  ];

  List<int>? totalCostingAndValue = [
    0,
    0,
    0,
    0,
    0
  ];

  Map<String, dynamic> budgetData = {};
  String? date = '';

  int? currentTotalSpent = 0;
  int? totalCarsAdded = 0;
  int? currentBudgetViewIndex = 0;
  int? currentBudgetTypeIndex = 0;

  List<Fueling>? fueling = [];
  List<Servicing>? servicing = [];
  List<Repairing>? repairing = [];
  List<Breakdowns>? breakdowns = [];

  CurrentView? currentViewState = CurrentView.cars;

  Future init({Function? onErrorLogout, Function? onCallBack}) async {
    initDeepLinks();

    setBusyForObject('home-loading', true);

    await userService.getUsers().onError((error, stackTrace) {
      print(stackTrace.toString());
      setError(error.toString());
    });
    await budgetingService.getBudgets().onError((error, stackTrace) {
      setError(error.toString());
    });
    await paymentService.getPlans();

    budgetingModel = budgetingService.budgetingModel;

    if(budgetingModel != null) {

      if(budgetingModel!.budget!.isNotEmpty) {

        currentCar = budgetingModel!.budget![currentBudgetViewIndex!].carId;

        hasAddedCar = true;
        totalCarsAdded = budgetingModel!.budget!.length;

        salesService.currentCar = currentCar;
        salesService.currentCarMake = currentCar!.carMake!;

        getCurrentTotalValue(index: currentBudgetViewIndex);

      }

    }

    setBusyForObject('home-loading', false);

    if(hasError) {
      if(modelError.toString().contains('jwt expired') || modelError.toString().contains('Failed/Invalid Token')) {
        if(onErrorLogout != null) {
          await logOut();
          onErrorLogout();
        }
      }
    }

    notifyListeners();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      print('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  void getCurrentTotalValue({int? index}) {

    for (var element in budgetingModel!.budget![index!].fueling!) {
      totalCostingAndValue![0] = totalCostingAndValue![0] + element.price!; ///for fueling budget will have index 0
    }

    for (var element in budgetingModel!.budget![index].servicing!) {
      totalCostingAndValue![1] = totalCostingAndValue![1] + element.price!;  ///for servicing budget will have index 1
    }

    for (var element in budgetingModel!.budget![index].repairing!) {
      totalCostingAndValue![2] = totalCostingAndValue![2] + element.price!;  ///for repairing budget will have index 2
    }

    totalCostingAndValue![3] = budgetingModel!.budget![index].mileage!;  ///for mileage budget will have index 3

    totalCostingAndValue![4] = budgetingModel!.budget![index].breakdowns!.length;  ///for breakdowns budget will have index 0

    currentTotalSpent = totalCostingAndValue![0] + totalCostingAndValue![1] + totalCostingAndValue![2];

    notifyListeners();

  }

  void onBudgetViewUpdated(int? v) {
    resetBudgetListTotalCost();

    currentBudgetViewIndex = v;
    getCurrentTotalValue(index: currentBudgetViewIndex);

    currentCar = budgetingModel!.budget![currentBudgetViewIndex!].carId;
    salesService.currentCar = currentCar;
    salesService.currentCarMake = currentCar!.carMake!;
    notifyListeners();
  }

  void updateBudgetTypeIndex({int? v}) {
    currentBudgetTypeIndex = v;

    fueling = budgetingModel!.budget![currentBudgetViewIndex!].fueling!.reversed.toList();
    servicing = budgetingModel!.budget![currentBudgetViewIndex!].servicing!.reversed.toList();
    repairing = budgetingModel!.budget![currentBudgetViewIndex!].repairing!.reversed.toList();
    breakdowns = budgetingModel!.budget![currentBudgetViewIndex!].breakdowns!.reversed.toList();

    notifyListeners();
  }

  void resetBudgetListTotalCost(){
    totalCostingAndValue = [
      0,
      0,
      0,
      0,
      0
    ];
    notifyListeners();
  }

  void resetUpdateBudgetData(){
    budgetData = {};
    date = '';
    notifyListeners();
  }

  void updateCurrentViewState() {
    if(currentViewState == CurrentView.cars) {
      currentViewState = CurrentView.sales;
    } else {
      currentViewState = CurrentView.cars;
    }
    notifyListeners();
  }

  Future updateToBudget({String? type, Function? onCallBack}) async {
    setBusy(true);
    await  budgetingService.updateOnBudget(
        budgetId: budgetingModel!.budget![currentBudgetViewIndex!].sId,
        updateBudget: {
          "data" : budgetData,
          "dataType" : type
        }
    ).then((value) async {
      setBusy(false);

      if(onCallBack != null) {

        onCallBack();
        await init();

        notifyListeners();
      }

    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(stackTrace.toString());
      }
      setBusy(false);
    });
  }

  void updateBudgetData({String? value, String? type}) {
    if(type == "amount") {
      budgetData["price"] = int.parse(value!);
    } else if (type == "date") {
      budgetData["date"] = value;
      dateInputController.text = value!;
    } else if (type == "problem") {
      budgetData["condition"] = value;
    } else if (type == "location") {
      budgetData["location"] = value;
    } else if (type == "miles") {
      budgetData["mileage"] = value;
    }  else if (type == "condition") {
      budgetData["condition"] = value;
    }  else if (type == "shop_name") {
      budgetData["shop_name"] = value;
    } else if(type == "price_per_liter") {
      budgetData["price_per_liter"] = int.parse(value!);
    } else if(type == "break_down") {
      budgetData["break_down"] = value;
    } else if(type == "cause") {
      budgetData["cause"] = value;
    }
    notifyListeners();
  }

  Future putAddedCarOnSale({
    int? amount,
    String? carId,
    Function? onCallBack,
    Function(String e)? onErrorCallBack}) async {

    setBusy(true);
    var saleData = {
      'user_id' : persistentService.getUserID,
      'data': {
        "amount_for_sale" : amount,
        "units_left": 1
      },
      'car_id': carId
    };

    if(currentCar!.images!.isNotEmpty) {

      await salesService.makeSales(salesData: saleData).then((value) {
        setBusy(false);
        onCallBack!();
      }).onError((error, stackTrace) {
        setBusy(false);
        print(stackTrace.toString());
        onErrorCallBack!(error.toString());
      });
    } else {
      setBusy(false);
      onErrorCallBack!('No image on current car for sale');

    }

  }

  Future logOut() async {
    await persistentService.deleteAll();
  }


}