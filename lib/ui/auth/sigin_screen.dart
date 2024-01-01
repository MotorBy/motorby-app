import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/signup_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

import '../marketplace/marketplace_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: XColors.white(),
        surfaceTintColor: XColors.white(),
        automaticallyImplyLeading: false,
          actions: [Row(
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
                  child: const Expanded(child: YMargin(10))
              ),
              Column(children: [
                Container(
                  height: 170,
                  width: 170,
                  child: Image.asset('assets/images/auto/motorby-logo.png'),
                ),
              ],),
              const YMargin(80),
              const MkInputField2(
                label: "Email address",
                isEnabled: true,
              ),
              const YMargin(20),
              const MkInputField2(
                label: "Password",
                isEnabled: true,
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
                  GestureDetector(
                    onTap: (){
                      navigateReplace(context, HomeScreen());
                    },
                    child: Container(
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
                        text: 'Login',
                        textColor: XColors.white(),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
