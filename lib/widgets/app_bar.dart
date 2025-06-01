import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

AppBar appBarHeader({
  Function? onCloseAction,
  String? appBarTitle,
  List<Widget>? actions,
  BuildContext? context,
  bool? hasOnBack = true,
  bool? centerTitle = true,
}) {

  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    actions: actions ?? [],
    automaticallyImplyLeading: false,
    leading: hasOnBack!
        ? GestureDetector(
      onTap: () {

        if (onCloseAction != null) {
          onCloseAction.call();
        } else {
          popView(context!);
        }

      },
      child: Row(
        children: [
          const XMargin(18),
          Icon(Icons.arrow_back_ios, size: 22, color: XColors.textColor()),
          const XMargin(15),
        ],
      ),
    ) : null,
    centerTitle: centerTitle,
    title: NormalText(
      text: appBarTitle!,
      fontSize: 17,
      textColor: XColors.black(),
      fontWeight: FontWeight.w600,
    ),
  );

}
