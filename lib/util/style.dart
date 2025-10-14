import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  // Add the responsiveFontSize method
  static double responsiveFontSize(BuildContext context, double baseFontSize) {
    return MediaQuery.of(context).textScaleFactor * baseFontSize;
  }

  static TextStyle textStyleLogin(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize, // optional override
  }) {
    return GoogleFonts.roboto(
      color: color,
      fontWeight: FontWeight.w900,
      fontSize: fontSize ?? responsiveFontSize(context, 30),
    );
  }

  static TextStyle textStyleSmall(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? responsiveFontSize(context, 16),
    );
  }

  static TextStyle textStyleSmall1(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? responsiveFontSize(context, 18),
    );
  }

  static TextStyle textStyleSmall2(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? responsiveFontSize(context, 14),
    );
  }

  static TextStyle textStyleSmall3(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.w800,
      fontSize: fontSize ?? responsiveFontSize(context, 14),
    );
  }

  static TextStyle textStyleVerySmall(
    BuildContext context, {
    Color color = Colors.black,
    double? fontSize,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? responsiveFontSize(context, 10),
    );
  }

  static TextStyle textStyleButton(
    BuildContext context, {
    Color color = const Color.fromARGB(255, 250, 248, 248),
    double? fontSize,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? responsiveFontSize(context, 22),
    );
  }
}
