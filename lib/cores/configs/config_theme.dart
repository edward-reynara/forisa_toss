import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config_colors.dart';

mixin ConfigTheme {
  static ThemeData lightTheme(BuildContext context) =>
      ThemeData.light().copyWith(
        brightness: Brightness.light,
        primaryColor: ConfigColor.primaryColor,
        scaffoldBackgroundColor: ConfigColor.backgroundColor,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
        iconTheme: const IconThemeData(color: ConfigColor.primaryTextColor),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ConfigColor.secondaryColor,
          selectionColor: Colors.grey[300],
          selectionHandleColor: ConfigColor.secondaryColorVariant,
        ),
        indicatorColor: ConfigColor.primaryColor,
        progressIndicatorTheme: Theme.of(context).progressIndicatorTheme.copyWith(
          color: ConfigColor.primaryColor,
        ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: ConfigColor.primaryColor,
          secondary: ConfigColor.secondaryColor,
        ),
      );
}
