import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/vin_data_model.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';

class VinCheckService {

  VinDataModel? vinDataModel;

  Future vinCheckSetup({String? vinType, String? vinNumber}) async {

    String? vinUrl;

    if(vinType == 'basic') {
      vinUrl = APIService.vinCheck(vinNumber: vinNumber, vinType: 'vin_decoder_basic');
    } else if(vinType == "standard"){
      vinUrl = APIService.vinCheck(vinNumber: vinNumber, vinType: 'vin_decoder_standard');
    } else if(vinType == "lite") {
      vinUrl = APIService.vinCheck(vinNumber: vinNumber, vinType: 'vin_decoder_lite');
    }

    var response = await http.get(Uri.parse(vinUrl!),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {
      VinDataModel? vinRes = VinDataModel.fromJson(json);
      vinDataModel = vinRes;
      return vinRes;
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

}