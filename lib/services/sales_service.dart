import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/sales_model.dart';
import 'dart:convert' as JSON;

import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';

class SalesService {

  SalesListModel? salesListModel;
  SalesModel? currentSalesModel;
  String? currentCarMake;
  CarId? currentCar;

  Future getSales({String? carMake, String? carYear}) async {

    String? getSUrl = APIService.getSales;

    if(currentCarMake != null && currentCarMake != 'all') {
      getSUrl = "$getSUrl?car_make=$currentCarMake";
    } else {
      getSUrl = getSUrl;
    }

    var response = await http.get(Uri.parse(getSUrl),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {

      SalesListModel? response = SalesListModel.fromJson(json);
      salesListModel = response;

      return salesListModel;

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future makeSales({Map<String, dynamic>? salesData}) async {
    final jsonData = JSON.json.encode(salesData);

    var response = await http.post(Uri.parse(APIService.makeSales),
        headers: APIHelper().requestHeadersWithToken(), body: jsonData);
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future getASale({String? salesId}) async {

    var response = await http.get(Uri.parse(APIService.sales(saleId: salesId)),
        headers: APIHelper().requestHeadersWithToken(),);

    final json = JSON.jsonDecode(response.body);

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      currentSalesModel = SalesModel.fromJson(json['payload']);
    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future updateSales({Map<String, dynamic>? salesData, String? salesId}) async {
    final jsonData = JSON.json.encode(salesData);

    var response = await http.put(Uri.parse(APIService.sales(saleId: salesId)),
        headers: APIHelper().requestHeadersWithToken(), body: jsonData);
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      await getASale(salesId: salesId);

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

}