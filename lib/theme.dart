import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Research analytics design system supporting Light and Dark modes.
class AppTheme {
  // --- Dark Mode Colors ---
  static const Color brandGreen = Color(0xFF34D399);
  static const Color darkGreen = Color(0xFF10B981);
  static const Color interactiveBlue = Color(0xFF38BDF8);
  static const Color indigo = Color(0xFFA78BFA);
  static const Color dashboardBlue = Color(0xFF60A5FA);

  static const Color textPrimary = Color(0xFFE5EEF9);
  static const Color textSecondary = Color(0xFF9FB0C7);
  static const Color textDisabled = Color(0xFF64748B);

  static const Color pageBg = Color(0xFF08111F);
  static const Color surface = Color(0xFF0F1B2D);
  static const Color surfaceMuted = Color(0xFF17263B);
  static const Color borderColor = Color(0xFF2A3A52);
  static const Color borderSubdued = Color(0xFF1E2D42);

  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color critical = Color(0xFFF87171);
  static const Color highlight = Color(0xFF102A43);

  static const Color greenSoft = Color(0x2634D399);
  static const Color blueSoft = Color(0x2638BDF8);
  static const Color amberSoft = Color(0x26F59E0B);

  // --- Light Mode Colors ---
  static const Color accentBlue = Color(
    0xFF2563EB,
  ); // Darker blue for readability on light background
  static const Color accentGreen = Color(
    0xFF059669,
  ); // Darker green for readability

  static const Color lightTextPrimary = Color(0xFF0D1B2A);
  static const Color lightTextSecondary = Color(0xFF4A6080);
  static const Color lightTextDisabled = Color(0xFF94A3B8);

  static const Color lightPageBg = Color(0xFFF0F4F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFEBF0F6);
  static const Color lightBorderColor = Color(0xFFCBD5E1);
  static const Color lightBorderSubdued = Color(0xFFE2E8F0);

  static const Color lightSuccess = Color(0xFF059669);
  static const Color lightWarning = Color(0xFFD97706);
  static const Color lightCritical = Color(0xFFDC2626);
  static const Color lightHighlight = Color(0xFFE2E8F0);

  static const Color lightGreenSoft = Color(0x1A059669);
  static const Color lightBlueSoft = Color(0x1A2563EB);
  static const Color lightAmberSoft = Color(0x1AD97706);

  /// Dark Theme (formerly lightTheme, redesigned for dark theme)
  static ThemeData get darkTheme {
    final base = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: pageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.3,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.4,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.6,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          color: textSecondary,
          fontSize: 13,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelSmall: base.labelSmall?.copyWith(
          color: textDisabled,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: dashboardBlue,
        secondary: brandGreen,
        tertiary: indigo,
        error: critical,
        surface: surface,
        surfaceContainerHighest: surfaceMuted,
        onSurface: textPrimary,
        outline: borderColor,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderSubdued, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
        shape: const Border(bottom: BorderSide(color: borderSubdued, width: 1)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        prefixIconColor: textDisabled,
        suffixIconColor: textDisabled,
        hintStyle: GoogleFonts.inter(color: textDisabled, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: dashboardBlue, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: critical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dashboardBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: dashboardBlue,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubdued,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: dashboardBlue,
        unselectedItemColor: textDisabled,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        indicatorColor: dashboardBlue.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: dashboardBlue, size: 24);
          }
          return const IconThemeData(color: textDisabled, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: dashboardBlue,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textDisabled,
          );
        }),
      ),
    );
  }

  /// Light Theme
  static ThemeData get lightTheme {
    final base = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightPageBg,
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: lightTextPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.2,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
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
        primary: accentBlue,
        secondary: accentGreen,
        tertiary: Color(0xFF6D28D9),
        error: lightCritical,
        surface: lightSurface,
        surfaceContainerHighest: lightSurfaceMuted,
        onSurface: lightTextPrimary,
        outline: lightBorderColor,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: lightBorderSubdued, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: lightTextPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        iconTheme: const IconThemeData(color: lightTextPrimary, size: 22),
        shape: const Border(
          bottom: BorderSide(color: lightBorderSubdued, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceMuted,
        prefixIconColor: lightTextDisabled,
        suffixIconColor: lightTextDisabled,
        hintStyle: GoogleFonts.inter(color: lightTextDisabled, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: lightTextSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: lightBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: lightBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: accentBlue, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: lightCritical, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.inter(
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentBlue,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorderSubdued,
        thickness: 1,
        space: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: accentBlue,
        unselectedItemColor: lightTextDisabled,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        elevation: 0,
        indicatorColor: accentBlue.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: accentBlue, size: 24);
          }
          return const IconThemeData(color: lightTextDisabled, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accentBlue,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: lightTextDisabled,
          );
        }),
      ),
    );
  }
}
