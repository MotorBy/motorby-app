import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/snackbar.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController regAsController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                              navigateReplace(context, const HomeScreen());
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
                          onPressed: () {

                            model.handleSignInWithGoogle(
                              forSignup: true,
                              onCallBack: () {
                                //navigateReplace(context, const HomeScreen());
                              },
                              onErrorBack: (e) {
                                showSnackBar(
                                    context: context,
                                    message: e,
                                    error: true
                                );
                              },
                            );

                          },
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
                                validator: (s) {
                                  return AnyInputValidator.emptyValidate(s, inputName: 'Firstname');
                                },
                                onChanged: (s){
                                  model.updateRegData(data: s, dataType: 'firstname');
                                },
                              ),
                            ),
                            XMargin(10),
                            Expanded(
                              child: MainInputField(
                                label: "Second name",
                                isEnabled: true,
                                validator: (s) {
                                  return AnyInputValidator.emptyValidate(s, inputName: 'Secondname');
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

                      MainInputField(
                        label: "Phonenumber",
                        isEnabled: true,
                        keyboard: TextInputType.number,
                        validator: (s) {
                          return AnyInputValidator.emptyValidate(s, inputName: 'Phone number');
                        },
                        onChanged: (s){
                          model.updateRegData(data: s, dataType: 'phonenumber');
                        },
                      ),

                      if(model.hasSignupWithProvider == false) ... [
                        const YMargin(20),
                        MainInputField(
                          label: "Email address",
                          isEnabled: true,
                          validator: EmailValidator.validate,
                          onChanged: (s){
                            model.updateRegData(data: s, dataType: 'email');
                          },
                        ),
                      ],

                      const YMargin(20),
                      MainInputField(
                        label: "Register as",
                        controller: regAsController,
                        isEnabled: false,
                        suffixIcon: GestureDetector(
                          onTap: (){
                            listHelperPicker(
                              height: 150,
                              context: context,
                              title: 'Register as',
                              listString: [
                                "User",
                                "Business"
                              ],
                              selected: (s) {
                                regAsController.text = s!;
                                model.updateRegAsPro(v: s == 'User' ? false : true);
                              },
                            );
                          },
                          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                        ),
                      ),
                      if(model.registerAsPro == true) ... [
                        const YMargin(20),
                        MainInputField(
                          label: "Business name",
                          isEnabled: true,
                          validator: (s) {
                            return AnyInputValidator.emptyValidate(s, inputName: 'Business name');
                          },
                          onChanged: (s){
                            model.updateRegData(data: s, dataType: 'bname');
                          },
                        ),
                        const YMargin(20),
                        MainInputField(
                          label: "Business contact",
                          validator: (s) {
                            return AnyInputValidator.emptyValidate(s, inputName: 'Business contact');
                          },
                          isEnabled: true,
                          onChanged: (s){
                            model.updateRegData(data: s, dataType: 'bcontact');
                          },
                        ),
                        const YMargin(20),
                        MainInputField(
                          label: "Business email",

                          isEnabled: true,
                          onChanged: (s){
                            model.updateRegData(data: s, dataType: 'bemail');
                          },
                        ),
                        const YMargin(20),
                        MainInputField(
                          label: "Business type",
                          validator: (s) {
                            return AnyInputValidator.emptyValidate(s, inputName: 'Business type');
                          },
                          isEnabled: false,
                          controller: businessController,
                          suffixIcon: GestureDetector(
                            onTap: (){
                              listHelperPicker(
                                height: 210,
                                context: context,
                                title: 'Business type',
                                listString: [
                                  "Dealership",
                                  "Repair",
                                  "Servicing",
                                  "Detailing",
                                  "Part sales",
                                  "Rental",
                                  "Insurance",],
                                selected: (s) {
                                  businessController.text = s!;
                                  model.updateRegData(data: s, dataType: 'btype');
                                },
                              );
                            },
                            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                          ),
                        ),
                      ],
                      const YMargin(20),
                      Row(
                        children: [
                          Expanded(
                            child: MainInputField(
                              label: "Country",
                              isEnabled: false,
                              validator: (s) {
                                return AnyInputValidator.emptyValidate(s, inputName: 'Country');
                              },
                              controller: countryController,
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  listHelperPicker(
                                    height: 150,
                                    context: context,
                                    title: 'Countries',
                                    listString: [
                                      "Nigeria",
                                      "Ghana",
                                      "Kenya"
                                    ],
                                    selected: (s) {
                                      countryController.text = s!;
                                      model.updateRegData(data: s, dataType: 'country');
                                    },
                                  );
                                },
                                child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                              ),
                            ),
                          ),
                          const XMargin(10),
                          Expanded(
                            child: MainInputField(
                              label: "State",
                              isEnabled: true,
                              validator: (s) {
                                return AnyInputValidator.emptyValidate(s, inputName: 'State');
                              },
                              onChanged: (s){
                                model.updateRegData(data: s, dataType: 'state');
                              },
                            ),
                          ),
                        ],
                      ),
                      const YMargin(20),
                      if(model.hasSignupWithProvider == false) ... [
                        MainInputField(
                          label: "Password",
                          isPassword: true,
                          validator: PasswordValidator.validate,
                          isEnabled: true,
                          onChanged: (s){
                            model.updateRegData(data: s, dataType: 'password');
                          },
                        ),
                        const YMargin(20),
                      ],
                      MainInputField(
                        label: "Referral code",
                        isEnabled: true,
                        onChanged: (s){
                          model.updateRegData(data: s, dataType: 'referralcode');
                        },
                      ),
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