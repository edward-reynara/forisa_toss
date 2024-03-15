import 'package:flutter/material.dart';

class ColorPalete {
  static const Color onboardingDotColor = Colors.grey;
  static const Color onboardingDotActive = Colors.green;
  static const Color onboardingTitleColor = Colors.black;
  static const Color onboardingDescriptionColor = Colors.black;

  static final Color shimmerHighlightColor = Colors.grey[400]!;
  static const Color shimmerBaseColor = Colors.grey;
  static const Color shimmerInitColor = Colors.grey;

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return Colors.black;
  }
}