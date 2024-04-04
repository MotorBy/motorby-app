import 'dart:convert' as JSON;
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/login_response.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';


class AuthService {
  final persistService = serviceLocator<PersistenceService>();

  String? fcmToken;

  Future createUser({Map<String, dynamic>? data}) async {
    final jsonData = JSON.json.encode(data);

    var response = await http.post(Uri.parse(APIService.authUser),
        headers: APIHelper().requestHeaders, body: jsonData);
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      await loginUser(
          email: data!['email'],
          password: data['password']
      );

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future<LoginResponse> loginUser({String? email, String? password}) async {
    //firebaseTokenInit();

    final jsonData = JSON.json.encode({"email": email, "password": password});

    var response = await http.post(Uri.parse(APIService.loginUser),
        headers: APIHelper().requestHeaders, body: jsonData);
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      LoginResponse? response = LoginResponse.fromJson(json['data']);

      persistService.setUserID(response.userId!);
      persistService.setToken(response.token!);

      return response;
    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  void firebaseTokenInit() {
    FirebaseMessaging.instance.getToken().then((value) {
      fcmToken = value;
    });
  }
}