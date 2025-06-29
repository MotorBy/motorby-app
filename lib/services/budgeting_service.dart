import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'dart:convert' as JSON;

import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/checklist_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class BudgetingService {
  final persistService = serviceLocator<PersistenceService>();

  BudgetingModel? budgetingModel;
  Map<String, dynamic>? lastBudget;
  CarId? currentCar;
  Budget? currentBudget;

  int? _vehicleValue;
  int? get vehicleValue => _vehicleValue;

  int? currentTotalSpent = 0;
  int currentSetBudget = 0;
  int? currentBudgetIndex = 0;

  String? totalMileage = "0";
  String? lastDateTrip = "";
  String? lastTraveled = "0";
  String? currentMileage = "0";
  String? lastRefuelDate = '';
  String? lastRefuelAmount = '';
  double? fuelEfficiency = 0.0;

  List<int>? totalCostingAndValue = [
    0,
    0,
    0,
    0,
    0
  ];

  void resetTotalCostingAndValue() {
    totalCostingAndValue = [
      0,
      0,
      0,
      0,
      0
    ];
  }

  void getCurrentTotalValue({int? index}) {
    resetTotalCostingAndValue();
    currentBudgetIndex = index;

    if(budgetingModel!.budget!.isNotEmpty) {

      currentCar = budgetingModel!.budget?[index!].carId;
      currentBudget = budgetingModel!.budget![index!];

      _vehicleValue = currentCar != null ? currentCar!.amountBought : 0;

      for (var element in budgetingModel!.budget![index].fueling!) {
        totalCostingAndValue![0] = totalCostingAndValue![0] + element.price!; ///for fueling budget will have index 0
      }

      if(budgetingModel!.budget![index].servicing != null) {

        for (var element in budgetingModel!.budget![index].servicing!) {
          totalCostingAndValue![1] = totalCostingAndValue![1] + element.price!;  ///for servicing budget will have index 1
        }

      }

      if(budgetingModel!.budget![index].repairing != null) {

        for (var element in budgetingModel!.budget![index].repairing!) {
          totalCostingAndValue![2] = totalCostingAndValue![2] + element.price!;  ///for repairing budget will have index 2
        }

      }

      totalCostingAndValue![3] = budgetingModel!.budget![index].mileage!;  ///for mileage budget will have index 3
      totalCostingAndValue![4] = budgetingModel!.budget![index].breakdowns!.length;  ///for breakdowns budget will have index 4

      currentTotalSpent = budgetingModel!.budget![index].currentSpending ?? 0;
      currentSetBudget = budgetingModel!.budget![index].budget ?? 0;

      if(persistService.getLastSpending != null) {
        lastBudget = JSON.jsonDecode(persistService.getLastSpending!);
      }

      getMileageData();
      getFuelingData();

    }

  }

  void getMileageData() {

    if(currentBudget != null && currentBudget!.mileageData!.isNotEmpty) {

      final latestMileage = int.tryParse(currentBudget!.mileageData!.last.odometerReading ?? '0') ?? 0;
      final firstMileage = int.tryParse(currentBudget!.mileageData!.first.odometerReading ?? '0') ?? 0;

      totalMileage = (latestMileage - firstMileage).toString();
      currentMileage = latestMileage.toString();

      // Set last trip data
      final lastTrip = currentBudget!.mileageData!.last;
      lastDateTrip = lastTrip.inputDate?.toString().split(' ')[0] ?? '';

      if (currentBudget!.mileageData!.length > 1) {
        final previousMileage = int.tryParse(
            currentBudget!.mileageData![currentBudget!.mileageData!.length - 2].odometerReading ?? '0'
        ) ?? 0;
        lastTraveled = (latestMileage - previousMileage).toString();
      } else {
        lastTraveled = "0";
      }

    } else {
      totalMileage = "0";
      lastDateTrip = "";
      lastTraveled = "0";
      currentMileage = "0";
    }

  }

  void getFuelingData() {

    if (currentBudget != null && currentBudget!.fueling!.isNotEmpty) {
      final lastFueling = currentBudget!.fueling!.last;
      lastRefuelDate = lastFueling.date ?? '';
      lastRefuelAmount = amtFormatter(lastFueling.price);

      if (currentBudget!.mileageData != null && currentBudget!.mileageData!.length > 1) {
        final totalDistance = int.parse(totalMileage!);
        double totalLiters = 0.0;

        for (var fuel in currentBudget!.fueling!) {
          if (fuel.price != null && fuel.pricePerLiter != null && fuel.pricePerLiter! > 0) {
            totalLiters += fuel.price! / fuel.pricePerLiter!;
          }
        }
        if (totalLiters > 0) {
          fuelEfficiency = (totalDistance / totalLiters).roundToDouble(); // km/L
        }
      }
    } else {
      lastRefuelDate = '';
      lastRefuelAmount = '0';
      fuelEfficiency = 0.0;
    }

  }

  String getCheckListStatus() {
    if(currentBudget != null) {
      return "${currentBudget!.checklistData!.items!.where((item) => item.isChecked == true).length}/${currentBudget!.checklistData!.items!.length}";
    }
    return "0/0";
  }

  bool isFutureSpending({String? date}) {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    DateTime budgetDate;
    DateFormat inputFormat = DateFormat('d-M-yyyy'); // 'd' for day, 'M' for month, 'yyyy' for year
    budgetDate = inputFormat.parse(date!);

    bool isFutureSpending = budgetDate.isAfter(currentDate);
    print("Is for future spending: ${isFutureSpending.toString()}");

    return isFutureSpending;

  }

  Future getBudgets() async {

    var response = await http.get(Uri.parse(APIService.getBudget(userId: persistService.getUserID)),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {

      BudgetingModel? res = BudgetingModel.fromJson(json);
      budgetingModel = res;

      return budgetingModel;
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future updateOnBudget({Map<String, dynamic>? updateBudget, String? budgetId}) async {

    final jsonData = JSON.json.encode(updateBudget);

    print(jsonData.toString());

    var response = await http.put(
        Uri.parse(APIService.updateBudget(budgetId: budgetId)),
        body: jsonData,
        headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {

      persistService.setLastSpending(jsonData);
      await getBudgets();

    } else {

      var error = json["message"];
      print(error);
      throw Exception(error);

    }

  }

}

class FuelMileageData {
  String? totalMileage = "0";
  String? lastDateTrip = "";
  String? lastTraveled = "0";
  String? currentMileage = "0";
  String? lastRefuelDate = '';
  String? lastRefuelAmount = '0';
  double? fuelEfficiency = 0.0;

  FuelMileageData({
    this.currentMileage,
    this.lastTraveled,
    this.lastDateTrip,
    this.totalMileage,
    this.fuelEfficiency,
    this.lastRefuelAmount,
    this.lastRefuelDate,
  });

}