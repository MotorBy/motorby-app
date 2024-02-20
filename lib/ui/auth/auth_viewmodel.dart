import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/utils/error_logging.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class AuthViewModel extends BaseViewModel {
  final authService = serviceLocator<AuthService>();

  bool? isLoggedIn = false;
  bool? registerAsPro = false;

  Map<String, dynamic> regData = {

  };

  void init() async {

  }

  Future login({
    String? email,
    String? password,
    Function? onCallBack,
    Function? onErrorBack }) async {

    setBusy(true);
    await authService.loginUser(email: email, password: password).then((value) {
      setBusy(false);
      onCallBack!();
    }).onError((error, stackTrace) {
      setBusy(false);
      print(stackTrace);
      if(onErrorBack != null) {
        onErrorBack();
      }
    });

    //ErrorLogging().showError((await authService.loginUser(email: email, password: password)) as Future);

  }

  void updateRegData({dynamic data, String? dataType, }) {
    if(dataType == 'firstname') {

    } else if(dataType == 'secondname'){

    }

  }


  Future signup() async {

    authService.createUser().then((value) {

    }).onError((error, stackTrace) {

    });

  }
  
  void updateRegAsPro({bool? v}){
    registerAsPro = v;
    if(registerAsPro!) {
      regData['business_details'] = {};
    }
    notifyListeners();
  }

}