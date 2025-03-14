import 'package:flutter/material.dart';

class XColors {

  static bool getDarkMode = false;

  static Color background() => getDarkMode != true ? const Color(0xFFFAF8FD) : const Color(0xFF000000);
  static Color white() => getDarkMode != true ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color black() => const Color(0xFF000000);
  static Color primaryColor() => Colors.purpleAccent;
  static Color primaryColor2() => const Color(0xFF6E118D);
  static Color highlightColor() => const Color(0xFFF7D1CD);
  static Color surfaceColor() => getDarkMode != true ? const Color(0xFFC42D32) : const Color(0xFFFFFFFF);
  static Color decoratorContainerColor() => getDarkMode != true ? const Color(0xFFFFFFFF) : const Color(0xFF2D0203) ;
  static Color textColor() => getDarkMode != true ? Colors.black87 : const Color(0xFFFFFFFF).withOpacity(0.9);

}
