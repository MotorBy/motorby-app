import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav.dart';
import 'package:mobile_auto_drive/ui/onboarding/onboarding_screen.dart';
import 'package:mobile_auto_drive/ui/splash/splash_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.isAuthed = false});

  final bool? isAuthed;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(),
        onViewModelReady: (model) => model.initialise(
            authNewState: isAuthed,
            onNewCallBack: () {
              //navigateReplace(context, SignInScreen());
              navigateReplace(context, const OnboardingScreen());
            },
            onLoggedCallBack: () {
              navigateReplace(context, const DashBoardScreen());
            }
        ),
        builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const Expanded(child: YMargin(49)),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   height: 280,
                      //   width: 280,
                      //   child: Image.asset('assets/images/motorby.jpeg'),
                      // ),
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
                      const YMargin(15),
                      NormalText(
                        text:'Connect with your car in a better way...',
                        textColor: XColors.primaryColor(),
                        textAlign: TextAlign.center,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                //const YMargin(249)
              ],
            ),
          ),
        );
      }
    );
  }
}