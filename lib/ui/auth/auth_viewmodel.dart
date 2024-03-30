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
      regData['firstname'] = data;
    } else if(dataType == 'secondname'){
      regData['secondname'] = data;
    } else if(dataType == 'country'){
      regData['country'] = data;
    } else if(dataType == 'state'){
      regData['country'] = data;
    } else if(dataType == 'referralcode'){
      regData['referral_code'] = data;
    } else if(dataType == 'bname'){
      regData['business_details']['business_name'] = data;
    } else if(dataType == 'bcontact'){
      regData['business_details']['business_contact'] = data;
    } else if(dataType == 'bemail'){
      regData['business_details']['business_email'] = data;
    }

  }


  Future signup({Map<String, dynamic>? signupData}) async {

    authService.createUser(data: signupData).then((value) {

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