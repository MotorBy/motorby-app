import 'package:mobile_auto_drive/models/get_insuraance_model.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
class InsuranceService {
  final persistService = serviceLocator<PersistenceService>();
 GetInsuranceModel? insuranceProduct;

  Future getInsuranceList() async {

    var response = await http.get(Uri.parse(APIService.getInsuranceProducts),
        headers: APIHelper().requestHeadersWithToken());
    final json = JSON.jsonDecode(response.body);

    print(json.toString());
    print(APIHelper().requestHeaders());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

   insuranceProduct=GetInsuranceModel.fromJson(json);
  
      return insuranceProduct;

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }}