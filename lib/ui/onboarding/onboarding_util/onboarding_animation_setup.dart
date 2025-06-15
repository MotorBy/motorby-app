import 'package:flutter/animation.dart';

class OnboardingAnimationSetup {

  factory OnboardingAnimationSetup() {
    return _instance!;
  }

  OnboardingAnimationSetup._();

  static OnboardingAnimationSetup? _instance;


  late AnimationController animationProgressCtrl1;
  late Animation<double> animationProgressValue1;
  late CurvedAnimation curvedAnimation1;

  late AnimationController animationProgressCtrl2;
  late Animation<double> animationProgressValue2;
  late CurvedAnimation curvedAnimation2;

  late AnimationController animationProgressCtrl3;
  late Animation<double> animationProgressValue3;
  late CurvedAnimation curvedAnimation3;

  static List<double> changingLogoAnimation = [0.0, 120.0];
  static List<double> changingTextAnimation = [180, 280];
  static List<double> changingChipsAnimation = [5, 520];

  static void init({TickerProvider? vsync}) {
    _instance ??= OnboardingAnimationSetup._();

    _instance!.animationProgressCtrl1 = AnimationController(
      vsync: vsync!,
      duration: const Duration(milliseconds: 2000),
    );
    _instance!.curvedAnimation1 = CurvedAnimation(parent: _instance!.animationProgressCtrl1, curve: Curves.linear);
    _instance!.animationProgressValue1 = Tween<double>(
      begin: changingLogoAnimation[0],
      end: changingLogoAnimation[1],
    ).animate(_instance!.curvedAnimation1);


    _instance!.animationProgressCtrl2 = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3100),
    );
    _instance!.curvedAnimation2 = CurvedAnimation(parent: _instance!.animationProgressCtrl2, curve: Curves.linear);
    _instance!.animationProgressValue2 = Tween<double>(
      begin: changingTextAnimation[0],
      end: changingTextAnimation[1],
    ).animate(_instance!.curvedAnimation2);
    _instance!.animationProgressCtrl2.forward();


    _instance!.animationProgressCtrl3 = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2500),
    );
    _instance!.curvedAnimation3 = CurvedAnimation(parent: _instance!.animationProgressCtrl3, curve: Curves.linear);
    _instance!.animationProgressValue3 = Tween<double>(
      begin: changingChipsAnimation[0],
      end: changingChipsAnimation[1],
    ).animate(_instance!.curvedAnimation3);
    _instance!.animationProgressCtrl3.forward();


    _instance!.animationProgressCtrl3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _instance!.animationProgressCtrl1.forward();
      }
    });

  }

  double get animationProgressLogoValue => animationProgressValue1.value;
  double get animationProgressTextValue => animationProgressValue2.value;
  double get animationProgressChipsValue => animationProgressValue3.value;


}