import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Constantes de color usando nombres más descriptivos
  static const primaryColor = Color(0xFF111827);
  static const secondaryColor = Color(0xFFD4A373);
  static const accentColor = Color(0xFF1E40AF);
  static const greyColor = Color(0xFFB0AFAF);

  // Colores de navegación
  static const navigationBarColor = Color(0xFF111827);
  static const navigationBarSelectedItemColor = Colors.white;
  static const navigationBarUnselectedItemColor = Colors.white70;

  // Colores de texto
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.black87;
  static const textGrey = Color(0xFF6B7280);

  // Estilos de texto como getters para mejor rendimiento
  static TextStyle get titleLarge => const TextStyle(
    color: textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get titleMedium => const TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyLarge => const TextStyle(
    color: textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyMedium => const TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get tokenAmount => const TextStyle(
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

  // Decoraciones como getters para mejor rendimiento
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: secondaryColor,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration get headerDecoration => BoxDecoration(
    color: primaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(26),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Constantes de padding
  static const screenPadding = EdgeInsets.symmetric(horizontal: 24.0);
  static const cardPadding = EdgeInsets.all(16.0);
  static const headerPadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 24.0,
  );

  // Método para precarga de fuentes
  static Future<void> preloadFonts() async {
    await GoogleFonts.pendingFonts([GoogleFonts.poppins()]);
  }

  // Tema base sin fuentes personalizadas
  static ThemeData get theme => ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: primaryColor,
    ),
    useMaterial3: true,
  );

  // Tema completo con fuentes personalizadas
  static ThemeData getThemeWithFonts(BuildContext context) {
    return theme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(theme.textTheme),
    );
  }
}
