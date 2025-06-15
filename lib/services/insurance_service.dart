import 'package:mobile_auto_drive/models/get_insurance_product_model.dart';
import 'package:mobile_auto_drive/models/insurance_bought_model.dart';
import 'package:mobile_auto_drive/models/insurance_product_details.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
class InsuranceService {
  final persistService = serviceLocator<PersistenceService>();

 GetInsuranceModel? insuranceProduct;
 GetInsuranceProduct? insuranceProductDetails;
 InsuranceBoughtModel? insuranceBoughtModel;
 String? currentInsuranceId = '';

  Future getInsuranceList() async {

    var response = await http.get(Uri.parse(APIService.getInsuranceProducts),
        headers: APIHelper().requestHeadersWithToken());
      final json = JSON.jsonDecode(response.body);

      print(json.toString());

      if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      insuranceProduct = GetInsuranceModel.fromJson(json);
  
      return insuranceProduct;

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future getInsuranceProductDetails({String? productId}) async {
    print(APIService.getInsuranceProductsDetails+productId!);

    var response = await http.get(Uri.parse(APIService.getInsuranceProductsDetails+productId!),
        headers: APIHelper().requestHeadersWithToken());
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      insuranceProductDetails = GetInsuranceProduct.fromJson(json);
      return insuranceProductDetails;

    } else {

      var error = json["message"];
      throw Exception(error);

    }
  }

  Future getBoughtInsurance() async {

    var response = await http.get(Uri.parse(APIService.getBoughtInsuranceProducts),
        headers: APIHelper().requestHeadersWithToken());
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      insuranceBoughtModel = InsuranceBoughtModel.fromJson(json);
      return insuranceBoughtModel;

    } else {

      var error = json["message"];
      throw Exception(error);

    }
  }

  Future purchaseInsurance(Map<String, dynamic> purchaseData) async {

    print(purchaseData.toString());

    var response = await http.post(Uri.parse(APIService.getBuyInsuranceProducts),
        headers: APIHelper().requestHeadersWithToken(),
        body: JSON.jsonEncode(purchaseData));

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      return json;

    } else {

      var error = json["message"];
      throw Exception(error);

    }

  }

}