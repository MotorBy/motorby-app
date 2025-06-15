import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

import '../../firebase_options.dart';

class AuthViewModel extends BaseViewModel {
  final authService = serviceLocator<AuthService>();
  final userService = serviceLocator<UserService>();

  bool? isLoggedIn = false;
  bool? registerAsPro = false;

  bool? hasSignupWithProvider = false;

  String? authProvider = '';

  Map<String, dynamic> regData = {

  };

  static List<String> scopes = <String>[
    'email',
    'profile'
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: DefaultFirebaseOptions.android.androidClientId,
    scopes: scopes,
  );

  void init() async {

  }

  Future login({
    String? email,
    String? password,
    bool? isFromProvider,
    Function? onCallBack,
    Function(String? e)? onErrorBack }) async {

    setBusy(true);
    await authService.loginUser(email: email, password: password, isAuthFromProvider: isFromProvider).then((value) {
      setBusy(false);
      onCallBack!();
    }).onError((error, stackTrace) async {
      setBusy(false);
      await _googleSignIn.signOut();

      print(stackTrace);
      if(onErrorBack != null) {
        onErrorBack(error.toString());
      }

    });

    //ErrorLogging().showError((await authService.loginUser(email: email, password: password)) as Future);
  }

  Future<void> handleSignInWithGoogle({
    Function? onCallBack,
    Function(String? e)? onErrorBack,
    bool? forSignup = false,
    String? country = '',
    String? state = '',
    String? phoneNumber = '',
  }) async {
    try {

      if(forSignup == true) {

        if(phoneNumber!.isEmpty || country!.isEmpty || state!.isEmpty) {
          onErrorBack!('Please enter your country, state and phone number');
          return;
        }

      }

      await _googleSignIn.signIn().then((value) async {

        authProvider = value!.id;
        print(authProvider);

        if(forSignup == false) {

          await login(
              email: value.email,
              password: authProvider,
              isFromProvider: true,
              onCallBack: onCallBack,
              onErrorBack: onErrorBack
          );

        } else {

          if(hasSignupWithProvider == false) {

            regData['firstname'] = value.displayName!.split(' ')[0];
            regData['lastname'] = value.displayName!.split(' ')[1];
            regData['email'] = value.email;
            regData['password'] = authProvider;
            regData['signupFrom'] = 'provider';
            regData['phonenumber'] = phoneNumber;
            regData['country'] = country;
            regData['state'] = state;
            regData['image'] = value.photoUrl;

            print(regData.toString());

            setBusy(true);
            await authService.createUser(
                data: regData,
                isAuthFromProvider: true
            ).then((value) {

              hasSignupWithProvider = true;
              notifyListeners();

              setBusy(false);
              if(onCallBack != null) {
                onCallBack();
              }

            }).onError((error, stackTrace) async {
              await _googleSignIn.signOut();
              print(stackTrace.toString());

              setBusy(false);

              if(onErrorBack != null) {
                onErrorBack(error.toString());
              }
            });

          }

        }

      });

    } catch (error) {
      print(error);
    }
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
    } else if(dataType == 'password') {
      regData['password'] = data;
    }

    print(regData);
  }


  Future signup({Function? onCallBack, Function? onErrorCallBack}) async {
    setBusy(true);

    if(hasSignupWithProvider == true) {

      await userService.updateUsers(data: regData).then((value) {
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

    } else {

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