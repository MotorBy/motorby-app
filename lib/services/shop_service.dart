import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/shops_model.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'dart:convert' as JSON;

import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class ShopService {
  final persistService = serviceLocator<PersistenceService>();

  ShopsModel? shopsModel;

  Future createShop({Map<String, dynamic>? shopData}) async {
    final jsonData = JSON.json.encode(shopData);

    var response = await http.post(Uri.parse(APIService.createShop),

        headers: APIHelper().requestHeadersWithToken(), body: jsonData);
    final json = JSON.jsonDecode(response.body);

    if (kDebugMode) {
      print(json);
      print(jsonData);
      print(APIService.createShop);
    }

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      await getShops();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future getShops({String? into, String? supportMake}) async {

    String? url = APIService.getShops;

    if(into != null || supportMake != null) {
      url = '$url?';
    }

    if(into != null) {
      url = "${url}into=$into";
    }
    if(supportMake != null) {
      url = "${url}support_make=$supportMake";
    }

    var response = await http.get(Uri.parse(url),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {

      if (kDebugMode) {
        print(json);
        print(url);
      }

      ShopsModel? res = ShopsModel.fromJson(json);
      shopsModel = res;

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

}