import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void modalBottomSheetMenu({
  required BuildContext context,
  double? radius,
  Widget? child,
  bool? isDismissible,
  double? height,
  Color? color}) {
  showModalBottomSheet(
      isDismissible: isDismissible ?? true,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius ?? 26),
              topRight: Radius.circular(radius ?? 26)
          )
      ),
      backgroundColor: color ?? Theme.of(context).scaffoldBackgroundColor,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
      }
  );
}