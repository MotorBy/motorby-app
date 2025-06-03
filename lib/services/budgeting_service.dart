import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'dart:convert' as JSON;

import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class BudgetingService {
  final persistService = serviceLocator<PersistenceService>();

  BudgetingModel? budgetingModel;
  CarId? currentCar;

  int? _vehicleValue;
  int? get vehicleValue => _vehicleValue;

  int? currentTotalSpent = 0;
  int currentSetBudget = 0;
  int? currentBudgetIndex = 0;
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
      _vehicleValue = currentCar != null ? currentCar!.amountBought : 0;

      for (var element in budgetingModel!.budget![index!].fueling!) {
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

    }

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
      await getBudgets();
    } else {
      var error = json["message"];
      print(error);
      throw Exception(error);
    }

  }

}