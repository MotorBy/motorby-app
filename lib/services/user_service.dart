import 'dart:developer';

import 'package:mobile_auto_drive/models/fuel_price_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/models/weather_data.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/notification_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

bool get isBusiness => serviceLocator<UserService>().userModel != null
    ? serviceLocator<UserService>().userModel!.payload!.user!.userType != 'USER'
    : false;

class UserService {
  final persistService = serviceLocator<PersistenceService>();
  final authService = serviceLocator<AuthService>();
  final budgetService = serviceLocator<BudgetingService>();

  UserModel? userModel;
  bool? isBusiness;
  WeatherData? weatherData;
  FuelData? fuelData;

  Future getUsers() async {

    var response = await http.get(Uri.parse(APIService.getUser(id: persistService.getUserID)),
        headers: APIHelper().requestHeadersWithToken());

    print(APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    print(json.toString());
    print(persistService.getUserToken);
    print(NotificationService.fcmToken);

    if(response.statusCode == 200 || response.statusCode == 201) {
      UserModel? user = UserModel.fromJson(json);
      userModel = user;
      isBusiness = userModel!.payload!.user!.userType != 'USER';
      authService.hasUser = true;
      return userModel;
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future updateUsers({Map<String, dynamic>? data}) async {

    final jsonData = JSON.json.encode(data);

    var response = await http.put(
        Uri.parse('${APIService.getUser(id: persistService.getUserID)}/update'),
        body: jsonData,
        headers: APIHelper().requestHeadersWithToken()
    );

    print(response.body);

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {
      await getUsers();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future addACar({Map<String, dynamic>? carData, String? action = 'add'}) async {

    final jsonData = JSON.json.encode(carData);

    log(APIService.addCars);

    var response = await http.post(Uri.parse(APIService.addCars),
        headers: APIHelper().requestHeadersWithToken(), body: jsonData);

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      await budgetService.getBudgets();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future uploadCarDocuments({Map<String, dynamic>? documents, String? carId}) async {

    final jsonData = JSON.json.encode(documents);

    var response = await http.post(Uri.parse(APIService.uploadDocuments(carId: carId)),
        headers: APIHelper().requestHeadersWithToken(), body: jsonData);

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {
      await budgetService.getBudgets();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future updateCar({Map<String, dynamic>? data, String? carId}) async {

    final jsonData = JSON.json.encode(data);

    var response = await http.put(
        Uri.parse(APIService.updateCars(carId: carId!)),
        body: jsonData,
        headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {
      //await getUsers();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future getWeather({String? lat, String? lng}) async {

    var response = await http.get(
        Uri.parse(APIService.getWeather(lat: lat, lng: lng, country: 'NG')),
        headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {

      WeatherData wData = WeatherData.fromJson(json);
      weatherData = wData;

    } else {

      var error = json["message"];
      print(error);
      throw Exception(error);

    }

  }

  Future updateFuelPrice({Map<String, dynamic>? updateData, String? city, String? state, String? country }) async {

    final jsonData = JSON.json.encode(updateData);

    print(jsonData.toString());

    var response = await http.post(
        Uri.parse(APIService.addFuelUpdate),
        body: jsonData,
        headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {

      await getCurrentFuelPrice(state: state, country: country, city: city);
      await getUsers();

    } else {

      var error = json["message"];
      print(error);
      throw Exception(error);

    }

  }

  Future getCurrentFuelPrice({String? city, String? state, String? country}) async {

    var response = await http.get(
        Uri.parse(APIService.getFuelUpdate(city: city, state: state, country: country)),
        headers: APIHelper().requestHeadersWithToken()
    );

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {

      FuelData fData = FuelData.fromJson(json);
      fuelData = fData;

    } else {

      var error = json["message"];
      print(error);
      throw Exception(error);

    }

  }

  // Future<LatLngAddressModel> getAddressFromLatLng({
  //   String? latLng,
  //       String? APIkey
  // }) async {
  //   var result = await http.get(Uri.parse("${APIService.googleLatLngAddress}latlng=$latLng&key=$APIkey&language=en"));
  //
  //   final json = JSON.jsonDecode(result.body);
  //
  //   if (json["status"] == "OK") {
  //
  //     LatLngAddressModel latLngAddressModelResponse = LatLngAddressModel.fromJson(json);
  //     latLngAddressModel = latLngAddressModelResponse;
  //     return latLngAddressModelResponse;
  //
  //   } else {
  //     var error = json["status"];
  //     throw Exception(error);
  //   }
  // }

  // Future<NearbySearchModel> getNearbyPlaces({
  //   String? latLng,
  //   String? radius,
  //   String? type
  // }) async {
  //
  //   var result = await http.get(Uri.parse("${APIService.googlePlacesNearBy}location=$latLng&type=$type&key=${APIKey.GSKey}&radius=$radius"));
  //   final json = JSON.jsonDecode(result.body);
  //
  //   if (json["status"] == "OK") {
  //
  //     NearbySearchModel nearbyResponse = NearbySearchModel.fromJson(json);
  //     nearbySearchModel = nearbyResponse;
  //     return nearbySearchModel!;
  //
  //   } else {
  //
  //     var error = json["status"];
  //     throw Exception(error);
  //
  //   }
  // }

}