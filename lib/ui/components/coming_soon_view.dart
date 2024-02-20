import 'package:flutter/cupertino.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const YMargin(50),
        ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            height: 90,
            width: 90,
            child: Image.asset('assets/images/icons/coming-soon.png', fit: BoxFit.cover,),
          ),
        ),
        const YMargin(50),
        NormalText(
          text: 'This feature is coming soon!!! \nStick around while we deliver it to you.',
          textColor: XColors.textColor(),
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        const YMargin(50),
      ],
    );
  }

}