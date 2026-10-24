import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/supported_countries.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/phone_field.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode phoneNumberFocus = FocusNode();

  /// Mirrors the dial-code picker. Sign-up sends this as the user's country.
  SupportedCountry selectedCountry = defaultCountry;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    phoneNumberFocus.dispose();
    super.dispose();
  }

  /// Google sign-up creates the account in one shot, so the phone number has to
  /// be in hand before we hand off. Send the user to the field instead of just
  /// complaining at them.
  void _signUpWithGoogle(AuthViewModel model) {
    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberFocus.requestFocus();
      FloatingSnackBar.show(
        context,
        'Enter your phone number first, then continue with Google',
        isError: true,
      );
      return;
    }

    model.handleSignInWithGoogle(
      forSignup: true,
      country: selectedCountry.name,
      phoneNumber: selectedCountry.e164(phoneNumberController.text),
      onCallBack: () {
        navigateReplace(context, const DashBoardScreen());
      },
      onErrorBack: (e) {
        FloatingSnackBar.show(context, e!, isError: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, child) {
        return Form(
          key: _formKey,
          child: Scaffold(
            backgroundColor: XColors.white(),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                XButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      model.signup(
                          onCallBack: () {
                            navigateReplace(context, const DashBoardScreen());
                          },
                          onErrorCallBack: () {
                            showSnackBar(
                                error: true,
                                context: context,
                                message: 'Error creating your account'
                            );
                          }
                      );
                    }
                  },
                  text: model.hasSignupWithProvider == false ? 'Sign up' : 'Complete your sign up',
                  isLoading: model.isBusy,
                  buttonColor: XColors.primaryColor(),
                  width: 120,
                ),
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height -  60,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const YMargin(30),
                    Center(
                      child: SizedBox(
                        height: 140,
                        width: 140,
                        child: SvgPicture.asset(
                          'assets/images/motorby_m.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const YMargin(30),
                    if(model.hasSignupWithProvider == false) ... [

                      XButton(
                        onPressed: () => _signUpWithGoogle(model),
                        isOutline: true,
                        buttonWidget: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NormalText(
                                text: 'Signup with',
                                textColor: XColors.textColor(),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              const XMargin(15),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    32,
                                  ),
                                ),
                                child: Image.asset('assets/images/icons/google.png'),
                              ),
                              const XMargin(3),
                            ],
                          ),
                        ),
                      ),
                      const YMargin(30),
                      NormalText(
                        text: 'or',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      const YMargin(30),

                    ],

                    if(model.hasSignupWithProvider == false) ... [
                      Row(
                        children: [
                          Expanded(
                            child: MainInputField(
                              label: "First name",
                              isEnabled: true,
                              textInputAction: TextInputAction.next,
                              validator: (s) {
                                return AnyInputValidator.emptyValidate(s, inputName: 'Firstname');
                              },
                              onChanged: (s){
                                model.updateRegData(data: s, dataType: 'firstname');
                              },
                            ),
                          ),
                          const XMargin(10),
                          Expanded(
                            child: MainInputField(
                              label: "Last name",
                              isEnabled: true,
                              textInputAction: TextInputAction.next,
                              validator: (s) {
                                return AnyInputValidator.emptyValidate(s, inputName: 'Lastname');
                              },
                              onChanged: (s){
                                model.updateRegData(data: s, dataType: 'lastname');
                              },
                            ),
                          ),
                        ],
                      ),
                      const YMargin(20),
                    ],

                    // The dial code picked here is what sets the account's country.
                    PhoneNumberField(
                      controller: phoneNumberController,
                      currentNode: phoneNumberFocus,
                      initialCountry: selectedCountry,
                      onChanged: (country, number) {
                        selectedCountry = country;
                        model.updatePhoneNumber(country: country, number: number);
                      },
                    ),

                    if(model.hasSignupWithProvider == false) ... [
                      const YMargin(20),
                      MainInputField(
                        label: "Email address",
                        isEnabled: true,
                        keyboard: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: EmailValidator.validate,
                        onChanged: (s){
                          model.updateRegData(data: s, dataType: 'email');
                        },
                      ),
                      const YMargin(20),
                      MainInputField(
                        label: "Password",
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: PasswordValidator.validate,
                        isEnabled: true,
                        onChanged: (s){
                          model.updateRegData(data: s, dataType: 'password');
                        },
                      ),
                    ],

                    const YMargin(20),
                    Row(children: [
                      NormalText(
                        text: 'Already have an account?',
                        textColor: XColors.textColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      const XMargin(10),
                      GestureDetector(
                        onTap: (){
                          navigateReplace(context, SignInScreen());
                        },
                        child: NormalText(
                          text: 'Sign in',
                          textColor: XColors.primaryColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],),
                    const YMargin(100)
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
