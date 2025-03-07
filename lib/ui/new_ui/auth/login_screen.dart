import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_auto_drive/ui/auth/auth_viewmodel.dart';
import 'package:mobile_auto_drive/ui/auth/signup_screen.dart';
import 'package:mobile_auto_drive/ui/community/community_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/ui/marketplace/marketplace_screen.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/snackbar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                      onTap: () {
                        navigate(context, const MarketPlace());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NormalText(
                          text: 'Marketplace',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.shopping_basket,
                      size: 18,
                      color: XColors.primaryColor(),
                    ),
                    const XMargin(10)
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigate(context, const CommunityScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NormalText(
                          text: 'Community',
                          textColor: XColors.textColor(),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.supervisor_account_outlined,
                      size: 18,
                      color: XColors.primaryColor(),
                    ),
                    const XMargin(10)
                  ],
                ),
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                XButton(
                  onPressed: () {

                    if(_formKey.currentState!.validate()) {

                      model.login(
                          email: emailTextController.text,
                          password: passwordTextController.text,
                          onCallBack: (){
                            navigateReplace(context, const HomeScreen());
                          },
                          onErrorBack: (e){
                            showSnackBar(
                                context: context,
                                message: e,
                                error: true
                            );
                          }
                      );
                    }
                  },
                  text: 'Login',
                  isLoading: model.isBusy,
                  buttonColor: XColors.primaryColor(),
                  width: 120,
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height - 750,
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
                      const YMargin(50),
                      XButton(
                        onPressed: () {

                          model.handleSignInWithGoogle(
                            onCallBack: () {
                              navigateReplace(context, const HomeScreen());
                            },
                            onErrorBack: (e){
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
                                text: 'Login with',
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
                      MainInputField(
                        label: "Email address",
                        isEnabled: true,
                        validator: EmailValidator.validate,
                        controller: emailTextController,
                      ),
                      const YMargin(20),
                      MainInputField(
                        label: "Password",
                        validator: PasswordValidator.validate,
                        isEnabled: true,
                        isPassword: true,
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
                            navigateReplace(context, SignupScreen());
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