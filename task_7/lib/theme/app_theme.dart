import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pastel color palette for the app
class AppColors {
  // Primary pastel colors
  static const Color lavender = Color(0xFFC7B9FF);
  static const Color mint = Color(0xFFB9FFE8);
  static const Color peach = Color(0xFFFFC7B2);
  static const Color cream = Color(0xFFFFFDF7);
  
  // Additional pastel shades
  static const Color softPink = Color(0xFFFFD1E3);
  static const Color softYellow = Color(0xFFFFF5BA);
  static const Color softBlue = Color(0xFFB9E5FF);
  
  // Functional colors
  static const Color softRed = Color(0xFFFFB4B4);
  static const Color textDark = Color(0xFF5A5A5A);
  static const Color textLight = Color(0xFF8A8A8A);
  
  /// Get a random pastel color for variety
  static Color getRandomPastel(int index) {
    final colors = [lavender, mint, peach, softPink, softYellow, softBlue];
    return colors[index % colors.length];
  }
  
  /// Gradient for cards and buttons
  static LinearGradient getPastelGradient(Color color) {
    return LinearGradient(
      colors: [
        color,
        color.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// App theme configuration with pastel aesthetic
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.lavender,
        secondary: AppColors.mint,
        tertiary: AppColors.peach,
        surface: AppColors.cream,
        background: AppColors.cream,
        error: AppColors.softRed,
      ),
      
      scaffoldBackgroundColor: AppColors.cream,
      
      // Text theme with Google Fonts
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.textDark,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textLight,
        ),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
        shadowColor: AppColors.lavender.withOpacity(0.1),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: AppColors.lavender.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.lavender.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.lavender.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.lavender, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.softRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.softRed, width: 2),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textLight),
        hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: AppColors.lavender.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.lavender,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

