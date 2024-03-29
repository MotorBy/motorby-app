import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel {


  void initialise({bool? authNewState,
    Function? onNewCallBack,
    Function? onLoggedCallBack}) {

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