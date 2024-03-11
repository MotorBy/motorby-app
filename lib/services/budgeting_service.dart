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

  Future getBudgets() async {

    var response = await http.get(Uri.parse(APIService.getBudget(userId: persistService.getUserID)),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

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
      throw Exception(error);
    }

  }

}