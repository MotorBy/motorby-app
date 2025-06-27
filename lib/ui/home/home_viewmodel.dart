import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/models/fuel_price_model.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/checklist_service.dart';
import 'package:mobile_auto_drive/services/insurance_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/services/sales_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/permission_handling.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

enum CurrentView {
  cars,
  sales
}

class HomeViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final authService = serviceLocator<AuthService>();
  final persistentService = serviceLocator<PersistenceService>();
  final budgetingService = serviceLocator<BudgetingService>();
  final paymentService =  serviceLocator<AppPaymentService>();
  final salesService = serviceLocator<SalesService>();
  final checklistService = serviceLocator<ChecklistService>();
  final reminderService =  serviceLocator<ReminderService>();
  final insuranceService = serviceLocator<InsuranceService>();

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  bool hasAddedCar = false;

  BudgetingModel? budgetingModel;
  CarId? currentCar;
  Budget? currentBudget;

  ChecklistDataModel? checkListDataModel;
  ReminderListModel? reminderListModel;

  UserModel? userModel;
  List<File> addImagesList = [];

  final TextEditingController amountInputController = TextEditingController();
  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController cityInputController = TextEditingController();
  final TextEditingController milesInputController = TextEditingController();
  final TextEditingController budgetInputController = TextEditingController();
  final TextEditingController priceInputController = TextEditingController();
  final TextEditingController problemInputController = TextEditingController();
  final TextEditingController addressInputController = TextEditingController();

  final List<String>? totalList = [
    'Fueling',
    'Servicing',
    'Repairing',
    'Mileage',
    'Breakdown'
  ];

  final List<String>? manageIcons = [
    'fuel.png',
    'servicing.png',
    'repairing.png',
    'mph.png',
    'breakdowns.png'
  ];

  final List<CheckList> checkList = [
    CheckList(title: 'Fluids (oil and coolant)',isChecked: false),
    CheckList(title: 'Brakes',isChecked: false),
    CheckList(title: 'Lights',isChecked: false),
    CheckList(title: 'Wiper blades',isChecked: false),
    CheckList(title: 'Horn',isChecked: false),
    CheckList(title: 'Tyres',isChecked: false),
    CheckList(title: 'Documents and licenses',isChecked: false),
  ];

  void toggleItem(int index) {
      checkList[index].isChecked = !checkList[index].isChecked;
      notifyListeners();
  }

  List<int>? totalCostingAndValue = [
    0,
    0,
    0,
    0,
    0
  ];

  Map<String, dynamic> budgetData = {};
  Map<String, dynamic>? lastBudget;
  LastBudget? lastBudgetModel;

  int? currentTotalSpent = 0;
  int? currentBudgetViewIndex = 0;
  int? currentBudgetTypeIndex = 0;

  List<Fueling>? fueling = [];
  List<Servicing>? servicing = [];
  List<Repairing>? repairing = [];
  List<Breakdowns>? breakdowns = [];

  Position? currentPosition;
  bool? locationDeclined = false;

  CurrentView? currentViewState = CurrentView.cars;
  String? currentWeatherValue = '0';
  String? currentWeatherDescription = 'No weather';
  String? weatherGuideDescription = '';

  int currentSetBudget = 0;

  String? permissionLocationStatement = 'For the best experience on the Motorby app, allow location access. '
      'This will enable features like current weather updates and nearby points of interest.';

  FuelData? fuelData;
  String? currentFuelPrice = '0';

  Future init({Function? onErrorLogout, Function? onCallBack, Function? onPermissionCallBack}) async {

    initDeepLinks();
    setBusyForObject('home-loading', true);

    await userService.getUsers().onError((error, stackTrace) {
      setError(error.toString());
    });

    if(hasError) {

      if(modelError.toString().contains('jwt expired') ||
          modelError.toString().contains('Failed/Invalid Token')) {
        if(onErrorLogout != null) {
          authService.hasUser = false;
          await logOut();
          onErrorLogout();
        }
      }

      setBusyForObject('home-loading', false);

    } else {

      await budgetingService.getBudgets();
      await paymentService.getPlans();
      await reminderService.getReminders();
      await userService.getCurrentFuelPrice(
          country: userService.userModel!.payload!.user!.country,
          state: userService.userModel!.payload!.user!.state,
      );

      userModel = userService.userModel;
      reminderListModel = reminderService.reminderListModel;
      fuelData = userService.fuelData;

      onPermissionCallBack?.call();

      if(fuelData != null) {
        currentFuelPrice = fuelData!.payload!.toInt().toString();
      }

      lastBudget = budgetingService.lastBudget;
      if(lastBudget != null) {

        var isFuture = budgetingService.isFutureSpending(date: lastBudget!["data"]["date"]);

        lastBudgetModel = LastBudget.fromJson({
          ...lastBudget!["data"],
          "budget_type" : lastBudget!["dataType"],
          "is_future_budget" : isFuture,
        });

        print(lastBudgetModel?.toJson().toString());
      }

      onBudgetViewUpdated(0);
      setBusyForObject('home-loading', false);

    }

    notifyListeners();
  }

  List<ReminderPayload> getReminderLists() {
    if(reminderListModel != null) {
      if(reminderListModel!.data.isNotEmpty && reminderListModel!.data.length > 5) {
        return reminderListModel!.data.sublist(0, 5);
      }
      return reminderListModel!.data;
    } else {
      return [];
    }
  }

  void weatherSetup() {

    userService.getWeather(lng: currentPosition!.longitude.toString(), lat: currentPosition!.latitude.toString(),).then((value) {

      if(userService.weatherData != null) {

        currentWeatherValue = userService.weatherData!.payload!.tempMax!.toInt().toString();
        currentWeatherDescription = userService.weatherData!.payload!.description;
        weatherGuideDescription = userService.weatherData!.payload!.weatherDriveInstruction;

      } else {
        currentWeatherDescription = 'No weather at the moment';
      }

      notifyListeners();

    });

  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialLinkString();
    if (appLink != null) {
      print('getInitialAppLink: $appLink');
      openAppLink(Uri(path: appLink));
    }

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

  void onBudgetViewUpdated(int? v) {

    budgetingModel = budgetingService.budgetingModel;
    currentBudgetViewIndex = v;

    fuelData = userService.fuelData;

    budgetingService.getCurrentTotalValue(index: v);
    currentBudget = budgetingService.currentBudget;

    totalCostingAndValue = budgetingService.totalCostingAndValue;
    currentTotalSpent = budgetingService.currentTotalSpent;
    notifyListeners();

    if(budgetingModel!.budget!.isNotEmpty) {
      hasAddedCar = true;

      currentCar = budgetingModel!.budget![currentBudgetViewIndex!].carId;
      salesService.currentCar = currentCar;
      salesService.currentCarMake = currentCar!.carMake!;
      currentSetBudget = budgetingModel!.budget![currentBudgetViewIndex!].budget!;
      budgetingService.currentCar = currentCar;
      notifyListeners();

      getChecklistDataModel();

    }

    notifyListeners();

  }

  Future<void> getChecklistDataModel() async {
    final response = await checklistService.getCarChecklist(currentCar!.sId!);
    checkListDataModel = response;
  }

  void updateBudgetTypeIndex({int? v}) {
    currentBudgetTypeIndex = v;

    fueling = budgetingModel!.budget![currentBudgetViewIndex!].fueling!.reversed.toList();
    servicing = budgetingModel!.budget![currentBudgetViewIndex!].servicing!.reversed.toList();
    repairing = budgetingModel!.budget![currentBudgetViewIndex!].repairing!.reversed.toList();
    breakdowns = budgetingModel!.budget![currentBudgetViewIndex!].breakdowns!.reversed.toList();

    notifyListeners();
  }

  void resetUpdateBudgetData() {

    amountInputController.clear();
    dateInputController.clear();
    cityInputController.clear();
    milesInputController.clear();
    budgetInputController.clear();
    priceInputController.clear();
    problemInputController.clear();
    addressInputController.clear();

    budgetData = {};
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

        resetUpdateBudgetData();

        await budgetingService.getBudgets();
        budgetingService.getCurrentTotalValue(index: currentBudgetViewIndex);

        totalCostingAndValue = budgetingService.totalCostingAndValue;
        currentTotalSpent = budgetingService.currentTotalSpent;
        currentSetBudget = budgetingService.currentSetBudget;

        onCallBack();

      }

      notifyListeners();

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
    }  else if (type == "fuel_station_name") {
      budgetData["fuel_station_name"] = value;
    } else if(type == "price_per_liter") {
      budgetData["price_per_liter"] = int.parse(value!);
    } else if(type == "break_down") {
      budgetData["break_down"] = value;
    } else if(type == "cause") {
      budgetData["cause"] = value;
    } else if(type == "budgeting") {
      budgetData["budget_amount"] = value;
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

  void getLocationUpdate() {

    Geolocator.getLastKnownPosition().then((Position? position) async {
      currentPosition = position;
      if(currentPosition != null) {
        weatherSetup();
      }
    });

  }

  Future logOut() async {
    await persistentService.deleteAll();
  }

}

class CheckList{
  final String title;
  bool isChecked;

  CheckList({required this.title,this.isChecked =false});
  
}