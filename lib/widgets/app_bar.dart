import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class InsuranceAppBar extends StatelessWidget implements PreferredSizeWidget {
  InsuranceAppBar({
    super.key,
    required this.text1,
    this.noAction = false,
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
            Navigator.of(context).pop();
          },
          child: const GetSvgImage(
            image: 'assets/images/arrow_back.svg',
            boxFit: BoxFit.scaleDown,
          )),
      centerTitle: false,
      title: NormalText(
        text: text1,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}

AppBar appBarHeader({
  Function? onCloseAction,
  String? appBarTitle,
  List<Widget>? actions,
  BuildContext? context,
  bool? hasOnBack = true }) {

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
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Icon(Icons.arrow_back_ios, size: 22, color: XColors.textColor()),
      ),
    ) : null,
    centerTitle: true,
    title: NormalText(
      text: appBarTitle!,
      fontSize: 17,
      textColor: XColors.black(),
      fontWeight: FontWeight.w600,
    ),
  );

}
