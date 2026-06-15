import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm orange & white design system — Light and Dark modes.
class AppTheme {
  // ─── Light Mode Colors ───
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color deepOrange = Color(0xFFEA580C);
  static const Color amber = Color(0xFFD97706);
  static const Color warmRed = Color(0xFFEF4444);

  static const Color ltPageBg = Color(0xFFFFF9F3);
  static const Color ltSurface = Color(0xFFFFFFFF);
  static const Color ltSurfaceMuted = Color(0xFFFFF1E6);
  static const Color ltBorder = Color(0xFFE8DDD4);
  static const Color ltBorderSubdued = Color(0xFFF3EDE6);

  static const Color ltTextPrimary = Color(0xFF1C1210);
  static const Color ltTextSecondary = Color(0xFF6B5C52);
  static const Color ltTextDisabled = Color(0xFFA39688);

  static const Color ltSuccess = Color(0xFF16A34A);
  static const Color ltCritical = Color(0xFFDC2626);

  // ─── Dark Mode Colors ───
  static const Color dkOrange = Color(0xFFFB923C);
  static const Color dkDeepOrange = Color(0xFFF97316);
  static const Color dkAmber = Color(0xFFFBBF24);

  static const Color dkPageBg = Color(0xFF1A1210);
  static const Color dkSurface = Color(0xFF261E1A);
  static const Color dkSurfaceMuted = Color(0xFF332820);
  static const Color dkBorder = Color(0xFF4A3B30);
  static const Color dkBorderSubdued = Color(0xFF3A2E24);

  static const Color dkTextPrimary = Color(0xFFFFF5EB);
  static const Color dkTextSecondary = Color(0xFFBFA894);
  static const Color dkTextDisabled = Color(0xFF7A6A5C);

  static const Color dkSuccess = Color(0xFF4ADE80);
  static const Color dkCritical = Color(0xFFF87171);

  /// Light Theme
  static ThemeData get lightTheme {
    final base = GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ltPageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: ltTextPrimary, fontSize: 26, fontWeight: FontWeight.w700,
          letterSpacing: -0.3, height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: ltTextPrimary, fontSize: 20, fontWeight: FontWeight.w600,
          letterSpacing: -0.2, height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: ltTextPrimary, fontSize: 16, fontWeight: FontWeight.w600,
          letterSpacing: 0, height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: ltTextPrimary, fontSize: 14, fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: ltTextPrimary, fontSize: 14, fontWeight: FontWeight.w400, height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: ltTextSecondary, fontSize: 13, height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: ltTextSecondary, fontSize: 12, fontWeight: FontWeight.w500, height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: ltTextDisabled, fontSize: 12, fontWeight: FontWeight.w400,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        secondary: deepOrange,
        tertiary: amber,
        error: ltCritical,
        surface: ltSurface,
        surfaceContainerHighest: ltSurfaceMuted,
        onSurface: ltTextPrimary,
        onSurfaceVariant: ltTextSecondary,
        outline: ltBorder,
      ),
      cardTheme: CardThemeData(
        color: ltSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: ltBorderSubdued, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ltSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: ltTextPrimary, fontSize: 18, fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: ltTextPrimary, size: 22),
        shape: const Border(
          bottom: BorderSide(color: ltBorderSubdued, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ltSurfaceMuted,
        prefixIconColor: ltTextDisabled,
        suffixIconColor: ltTextDisabled,
        hintStyle: GoogleFonts.poppins(color: ltTextDisabled, fontSize: 13),
        labelStyle: GoogleFonts.poppins(color: ltTextSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ltBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ltBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryOrange, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ltCritical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryOrange,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: ltBorderSubdued, thickness: 1, space: 0),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ltSurface,
        elevation: 0,
        height: 68,
        indicatorColor: primaryOrange.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryOrange, size: 24);
          }
          return const IconThemeData(color: ltTextDisabled, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w700, color: primaryOrange,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w500, color: ltTextDisabled,
          );
        }),
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    final base = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: dkPageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: dkTextPrimary, fontSize: 26, fontWeight: FontWeight.w700,
          letterSpacing: -0.3, height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: dkTextPrimary, fontSize: 20, fontWeight: FontWeight.w600,
          letterSpacing: -0.2, height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: dkTextPrimary, fontSize: 16, fontWeight: FontWeight.w600,
          letterSpacing: 0, height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: dkTextPrimary, fontSize: 14, fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: dkTextPrimary, fontSize: 14, fontWeight: FontWeight.w400, height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: dkTextSecondary, fontSize: 13, height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: dkTextSecondary, fontSize: 12, fontWeight: FontWeight.w500, height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: dkTextDisabled, fontSize: 12, fontWeight: FontWeight.w400,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: dkOrange,
        secondary: dkDeepOrange,
        tertiary: dkAmber,
        error: dkCritical,
        surface: dkSurface,
        surfaceContainerHighest: dkSurfaceMuted,
        onSurface: dkTextPrimary,
        onSurfaceVariant: dkTextSecondary,
        outline: dkBorder,
      ),
      cardTheme: CardThemeData(
        color: dkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: dkBorderSubdued, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dkSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: dkTextPrimary, fontSize: 18, fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: dkTextPrimary, size: 22),
        shape: const Border(
          bottom: BorderSide(color: dkBorderSubdued, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dkSurfaceMuted,
        prefixIconColor: dkTextDisabled,
        suffixIconColor: dkTextDisabled,
        hintStyle: GoogleFonts.poppins(color: dkTextDisabled, fontSize: 13),
        labelStyle: GoogleFonts.poppins(color: dkTextSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dkOrange, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dkCritical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dkOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: dkOrange,
          side: const BorderSide(color: dkOrange),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: dkOrange,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: dkOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: dkBorderSubdued, thickness: 1, space: 0),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dkSurface,
        elevation: 0,
        height: 68,
        indicatorColor: dkOrange.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: dkOrange, size: 24);
          }
          return const IconThemeData(color: dkTextDisabled, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w700, color: dkOrange,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w500, color: dkTextDisabled,
          );
        }),
      ),
    );
  }
}
