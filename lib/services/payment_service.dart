import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'dart:convert' as JSON;

import 'api_services.dart';

class AppPaymentService {
  final userService = serviceLocator<UserService>();

  PlanModel? planModel;

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

  Future createPayment() async {

  }


}