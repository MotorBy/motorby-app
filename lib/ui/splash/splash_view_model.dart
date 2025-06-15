import 'package:flutter/foundation.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';


class SplashViewModel extends BaseViewModel {

  Future<void> initialise({bool? authNewState,
    Function? onNewCallBack,
    Function? onLoggedCallBack}) async {

    if(!serviceLocator.isRegistered<PersistenceService>()) {
      await locatorSetup();
    }

    if (kDebugMode) {
      print("is Logged in: ${authNewState!}");
    }

    Future.delayed(const Duration(seconds: 2), () {

      if(authNewState != false) {

        if(onLoggedCallBack != null) {
          onLoggedCallBack();
        }

      } else {

        if(onNewCallBack != null) {
          onNewCallBack();
        }

      }

    });

  }

}