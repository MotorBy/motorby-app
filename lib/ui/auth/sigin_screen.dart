import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/signup_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            text: 'Login',
            textColor: XColors.white(),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const Expanded(child: YMargin(20)),
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
            const YMargin(100)
          ],
        ),
      ),
    );
  }
}
