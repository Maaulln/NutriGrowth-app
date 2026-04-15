import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF82),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      scaffoldBackgroundColor: const Color(0xFFF0F7F4),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF0F7F4),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A2E2A),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF2D6A4F),
        unselectedItemColor: Color(0xFF4A6B5D),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
