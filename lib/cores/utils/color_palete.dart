import 'package:flutter/material.dart';

class ColorPalete {
  static final Color onboardingDotColor = Colors.grey;
  static final Color onboardingDotActive = Colors.green;
  static final Color onboardingTitleColor = Colors.black;
  static final Color onboardingDescriptionColor = Colors.black;

  static final Color shimmerHighlightColor = Colors.grey[400]!;
  static final Color shimmerBaseColor = Colors.grey;
  static final Color shimmerInitColor = Colors.grey;

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return Colors.black;
  }
}