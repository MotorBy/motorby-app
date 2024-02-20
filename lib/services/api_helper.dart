import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class APIHelper {
  final persistService = serviceLocator<PersistenceService>();

  Map<String, String> requestHeadersWithToken({String? token}) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'x-access-token': token ?? persistService.getUserToken!,
      };

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  // Map<String, String> payStackHeader = {
  //   'Content-type': 'application/json',
  //   'Accept': 'application/json',
  //   'Authorization': 'Bearer ${AppConsts.payStackSKey}'
  // };
}
