import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/home/home_screen.dart';
import 'package:mobile_auto_drive/ui/splash/splash_view_model.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
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
            onNewCallBack: (){
              navigateReplace(context, SignInScreen());
            },
            onLoggedCallBack: (){
              navigateReplace(context, HomeScreen());
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
                      Container(
                        height: 250,
                        width: 250,
                        child: Image.asset('assets/images/auto/motorby-logo.png'),
                      ),
                      const YMargin(5),
                      NormalText(
                        text:'Connect with your car in a better way...',
                        textColor: XColors.textColor(),
                        textAlign: TextAlign.center,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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