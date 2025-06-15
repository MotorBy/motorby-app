import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceService {
  final deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = {};

  Future<Map<String, dynamic>> getDeviceData() async {
    Map<String, dynamic> platformOS = {};

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      platformOS["deviceUUID"] = iosInfo.identifierForVendor;
      platformOS["deviceName"] = 'iOS';
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      platformOS["deviceUUID"] = androidInfo.id;
      platformOS["deviceName"] = 'Android';
    }

    deviceData = platformOS;
    return platformOS;
  }

  Future<PackageInfo> getPackageData() async {
    return await PackageInfo.fromPlatform();
  }
}
