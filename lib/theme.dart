import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warm, natural design system — Light & Dark modes.
class AppTheme {
  // --- Light Mode Colors ---
  static const Color primaryTerracotta = Color(0xFFC2662D);
  static const Color secondaryOlive = Color(0xFF5B7553);
  static const Color tertiaryPlum = Color(0xFF7C5A8A);
  static const Color accentAmber = Color(0xFFD4943A);

  static const Color lightTextPrimary = Color(0xFF2D2419);
  static const Color lightTextSecondary = Color(0xFF6B5D50);
  static const Color lightTextDisabled = Color(0xFFA89B8C);

  static const Color lightPageBg = Color(0xFFFDF8F3);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFF5EDE4);
  static const Color lightBorderColor = Color(0xFFE0D5C9);
  static const Color lightBorderSubdued = Color(0xFFEDE5DB);

  static const Color lightSuccess = Color(0xFF5B7553);
  static const Color lightWarning = Color(0xFFD4943A);
  static const Color lightCritical = Color(0xFFBF4A4A);

  // --- Dark Mode Colors ---
  static const Color darkPrimary = Color(0xFFD4885A);
  static const Color darkSecondary = Color(0xFF8BAF82);
  static const Color darkTertiary = Color(0xFFA98AB8);

  static const Color darkTextPrimary = Color(0xFFF0E8DF);
  static const Color darkTextSecondary = Color(0xFFB8A898);
  static const Color darkTextDisabled = Color(0xFF7A6E62);

  static const Color darkPageBg = Color(0xFF1A1410);
  static const Color darkSurface = Color(0xFF241E18);
  static const Color darkSurfaceMuted = Color(0xFF2E2720);
  static const Color darkBorderColor = Color(0xFF3D352C);
  static const Color darkBorderSubdued = Color(0xFF332C24);

  static const Color darkSuccess = Color(0xFF8BAF82);
  static const Color darkWarning = Color(0xFFD4943A);
  static const Color darkCritical = Color(0xFFD46B6B);

  /// Light Theme
  static ThemeData get lightTheme {
    final base = GoogleFonts.outfitTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightPageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: lightTextPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: lightTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: lightTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: lightTextSecondary,
          fontSize: 13,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: lightTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: lightTextDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryTerracotta,
        secondary: secondaryOlive,
        tertiary: tertiaryPlum,
        error: lightCritical,
        surface: lightSurface,
        surfaceContainerHighest: lightSurfaceMuted,
        onSurface: lightTextPrimary,
        outline: lightBorderColor,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shadowColor: const Color(0x1A2D2419),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: lightTextPrimary, size: 22),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceMuted,
        prefixIconColor: lightTextDisabled,
        suffixIconColor: lightTextDisabled,
        hintStyle: GoogleFonts.outfit(color: lightTextDisabled, fontSize: 14),
        labelStyle: GoogleFonts.outfit(color: lightTextSecondary, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: primaryTerracotta, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: lightCritical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTerracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: lightBorderColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryTerracotta,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceMuted,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorderSubdued,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryTerracotta,
        unselectedItemColor: lightTextDisabled,
        selectedLabelStyle:
            GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        elevation: 4,
        shadowColor: const Color(0x0F2D2419),
        surfaceTintColor: Colors.transparent,
        indicatorColor: primaryTerracotta.withValues(alpha: 0.10),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryTerracotta, size: 24);
          }
          return const IconThemeData(color: lightTextDisabled, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: primaryTerracotta,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: lightTextDisabled,
          );
        }),
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    final base = GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkPageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: darkTextPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: darkTextSecondary,
          fontSize: 13,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: darkTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: darkTextDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkTertiary,
        error: darkCritical,
        surface: darkSurface,
        surfaceContainerHighest: darkSurfaceMuted,
        onSurface: darkTextPrimary,
        outline: darkBorderColor,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shadowColor: const Color(0x331A1410),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: darkTextPrimary, size: 22),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceMuted,
        prefixIconColor: darkTextDisabled,
        suffixIconColor: darkTextDisabled,
        hintStyle: GoogleFonts.outfit(color: darkTextDisabled, fontSize: 14),
        labelStyle: GoogleFonts.outfit(color: darkTextSecondary, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: darkPrimary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: darkCritical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorderColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceMuted,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorderSubdued,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: darkTextDisabled,
        selectedLabelStyle:
            GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        indicatorColor: darkPrimary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: darkPrimary, size: 24);
          }
          return const IconThemeData(color: darkTextDisabled, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: darkPrimary,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: darkTextDisabled,
          );
        }),
      ),
    );
  }
}
