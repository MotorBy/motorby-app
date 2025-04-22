import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/fuel_price_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/permission_handling.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class InfoDetailsViewModel extends BaseViewModel {
  final budgetingService = serviceLocator<BudgetingService>();
  final userService = serviceLocator<UserService>();
  final persistentService = serviceLocator<PersistenceService>();

  Position? currentPosition;
  bool? locationDeclined = false;

  String? currentWeatherValue = '0.0';
  String? currentWeatherDescription = 'No weather';
  String? weatherGuideDescription = '';

  int? currentBudgetViewIndex = 0;
  int? currentBudgetTypeIndex = 0;
  int? currentTotalSpent = 0;
  int? totalCarsAdded = 0;

  int currentSetBudget = 0;

  String? permissionLocationStatement = 'For the best experience on the Motorby app, allow location access. '
      'This will enable features like current weather updates and nearby points of interest.';

  FuelData? fuelData;
  String? currentFuelPrice = '0';

  final TextEditingController amountInputController = TextEditingController();
  final TextEditingController dateInputController = TextEditingController();
  final TextEditingController cityInputController = TextEditingController();
  final TextEditingController milesInputController = TextEditingController();
  final TextEditingController budgetInputController = TextEditingController();
  final TextEditingController priceInputController = TextEditingController();
  final TextEditingController problemInputController = TextEditingController();
  final TextEditingController addressInputController = TextEditingController();

  Map<String, dynamic> budgetData = {};
  String? date = '';
  BudgetingModel? budgetingModel;
  CarId? currentCar;
  List<Fueling>? fueling = [];
  List<Servicing>? servicing = [];
  List<Repairing>? repairing = [];
  List<Breakdowns>? breakdowns = [];
  List<int>? totalCostingAndValue = [];

  Map<String, dynamic> addressInput = {};

  void initializeTotalCostingAndValue() {
    budgetingModel = budgetingService.budgetingModel;

    if (budgetingModel != null && budgetingModel!.budget!.isNotEmpty) {
      budgetingService.getCurrentTotalValue(index: 0);
      totalCostingAndValue = budgetingService.totalCostingAndValue;
      notifyListeners();
    }

    weatherSetup();

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

  void promoteLocationPermission ({bool? willDecline = false}) {

    if(willDecline == false) {

      PermissionUtil().isLocationServiceAndPermissionsActive().then((value) {
        if (value == false) {
          PermissionUtil.requestPermission(Permission.location);
        }
        weatherSetup();
      });

    } else {

      locationDeclined = true;
      notifyListeners();

    }

  }

  void weatherSetup() {

    if(userService.weatherData != null) {

      currentWeatherValue = userService.weatherData!.payload!.tempMax!.toString();
      currentWeatherDescription = userService.weatherData!.payload!.description;
      weatherGuideDescription = userService.weatherData!.payload!.weatherDriveInstruction;

    } else {
      currentWeatherDescription = 'No weather at the moment';
    }

    notifyListeners();

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

  Future updateToBudget({String? type, Function? onCallBack}) async {
    setBusy(true);
    await budgetingService.updateOnBudget(
        budgetId: budgetingModel!.budget![0].sId,
        updateBudget: {
          "data" : budgetData,
          "dataType" : type
        }
    ).then((value) async {
      setBusy(false);

      if(onCallBack != null) {
        resetUpdateBudgetData();
        onCallBack();
      }

      notifyListeners();

    }).onError((error, stackTrace) {
      print(stackTrace.toString());
      setBusy(false);
    });
  }

  void updateCurrentInputAddress({Map<String, dynamic>? address}){
    addressInput = address!;
    print(addressInput.toString());
    notifyListeners();
  }

  void updateBudgetTypeIndex({int? v}) {
    fueling = budgetingModel!.budget![0].fueling!.reversed.toList();
    servicing = budgetingModel!.budget![0].servicing!.reversed.toList();
    repairing = budgetingModel!.budget![0].repairing!.reversed.toList();
    breakdowns = budgetingModel!.budget![0].breakdowns!.reversed.toList();

    notifyListeners();
  }
}