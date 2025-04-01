import 'dart:convert';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;

class ChecklistService {
  ChecklistDataModel? checklistDataModel;

  Future<ChecklistDataModel> getCarChecklist(String carId) async {

    var response = await http.get(
      Uri.parse(APIService.getChecklist(carId: carId)),
      headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {

      checklistDataModel = ChecklistDataModel.fromJson(json);
      return checklistDataModel!;

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> updateCarChecklist({
    required String checkListId,
    String? frequency, // Add frequency as a string
    required List<Map<String, dynamic>> items,
  }) async {
    
    final jsonData = JSON.json.encode({
      'items': items,
      'frequency': frequency,
      'id': checkListId,
    });

    var response = await http.put(
      Uri.parse(APIService.updateChecklist(id: checkListId)),
      body: jsonData,
      headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json;
    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> updateChecklistFrequency({
    required String carId,
    required String frequency,
  }) async {
    final jsonData = JSON.json.encode({'frequency': frequency});

    var response = await http.patch(
      Uri.parse(APIService.updateChecklistFrequency(carId: carId)),
      body: jsonData,
      headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json;
    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

}

final List<Map<String, String>> checklistItems = [
  {'key': 'engine_condition', 'title': 'Engine Condition'},
  {'key': 'battery_health', 'title': 'Battery Health'},
  {'key': 'air_conditioning', 'title': 'Air Conditioning'},
  {'key': 'exhaust_system', 'title': 'Exhaust System'},
  {'key': 'transmission', 'title': 'Transmission'},
  {'key': 'fluids', 'title': 'Fluids'},
  {'key': 'oil_level', 'title': 'Oil Level'},
  {'key': 'coolant_level', 'title': 'Coolant Level'},
  {'key': 'brake_fluid', 'title': 'Brake Fluid'},
  {'key': 'power_steering_fluid', 'title': 'Power Steering Fluid'},
  {'key': 'brakes', 'title': 'Brakes'},
  {'key': 'brake_pads', 'title': 'Brake Pads'},
  {'key': 'suspension', 'title': 'Suspension'},
  {'key': 'shock_absorbers', 'title': 'Shock Absorbers'},
  {'key': 'steering_components', 'title': 'Steering Components'},
  {'key': 'lights', 'title': 'Lights'},
  {'key': 'wiper_blades', 'title': 'Wiper Blades'},
  {'key': 'horn', 'title': 'Horn'},
  {'key': 'tyres', 'title': 'Tyres'},
  {'key': 'tyre_pressure', 'title': 'Tyre Pressure'},
  {'key': 'body_condition', 'title': 'Body Condition'},
  {'key': 'airbags', 'title': 'Airbags'},
  {'key': 'seat_belts', 'title': 'Seat Belts'},
  {'key': 'mirrors', 'title': 'Mirrors'},
  {'key': 'documents', 'title': 'Documents'},
];