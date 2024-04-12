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
    Function(String? e)? onErrorBack }) async {

    setBusy(true);
    await authService.loginUser(email: email, password: password).then((value) {
      setBusy(false);
      onCallBack!();
    }).onError((error, stackTrace) {
      setBusy(false);
      print(stackTrace);
      if(onErrorBack != null) {
        onErrorBack(error.toString());
      }
    });

    //ErrorLogging().showError((await authService.loginUser(email: email, password: password)) as Future);
  }

  void updateRegData({dynamic data, String? dataType, }) {
    if(dataType == 'firstname') {
      regData['firstname'] = data;
    } else if(dataType == 'lastname'){
      regData['lastname'] = data;
    } else if(dataType == 'email'){
      regData['email'] = data;
    } else if(dataType == 'phonenumber'){
      regData['phonenumber'] = data;
    } else if(dataType == 'country'){
      regData['country'] = data;
    } else if(dataType == 'state'){
      regData['state'] = data;
    } else if(dataType == 'referralcode'){
      regData['referral_code'] = data;
    } else if(dataType == 'bname'){
      regData['business_details']['business_name'] = data;
    } else if(dataType == 'bcontact'){
      regData['business_details']['business_contact'] = data;
    } else if(dataType == 'bemail'){
      regData['business_details']['business_email'] = data;
    } else if(dataType == 'btype'){
      regData['business_details']['business_type'] = data;
    } else if(dataType == 'password'){
      regData['password'] = data;
    }

    print(regData);
  }


  Future signup({Function? onCallBack, Function? onErrorCallBack}) async {
    setBusy(true);
    authService.createUser(data: regData).then((value) {
      setBusy(false);
      if(onCallBack != null) {
        onCallBack();
      }
    }).onError((error, stackTrace) {
      setBusy(false);
      if(onErrorCallBack != null) {
        onErrorCallBack();
      }
    });
  }
  
  void updateRegAsPro({bool? v}){
    registerAsPro = v;
    if(registerAsPro!) {
      regData['business_details'] = {};
    } else {
      regData['business_details'] = null;
    }
    notifyListeners();
  }

}