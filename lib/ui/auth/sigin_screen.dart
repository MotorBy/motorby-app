import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/signup_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

import '../marketplace/marketplace_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailTextController = TextEditingController();

  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: XColors.white(),
          appBar: AppBar(
            backgroundColor: XColors.white(),
            surfaceTintColor: XColors.white(),
            automaticallyImplyLeading: false,
              actions: [
                Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      navigate(context, const MarketPlace());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NormalText(
                        text:'Marketplace',
                        textColor: XColors.textColor(),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(Icons.shopping_basket, size: 18, color: XColors.primaryColor(),),
                  const XMargin(10)
                ],
              ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        navigate(context, CommunityScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NormalText(
                          text:'Community',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(Icons.supervisor_account_outlined, size: 18, color: XColors.primaryColor(),),
                    const XMargin(10)
                  ],
                ),
              ],
            ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 650,
                      child: const YMargin(10)
                  ),
                  Column(children: [
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
                  ],),
                  const YMargin(80),
                  MkInputField2(
                    label: "Email address",
                    isEnabled: true,
                    controller: emailTextController,
                  ),
                  const YMargin(20),
                  MkInputField2(
                    label: "Password",
                    isEnabled: true,
                    controller: passwordTextController,
                  ),
                  const YMargin(20),
                  Row(children: [
                    NormalText(
                      text: 'Don\'t have an account?',
                      textColor: XColors.textColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    const XMargin(10),
                    GestureDetector(
                      onTap: (){
                        navigateReplace(context, const SignupScreen());
                      },
                      child: NormalText(
                        text: 'Sign up',
                        textColor: XColors.primaryColor(),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],),
                  const YMargin(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      XButton(
                        onPressed: () {

                          model.login(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                              onCallBack: (){
                                navigateReplace(context, HomeScreen());
                              }
                          );

                        },
                        text: 'Login',
                        isLoading: model.isBusy,
                        buttonColor: XColors.primaryColor(),
                        width: 120,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
