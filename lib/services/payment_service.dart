import 'dart:developer';

import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:mobile_auto_drive/models/current_plans_model.dart';
import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'dart:convert' as JSON;

import 'api_services.dart';

class AppPaymentService {
  final userService = serviceLocator<UserService>();

  PlanModel? planModel;
  PlansModel? currentPlansModel;
  PaystackTransactionVerified? paystackTransactionVerified;

  Future getPlans() async {

    var response = await http.get(Uri.parse(APIService.getPlans),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {

      planModel = PlanModel.fromJson(json);
      return planModel;

    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future getCurrentPlans() async {

    var response = await http.get(Uri.parse(APIService.getCurrentPlans),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    print(json);

    if(response.statusCode == 200 || response.statusCode == 201) {

      currentPlansModel = PlansModel.fromJson(json);
      return currentPlansModel;

    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future createPayment({Map<String, dynamic>? payment}) async {
    final jsonData = JSON.json.encode(formatObject(payment));

    var response = await http.post(Uri.parse(APIService.makePayment),
        headers: APIHelper().requestHeadersWithToken(), body: jsonData);

    log(response.body);

    final json = JSON.jsonDecode(response.body);

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      await userService.getUsers();
      await getCurrentPlans();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }


}