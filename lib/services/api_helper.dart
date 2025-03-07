import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:package_info_plus/package_info_plus.dart';

class APIHelper {
  final persistService = serviceLocator<PersistenceService>();

  Map<String, String> requestHeadersWithToken({String? token}) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'x-access-token': persistService.getUserToken != null ? persistService.getUserToken! : token ?? '',
        'current-app-version': persistService.currentVersion!
  };

  Map<String, String> requestHeaders() => {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'current-app-version': persistService.currentVersion!
  };

  Map<String, String> requestRapidAPIHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'X-RapidAPI-Key': '780c82b0efmsh02e912e2d8c2402p14051ejsnb7d7dd0274c3',
    'X-RapidAPI-Host': 'vin-decoder19.p.rapidapi.com'
  };

  // Map<String, String> payStackHeader = {
  //   'Content-type': 'application/json',
  //   'Accept': 'application/json',
  //   'Authorization': 'Bearer ${AppConsts.payStackSKey}'
  // };
}
