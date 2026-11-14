import 'package:flutter/material.dart';

/// The light, friendly palette onboarding and home share. Fixed values rather
/// than [XColors] lookups, so the look holds regardless of theme settings.
class Brand {
  Brand._();

  static const ink = Color(0xFF1D1B20);
  static const muted = Color(0xFF6B6577);
  static const purple = Color(0xFF7A1CAC);
  static const deepPurple = Color(0xFF6E118D);
  static const orchid = Color(0xFFD444F1);
  static const lavender = Color(0xFFF4EFFB);
  static const lilac = Color(0xFFE4D2EE);
  static const line = Color(0xFFEEE8F3);

  static const success = Color(0xFF12B76A);
  static const warning = Color(0xFFF79009);
  static const danger = Color(0xFFF04438);
  static const info = Color(0xFF2E90FA);

  static const font = 'Inter';

  /// The soft lavender wash behind onboarding and home.
  static LinearGradient backdrop([Color tint = purple]) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.lerp(lavender, tint, 0.10)!, Colors.white],
      );

  /// The thin outline cards use instead of shadows.
  static Border get hairline => Border.all(color: line, width: 1);

  static TextStyle text({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = ink,
    double? height,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}
