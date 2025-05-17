import 'package:flutter/material.dart';

class XColors {

  static bool getDarkMode = false;

  static Color background() => getDarkMode != true ? Colors.white : const Color(0xFF000000);
  static Color white() => getDarkMode != true ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color black() => const Color(0xFF000000);
  static Color primaryColor() => Colors.purpleAccent;
  static Color primaryColor2() => const Color(0xFF6E118D);
  static Color buttonColor()=> const Color(0xff7A1CAC);
  static Color secondaryColor()=> const Color(0xFFE4D2EE);
  static Color borderColor()=> const Color(0xFFD0D5DD);
  static Color highlightColor() => const Color(0xFFF7D1CD);
  static Color containerColor() => const Color(0xFFF4EFFB);
  static Color surfaceColor() => getDarkMode != true ? const Color(0xFFC42D32) : const Color(0xFFFFFFFF);
  static Color red() => const Color(0xFFC42D32);
  static Color decoratorContainerColor() => getDarkMode != true ? const Color(0xFFFFFFFF) : const Color(0xFF2D0203) ;
  static Color textColor() => getDarkMode != true ? Colors.black87 : const Color(0xFFFFFFFF).withOpacity(0.9);

}
