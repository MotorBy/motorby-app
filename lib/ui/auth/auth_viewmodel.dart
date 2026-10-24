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

  /// Which of the two sign-up buttons is currently running, or null when idle.
  /// Lets each button show its own spinner instead of both reacting to isBusy.
  SignupMethod? activeSignup;

  bool get isSigningUp => activeSignup != null;

  String? authProvider = '';

  // `country` is derived from the phone number's dial code, never typed.
  // `state` is no longer collected at sign-up; users set it in Edit profile.
  Map<String, dynamic> regData = {
    'country': defaultCountry.name,
    'state': defaultCountry.name,
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

  }

  Future<void> handleSignInWithGoogle({
    Function? onCallBack,
    Function(String? e)? onErrorBack,
    bool? forSignup = false,
    String? country = '',
    String? phoneNumber = '',
  }) async {

    // The account is created in one request, so the number has to be in hand
    // before we hand off to Google.
    if(forSignup == true && (phoneNumber == null || phoneNumber.isEmpty)) {
      onErrorBack?.call('Please enter your phone number first');
      return;
    }

    try {

      final account = await _googleSignIn.signIn();

      // Null means the user dismissed the Google sheet. Not a failure.
      if(account == null) return;

      authProvider = account.id;

      if(forSignup != true) {
        await login(
            email: account.email,
            password: authProvider,
            isFromProvider: true,
            onCallBack: onCallBack,
            onErrorBack: onErrorBack
        );
        return;
      }

      final nameParts = (account.displayName ?? '')
          .split(' ')
          .where((part) => part.isNotEmpty)
          .toList();

      regData['firstname'] = nameParts.isNotEmpty ? nameParts.first : '';
      regData['lastname'] =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      regData['email'] = account.email;
      regData['password'] = authProvider;
      regData['signupFrom'] = 'provider';
      regData['phonenumber'] = phoneNumber;
      regData['country'] = country!.isEmpty ? defaultCountry.name : country;
      regData['state'] = '';
      regData['image'] = account.photoUrl;

      await _createAccount(
        method: SignupMethod.google,
        onCallBack: onCallBack,
        onErrorBack: onErrorBack,
      );

    } catch (error) {
      // Google itself failed (cancelled mid-flow, no Play Services, bad config).
      _finishSignup();
      await _googleSignIn.signOut();
      onErrorBack?.call(readableError(error));
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


  /// The "Sign up" button. Same account-creation path the Google button ends
  /// up in, only the fields were typed rather than read off a Google account.
  Future signup({Function? onCallBack, Function(String? e)? onErrorCallBack}) async {
    await _createAccount(
      method: SignupMethod.form,
      onCallBack: onCallBack,
      onErrorBack: onErrorCallBack,
    );
  }

  Future<void> _createAccount({
    required SignupMethod method,
    Function? onCallBack,
    Function(String? e)? onErrorBack,
  }) async {

    if(isSigningUp) return; // the other button is already mid-flight

    _startSignup(method);

    try {
      await authService.createUser(
        data: regData,
        isAuthFromProvider: method == SignupMethod.google,
      );
      _finishSignup();
      onCallBack?.call();
    } catch (error) {
      _finishSignup();
      if(method == SignupMethod.google) {
        await _googleSignIn.signOut();
      }
      onErrorBack?.call(readableError(error));
    }
  }

  void _startSignup(SignupMethod method) {
    activeSignup = method;
    setBusy(true);
  }

  void _finishSignup() {
    activeSignup = null;
    setBusy(false);
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

enum SignupMethod { form, google }

/// createUser throws Exception(json['message']), so the useful part is behind
/// a prefix no user should ever see.
String readableError(Object? error) {
  final text = (error ?? '').toString();
  return text.startsWith('Exception: ')
      ? text.substring('Exception: '.length)
      : text;
}
