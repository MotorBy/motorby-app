
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';


class InsuranceAppBar extends StatelessWidget
    implements PreferredSizeWidget {
     InsuranceAppBar({
    super.key,
    required this.text1,
   this.noAction=false,
  });

final String text1;
bool? noAction;


  @override
  Widget build(BuildContext context) {

    return AppBar(
        backgroundColor: XColors.highlightColor().withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
Navigator.of(context).pop();            },
            child: const GetSvgImage(
              image: 'assets/images/arrow_back.svg',
              boxFit: BoxFit.scaleDown,
            )),
          centerTitle: false,
          title:  NormalText(
            text:text1,
           fontSize: 18,
          fontWeight: FontWeight.w500,
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
