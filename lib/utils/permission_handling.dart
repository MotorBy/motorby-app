import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class PermissionUtil {

  loc.Location location = loc.Location();
  bool? _serviceEnabled;

  static Future requestPermission(Permission permission) async {
    permission.shouldShowRequestRationale;
    permission.request();
  }

  static Future<bool> hasPermission(Permission permission) async {
    permission.status.then((value) {
      if(value == PermissionStatus.granted) {
        return true;
      }
    });
    return false;
  }

  Future<bool> isLocationServiceAndPermissionsActive() async {
    _serviceEnabled = await location.serviceEnabled();
    final gpsPermissionGranted = await PermissionUtil.hasPermission(Permission.location);
    if(_serviceEnabled! && gpsPermissionGranted == false) {
      return false;
    }
    return true;
  }


}
