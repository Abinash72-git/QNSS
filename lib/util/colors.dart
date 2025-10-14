import 'package:flutter/material.dart';
import 'package:soapy/config/app_theme.dart';

class AppColor {
  static const Color loginText = Color(0xfffda602);
  static const Color loginButton = Color(0xff0081ff);
  static const Color titleButton = Color(0xff04245f);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color greenColor = Color(0xff186b03);
  static const Color blackColor = Color.fromARGB(255, 12, 12, 12);
  static const Color redColor = Color.fromARGB(255, 187, 15, 3);
  static const Color greyColor =Color.fromARGB(184, 89, 89, 89);

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    // ignore: deprecated_member_use
    background: Color(0xFF121212),
    // ignore: deprecated_member_use
    onBackground: Color(0xFFE0E0E0),
    primary: Color(0xff2196F3),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF004F73),
    onPrimaryContainer: Color(0xFFB3ECFF),
    secondary: Color(0xFF241E1E),
    onSecondary: Color(0xFFE0E0E0),
    secondaryContainer: Color(0xFF3D3D3D),
    onSecondaryContainer: Color(0xFFB3B3B3),
    inversePrimary: Color(0xFF8FDAFF),
    outline: Color(0xFF6D6D6D),
    outlineVariant: Color(0xFFB3B3B3),
    tertiary: Color(0xFF666666),
    onTertiary: Color(0xFF1A1A1A),
    error: Color(0xFFCF6679),
    errorContainer: Color(0xFFB00020),
    onErrorContainer: Color(0xFFFFE5E5),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    surfaceTint: Color(0xFF121212),
    // ignore: deprecated_member_use
    surfaceVariant: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFE0E0E0),
    tertiaryContainer: Color(0xFF1E4066),
    onTertiaryContainer: Color(0xFFE0F7FF),
  );
  static const AppColorScheme customColorScheme = AppColorScheme(
    successColor: Colors.green,
    pendingColor: Colors.orange,
    onPendingColor: Colors.white,
    yellowColor: Color(0xffFFC107),
    pinkColor: Color(0xffE91E63),
    blueColor: Color(0xff2196F3),
    redColor: Colors.red,
  );

  static const ColorScheme colorScheme = ColorScheme.light(
    // ignore: deprecated_member_use
    background: Color(0xFFFFFFFF),
    // ignore: deprecated_member_use
    onBackground: Color(0xFF050505),
    primary: Color(0xff2196F3),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCAF1FC),
    onPrimaryContainer: Colors.white,
    secondary: Color(0xFF241E1E),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF041001),
    onSecondaryContainer: Color(0xFF757575),
    inversePrimary: Color(0xFF8FDAFF),
    outline: Color(0xffA8ACB9),
    outlineVariant: Color(0xFF757575),
    tertiary: Color(0xFFC4C4C4),
    onTertiary: Color(0xFFF3EBEB),
    error: Color(0xFFE50000),
    errorContainer: Color(0xffDC3545),
    onErrorContainer: Colors.white,
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF050505),
    surfaceTint: Color(0xFFFDFDFD),
    // ignore: deprecated_member_use
    surfaceVariant: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF000000),
    tertiaryContainer: Color(0xFF1E4066),
    onTertiaryContainer: Color(0xFFFFFFFF),
  );
}
