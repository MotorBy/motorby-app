import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';

class DividerWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  const DividerWidget({
    super.key,
    this.margin,
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      color: color ?? XColors.borderColor(),
      height: height ?? 1.0,
      thickness: thickness ?? 1.0,
      indent: indent,
      endIndent: endIndent,
    );

    if (margin != null) {
      return Padding(
        padding: margin!,
        child: divider,
      );
    }

    return divider;
  }
}
