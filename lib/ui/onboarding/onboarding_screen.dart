import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/onboarding/onboarding_util/onboarding_animation_setup.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

import '../../utils/margin.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin   {

  @override
  void initState() {

    OnboardingAnimationSetup.init(vsync: this);

    // OnboardingAnimationSetup().animationProgressCtrl1.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: SizeConfig.screenWidthDp,
            child: Image.asset(
              'assets/images/onboarding-bg.png',
              height: SizeConfig.screenHeightDp,
              width: SizeConfig.screenWidthDp,
              fit: BoxFit.fitHeight,
            ),
          ),

          AnimatedBuilder(
              animation: OnboardingAnimationSetup().animationProgressCtrl1,
              builder: (BuildContext context, Widget? child) {

                return Positioned(
                top: OnboardingAnimationSetup().animationProgressLogoValue,
                left: 10,
                right: 10,
                child: SvgPicture.asset(
                  'assets/images/motorby_m.svg',
                  colorFilter: ColorFilter.mode(XColors.white(), BlendMode.srcIn),
                  width: 150,
                  height: 150,
                  fit: BoxFit.fitHeight,
                ),
              );
            }
          ),

          AnimatedBuilder(
              animation: OnboardingAnimationSetup().animationProgressCtrl2,
              builder: (BuildContext context, Widget? child) {
              return Positioned(
                top: OnboardingAnimationSetup().animationProgressTextValue,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const YMargin(15),
                      NormalText(
                        text:'All-in-one\nplace for you',
                        textColor: XColors.white(),
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ),
                ),
              );
            }
          ),

          AnimatedBuilder(
              animation: OnboardingAnimationSetup().animationProgressCtrl3,
              builder: (BuildContext context, Widget? child) {
              return Positioned(
                top: OnboardingAnimationSetup().animationProgressChipsValue,
                child: SvgPicture.asset(
                  'assets/images/onboarding-chips-img.svg',
                  width: SizeConfig.screenWidthDp,
                  fit: BoxFit.fitHeight,
                ),
              );
            }
          ),

          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: XButton(
              onPressed: () {

                final persistence = serviceLocator<PersistenceService>();
                persistence.setOnboarding(true);

                navigateReplace(context, SignInScreen());

              },
              text: 'Get started',
              isLoading: false,
              textColor: XColors.primaryColor(),
              buttonColor: XColors.white(),
            ),
          ),

        ],
      ),
    );
  }
}