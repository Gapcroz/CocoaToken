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
  static final titleLarge = TextStyle(
    color: textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static final titleMedium = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static final bodyLarge = TextStyle(
    color: textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static final bodyMedium = TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static final tokenAmount = TextStyle(
    color: accentColor,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get titleSmall => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textSecondary,
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

  static final headerDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Layout constants
  static const screenPadding = EdgeInsets.symmetric(horizontal: 24.0);
  static const cardPadding = EdgeInsets.all(16.0);
  static const headerPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0);
}
