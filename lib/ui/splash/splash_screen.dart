import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Expanded(child: YMargin(49)),
            Row(
              children: [
                NormalText(
                  text:'Mobile Auto \nDrive',
                  textColor: XColors.textColor(),
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ],
            ),
            const YMargin(10),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidthDp! - 60,
                  child: NormalText(
                    text:'Have your companion mobile drive app with you all time and \nconnect well with your car',
                    textColor: XColors.textColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const YMargin(149)
          ],
        ),
      ),
    );
  }
}