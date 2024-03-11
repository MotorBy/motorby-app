import 'dart:developer';

import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

bool get isBusiness => serviceLocator<UserService>().userModel != null
    ? serviceLocator<UserService>().userModel!.payload!.userType! != 'USER'
    : false;

class UserService {
  final persistService = serviceLocator<PersistenceService>();
  final budgetService = serviceLocator<BudgetingService>();

  UserModel? userModel;

  bool? isBusiness;

  Future getUsers() async {

    var response = await http.get(Uri.parse(APIService.getUser(id: persistService.getUserID)),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {
      UserModel? user = UserModel.fromJson(json);
      userModel = user;
      isBusiness = userModel!.payload!.userType != 'USER';
      return userModel;
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future updateUsers({Map<String, dynamic>? data}) async {

    final jsonData = JSON.json.encode(data);

    var response = await http.put(
        Uri.parse(APIService.getUser(id: persistService.getUserID)),
        body: jsonData,
        headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {
      await getUsers();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future addACar({Map<String, dynamic>? carData}) async {

    final jsonData = JSON.json.encode(carData);

    log(APIService.addCars);

    var response = await http.post(Uri.parse(APIService.addCars),
        headers: APIHelper().requestHeadersWithToken(), body: jsonData);

    final json = JSON.jsonDecode(response.body);

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      await budgetService.getBudgets();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

}