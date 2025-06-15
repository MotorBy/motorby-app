import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/login_response.dart';
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/notification_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

bool? get hasUserSetup => serviceLocator<AuthService>().hasUser;

class AuthService {
  final persistService = serviceLocator<PersistenceService>();

  bool? hasUser = false;

  Future createUser({Map<String, dynamic>? data, bool? isAuthFromProvider = false}) async {

    data!['notification_token'] = NotificationService.fcmToken ?? '';
    final jsonData = JSON.json.encode(data);

    var response = await http.post(Uri.parse(APIService.authUser),
        headers: APIHelper().requestHeaders(), body: jsonData);
    final json = JSON.jsonDecode(response.body);

    print(json.toString());
    print(APIHelper().requestHeaders());

    if (json["statusCode"] == 200 || json["statusCode"] == 201) {

      await loginUser(
          email: data['email'],
          password: data['password'],
          isAuthFromProvider: isAuthFromProvider
      );

    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

  Future<LoginResponse> loginUser({String? email, String? password, bool? isAuthFromProvider = false}) async {

    final jsonData = JSON.json.encode({"email": email, "password": password, "signinFrom": isAuthFromProvider == true ? 'provider' : '' });

    var response = await http.post(Uri.parse(APIService.loginUser),
        headers: APIHelper().requestHeaders(), body: jsonData);
    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      LoginResponse? response = LoginResponse.fromJson(json['data']);

      persistService.setUserID(response.userId!);
      persistService.setToken(response.token!);

      hasUser = true;

      return response;
    } else {
      var error = json["message"];
      throw Exception(error);
    }
  }

}