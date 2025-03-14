import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/fuel_price_model.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
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

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  bool hasAddedCar = false;

  BudgetingModel? budgetingModel;
  CarId? currentCar;
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

final List<CheckList> checkList =[
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
  String? date = '';

  int? currentTotalSpent = 0;
  int? totalCarsAdded = 0;
  int? currentBudgetViewIndex = 0;
  int? currentBudgetTypeIndex = 0;

  List<Fueling>? fueling = [];
  List<Servicing>? servicing = [];
  List<Repairing>? repairing = [];
  List<Breakdowns>? breakdowns = [];

  Position? currentPosition;
  bool? locationDeclined = false;

  CurrentView? currentViewState = CurrentView.cars;
  String? currentWeatherValue = '0.0';
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
      print(stackTrace.toString());
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

      resetBudgetListTotalCost();

      await budgetingService.getBudgets();
      await paymentService.getPlans();
      await userService.getCurrentFuelPrice(
          country: userService.userModel!.payload!.user!.country,
          state: userService.userModel!.payload!.user!.state,
      );

      budgetingModel = budgetingService.budgetingModel;
      fuelData = userService.fuelData;

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

      if(onPermissionCallBack != null) {
        onPermissionCallBack();
      }

      if(fuelData != null) {
        currentFuelPrice = fuelData!.payload!.toInt().toString();
      }

      setBusyForObject('home-loading', false);

    }

    print('has user in app: $hasUserSetup');
    notifyListeners();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      print('getInitialAppLink: $appLink');
      openAppLink(appLink);
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

    //currentTotalSpent = totalCostingAndValue![0] + totalCostingAndValue![1] + totalCostingAndValue![2];
    currentTotalSpent = budgetingModel!.budget![currentBudgetViewIndex!].currentSpending ?? 0;
    currentSetBudget = budgetingModel!.budget![currentBudgetViewIndex!].budget ?? 0;

    notifyListeners();

  }

  void onBudgetViewUpdated(int? v) {
    resetBudgetListTotalCost();

    currentBudgetViewIndex = v;
    getCurrentTotalValue(index: currentBudgetViewIndex);

    currentCar = budgetingModel!.budget![currentBudgetViewIndex!].carId;
    salesService.currentCar = currentCar;
    salesService.currentCarMake = currentCar!.carMake!;
    currentSetBudget = budgetingModel!.budget![currentBudgetViewIndex!].budget!;
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

  void promoteLocationPermission ({bool? willDecline = false}) {

    if(willDecline == false) {

      PermissionUtil().isLocationServiceAndPermissionsActive().then((value) {
        if (value == false) {
          PermissionUtil.requestPermission(Permission.location);
        }
      });

      Geolocator.getLastKnownPosition().then((Position? position) async {
        currentPosition = position;
        if(currentPosition != null) {
          weatherSetup();
        }
      });

    } else {

      locationDeclined = true;
      notifyListeners();

    }

  }

  void weatherSetup() {

    userService.getWeather(lng: currentPosition!.longitude.toString(), lat: currentPosition!.latitude.toString(),).then((value) {

      if(userService.weatherData != null) {

        currentWeatherValue = userService.weatherData!.payload!.tempMax!.toString();
        currentWeatherDescription = userService.weatherData!.payload!.description;
        weatherGuideDescription = userService.weatherData!.payload!.weatherDriveInstruction;

      } else {
        currentWeatherDescription = 'No weather at the moment';
      }

      notifyListeners();

    });

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

        resetBudgetListTotalCost();
        resetUpdateBudgetData();

        await budgetingService.getBudgets();
        getCurrentTotalValue(index: currentBudgetViewIndex);

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

  Future updateCurrentFuelPrice({
    int? price,
    String? city,
    String? petrolStation,
    Function? onCallBack,
    Function(String e)? onErrorCallBack}) async {

    setBusy(true);

    var dataToUpdate = {
      "country" : userService.userModel!.payload!.user!.country,
      "state": userService.userModel!.payload!.user!.state ?? '',
      "priceList" : {
        "price_per_liter" : price,
        "gas_station_name": petrolStation,
        "price_input_by": persistentService.getUserID,
        "location": {
          "city": city,
          "lat": currentPosition != null ? currentPosition?.latitude.toString() : "",
          "lng": currentPosition != null ? currentPosition?.longitude.toString() : ""
        }
      }
    };

    await userService.updateFuelPrice(
      updateData: dataToUpdate,
      country: userService.userModel!.payload!.user!.country,
      state: userService.userModel!.payload!.user!.state
    ).then((value) {

      fuelData = userService.fuelData;
      if(fuelData != null) {
        currentFuelPrice = fuelData!.payload!.toInt().toString();
      }

      setBusy(false);
      onCallBack!();

    }).onError((error, stackTrace) {

      print(stackTrace);
      setBusy(false);
      onErrorCallBack!(error.toString());

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