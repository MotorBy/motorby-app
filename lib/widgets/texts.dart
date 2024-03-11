import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/decorator.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

class TitleText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const TitleText(
      {super.key, required this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: textAlign ?? TextAlign.start,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
          fontSize: fontSize != null ? SizeConfig().sp(fontSize) as double? : 20,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: textColor ?? Colors.black),
    );
  }
}

class NormalText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;

  const NormalText(
      {super.key, required this.text,
      this.fontSize,
      this.textColor,
      this.fontWeight,
      this.textAlign,
      this.maxLines
    });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: fontSize != null ? SizeConfig().sp(fontSize) as double? : 15,
          color: textColor ?? Colors.black,
          fontWeight: fontWeight ?? FontWeight.w400),
    );
  }
}

class NormalTextWithContainer extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? containerPadding;

  const NormalTextWithContainer(
      {super.key, required this.text,
        this.fontSize,
        this.textColor,
        this.fontWeight,
        this.textAlign,
        this.containerPadding,
        this.maxLines
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(containerPadding ?? 8),
      decoration: BoxDecorators.containerDecoration(
          hasOutline: true,
          outlineWidth: 2,
          radius: 32,
          outlineColor: Colors.purpleAccent.withOpacity(0.2)
      ),
      child: Text(
        text!,
        maxLines: maxLines,
        textAlign: textAlign ?? TextAlign.start,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: fontSize != null ? SizeConfig().sp(fontSize) as double? : 15,
            color: textColor ?? Colors.black,
            fontWeight: fontWeight ?? FontWeight.w400),
      ),
    );
  }
}

class AccentText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? textColor;
  final TextAlign? textAlign;

  const AccentText(
      {super.key, required this.text, this.fontSize, this.textColor, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: fontSize != null ? SizeConfig().sp(fontSize) as double? : 15,
          color: textColor ?? Colors.black),
    );
  }
}

class MkText extends StatelessWidget {
  const MkText(
    this.text, {
    Key? key,
    this.textAlign,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  })  : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();

    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines != null ? overflow : null,
      textAlign: textAlign,
      style: style?.copyWith(
        fontSize: config.sp(
          style!.fontSize ?? 12,
        ) as double?,
      ),
    );
  }
}
