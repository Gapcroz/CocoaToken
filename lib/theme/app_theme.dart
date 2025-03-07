import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color scheme definitions
  static const Color primaryColor = Color(0xFF111827);
  static const Color secondaryColor = Color(0xFFD4A373);
  static const Color accentColor = Color(0xFF1E40AF);
  static const Color greyColor = Color(0xFFB0AFAF);
  
  // Typography color palette
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.black87;
  static const Color textGrey = Color(0xFF6B7280);

  // Text styles
  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textSecondary,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle get tokenAmount => GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: accentColor,
  );

  static TextStyle get tokenLabel => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: accentColor,
  );

  // Common decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: secondaryColor,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration get headerDecoration => const BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
  );

  // Layout constants
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 24.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets headerPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0);
}
