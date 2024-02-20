import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, child) {
        return Scaffold(
          floatingActionButton: Container(
            width: 120,
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            decoration: BoxDecorators.containerDecoration(
              hasOutline: false,
              color: XColors.primaryColor(),
              outlineWidth: 2,
              radius: 32,
            ),
            child: NormalText(
              text: 'Sign up',
              textColor: XColors.white(),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height -  60,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    child: Image.asset('assets/images/auto/motorby-logo.png'),
                  ),
                  const YMargin(80),
                  Row(
                    children: [
                      Expanded(
                        child: MkInputField2(
                          label: "First name",
                          isEnabled: true,
                          onChanged: (s){

                          },
                        ),
                      ),
                      XMargin(10),
                      Expanded(
                        child: MkInputField2(
                          label: "Second name",
                          isEnabled: true,
                          onChanged: (s){

                          },
                        ),
                      ),
                    ],
                  ),
                  const YMargin(20),
                  MkInputField2(
                    label: "Email address",
                    isEnabled: true,
                    onChanged: (s){

                    },
                  ),
                  const YMargin(20),
                  MkInputField2(
                    label: "Register as",
                    isEnabled: false,
                    suffixIcon: GestureDetector(
                      onTap: (){
                        listHelperPicker(
                          height: 150,
                          context: context,
                          title: 'Register as',
                          listString: [
                            "User",
                            "Profession"
                          ],
                          selected: (s) {
                            model.updateRegAsPro(v: s == 'User' ? false : true);
                          },
                        );
                      },
                      child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                    ),
                  ),
                  if(model.registerAsPro == true) ... [
                    const YMargin(20),
                    const MkInputField2(
                      label: "Business name",
                      isEnabled: true,
                    ),
                    const YMargin(20),
                    MkInputField2(
                      label: "Business type",
                      isEnabled: true,
                      suffixIcon: GestureDetector(
                        onTap: (){
                          listHelperPicker(
                            height: 210,
                            context: context,
                            title: 'Business type',
                            listString: [
                              "Dealership",
                              "Auto Repair",
                              "Auto Part sales",
                              "Rental",
                              "Insurance",],
                            selected: (s) {

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
                        child: MkInputField2(
                          label: "Country",
                          isEnabled: true,
                          suffixIcon: GestureDetector(
                            onTap: (){
                              listHelperPicker(
                                height: 150,
                                context: context,
                                title: 'Countries',
                                listString: [
                                  "Nigeria",
                                  "Ghana",],
                                selected: (s) {

                                },
                              );
                            },
                            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 21,),
                          ),
                        ),
                      ),
                      const XMargin(10),
                      const Expanded(
                        child: MkInputField2(
                          label: "State",
                          isEnabled: true,
                        ),
                      ),
                    ],
                  ),
                  const YMargin(20),
                  const MkInputField2(
                    label: "Password",
                    isEnabled: true,
                  ),
                  const YMargin(20),
                  const MkInputField2(
                    label: "Referral code",
                    isEnabled: true,
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
        );
      }
    );
  }
}