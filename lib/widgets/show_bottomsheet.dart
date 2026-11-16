import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Shows [child] in a modal sheet; the returned future completes when it closes.
Future<void> modalBottomSheetMenu({
  required BuildContext context,
  double? radius,
  Widget? child,
  bool? isDismissible,
  double? height,
  Color? color}) {
  return showModalBottomSheet<void>(
      isDismissible: isDismissible ?? true,
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius ?? 26),
              topRight: Radius.circular(radius ?? 26)
          )
      ),
      backgroundColor: color ?? Theme.of(context).scaffoldBackgroundColor,
      builder: (builder) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                maxHeight: height ?? MediaQuery.of(context).size.height * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: child,
            ),
          ),
        );
      }
  );
}