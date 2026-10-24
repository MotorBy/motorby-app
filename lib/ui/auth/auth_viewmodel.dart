import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_auto_drive/utils/api_keys.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:mobile_auto_drive/services/auth_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';


class AuthViewModel extends BaseViewModel {
  final authService = serviceLocator<AuthService>();
  final userService = serviceLocator<UserService>();

  bool? isLoggedIn = false;
  bool? registerAsPro = false;

  bool? hasSignupWithProvider = false;

  String? authProvider = '';

  // `country` is derived from the phone number's dial code, never typed.
  // `state` is no longer collected at sign-up; users set it in Edit profile.
  Map<String, dynamic> regData = {
    'country': defaultCountry.name,
    'state': '',
  };

  static List<String> scopes = <String>[
    'email',
    'profile'
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: APIKey.googleServerClientId,
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
    String? phoneNumber = '',
  }) async {
    try {

      if(forSignup == true) {

        if(phoneNumber == null || phoneNumber.isEmpty) {
          onErrorBack!('Please enter your phone number first');
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

            final nameParts = (value.displayName ?? '')
                .split(' ')
                .where((part) => part.isNotEmpty)
                .toList();

            regData['firstname'] = nameParts.isNotEmpty ? nameParts.first : '';
            regData['lastname'] =
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
            regData['email'] = value.email;
            regData['password'] = authProvider;
            regData['signupFrom'] = 'provider';
            regData['phonenumber'] = phoneNumber;
            regData['country'] = country!.isEmpty ? defaultCountry.name : country;
            regData['state'] = '';
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

  /// The dial-code picker is the only source of `country`, so the phone number
  /// and the country it implies are always written together.
  void updatePhoneNumber({required SupportedCountry country, required String number}) {
    regData['phonenumber'] = country.e164(number);
    regData['country'] = country.name;
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