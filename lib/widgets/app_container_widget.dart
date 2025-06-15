import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    Key? key,
    this.onTap,
    this.child,
    this.height,
    this.width,
    this.tapColor,
    this.backgroundColor,
    this.borderColor,
    this.borderThickness,
    this.borderRadius,
    this.decoration,
    this.padding,
    this.margin,
    this.hasBorder = false,
    this.shape = BoxShape.rectangle,
    this.constraints,
    this.alignment,
    this.animatingDuration = const Duration(milliseconds: 500),
    this.elevation = 0.0,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Widget? child;
  final double? height;
  final double? width;
  final Color? tapColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Decoration? decoration;
  final double? borderThickness;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool hasBorder;
  final BoxShape shape;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Duration animatingDuration;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        elevation: elevation!,
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
          splashColor: tapColor,
          onTap: onTap,
          child: AnimatedContainer(
            duration: animatingDuration,
            padding: padding,
            height: height,
            width: width,
            constraints: constraints,
            alignment: alignment,
            decoration: decoration ??
                BoxDecoration(
                  border: hasBorder
                      ? Border.all(
                          color: borderColor ??
                              Theme.of(context).colorScheme.surface,
                          width: borderThickness ?? 0.5,
                        )
                      : null,
                  borderRadius: borderRadius,
                  shape: shape,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
