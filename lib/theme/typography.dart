import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTypoGraphy {
  static TextTypoGraphy? _instance;

  static TextTypoGraphy? get instance {
    _instance ??= TextTypoGraphy._init();
    return _instance;
  }

  TextTypoGraphy._init();

  TextStyle get displayLarge => GoogleFonts.gabarito(
        fontSize: 93,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
      );
  TextStyle get displayMedium => GoogleFonts.gabarito(
        fontSize: 58,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
      );
  TextStyle get displaySmall => GoogleFonts.gabarito(
        fontSize: 46,
        fontWeight: FontWeight.w400,
      );

  TextStyle get headlineLarge => GoogleFonts.gabarito(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      );
  TextStyle get headlineMedium => GoogleFonts.gabarito(
        fontSize: 33,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      );
  TextStyle get headlineSmall => GoogleFonts.gabarito(
        fontSize: 23,
        fontWeight: FontWeight.w400,
      );

  TextStyle get titleLarge => GoogleFonts.gabarito(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.15,
      );
  TextStyle get titleMedium => GoogleFonts.gabarito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.15,
      );
  TextStyle get titleSmall => GoogleFonts.gabarito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      );

  TextStyle get bodyLarge => GoogleFonts.gabarito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.5,
      );
  TextStyle get bodyMedium => GoogleFonts.gabarito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      );
  TextStyle get bodySmall => GoogleFonts.gabarito(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
      );

  TextStyle get labelLarge => GoogleFonts.gabarito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      );
  TextStyle get labelMedium => GoogleFonts.gabarito(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.5,
      );
  TextStyle get labelSmall => GoogleFonts.gabarito(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.5,
      );

  TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}