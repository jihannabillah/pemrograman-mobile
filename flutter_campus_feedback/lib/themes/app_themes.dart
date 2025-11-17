import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kelas yang mendefinisikan tema aplikasi untuk mode terang dan gelap
/// Menggunakan Material 3 dan Google Fonts untuk konsistensi desain
class AppThemes {
  
  /// Tema untuk mode terang (light mode)
  /// Menggunakan warna biru sebagai warna utama (seed color)
  static final lightTheme = ThemeData(
    // Mengaktifkan Material 3 design system
    useMaterial3: true,
    
    /// Color Scheme untuk light mode
    /// Menggunakan fromSeed untuk generate palette warna yang harmonis
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0062A3), // Warna biru tua sebagai basis
      brightness: Brightness.light,       // Mode terang
      primary: const Color(0xFF0062A3),   // Warna primer - biru tua
      secondary: const Color(0xFF6C63FF), // Warna sekunder - ungu
      tertiary: const Color(0xFF00B0FF),  // Warna tersier - biru muda
      background: const Color(0xFFF8F9FA), // Warna background - abu-abu sangat muda
      surface: Colors.white,              // Warna surface - putih
    ),
    
    /// Konfigurasi font family menggunakan Google Fonts Poppins
    fontFamily: GoogleFonts.poppins().fontFamily,
    
    /// Custom text theme dengan variasi ukuran dan weight
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      // Untuk judul besar (headline)
      displayLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87, // Hampir hitam untuk kontras baik
      ),
      // Untuk judul medium (subhead)
      displayMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600, // Semi-bold
        color: Colors.black87,
      ),
      // Untuk teks body besar
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500, // Medium
        color: Colors.black87,
      ),
      // Untuk teks body regular
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black54, // Abu-abu gelap untuk teks sekunder
      ),
    ),
    
    /// Konfigurasi AppBar untuk light mode
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0062A3), // Biru tua
      foregroundColor: Colors.white,            // Teks dan icon putih
      elevation: 0,                             // Tanpa bayangan
      centerTitle: true,                        // Judul di tengah
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    
    // CATATAN: CardThemeData masih dalam development di Material 3
    // cardTheme: CardThemeData(  // ✅ COMMENT DULU JIKA MASIH ERROR
    //   elevation: 3,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   color: Colors.white,
    //   margin: EdgeInsets.zero,
    // ),
    
    /// Konfigurasi tema untuk input fields (TextField, Dropdown, dll)
    inputDecorationTheme: InputDecorationTheme(
      // Border default
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Sudut melengkung
        borderSide: const BorderSide(color: Colors.grey),
      ),
      // Border ketika tidak focused
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      // Border ketika focused (sedang dipilih)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0062A3), width: 2), // Biru tua dengan border lebih tebal
      ),
      filled: true,           // Mengaktifkan background fill
      fillColor: Colors.white, // Warna background putih
    ),
  );

  /// Tema untuk mode gelap (dark mode)
  /// Menggunakan warna ungu sebagai warna utama dengan background gelap
  static final darkTheme = ThemeData(
    useMaterial3: true,
    
    /// Color Scheme untuk dark mode
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C63FF), // Warna ungu sebagai basis
      brightness: Brightness.dark,        // Mode gelap
      primary: const Color(0xFF6C63FF),   // Warna primer - ungu
      secondary: const Color(0xFF00B0FF), // Warna sekunder - biru muda
      tertiary: const Color(0xFF00E5FF),  // Warna tersier - biru terang
      background: const Color(0xFF121212), // Background - hitam pekat
      surface: const Color(0xFF1E1E1E),   // Surface - abu-abu sangat gelap
    ),
    
    /// Font family sama dengan light mode untuk konsistensi
    fontFamily: GoogleFonts.poppins().fontFamily,
    
    /// Text theme untuk dark mode dengan warna putih
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Putih untuk kontras dengan background gelap
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.white70, // Putih transparan untuk teks sekunder
      ),
    ),
    
    /// Konfigurasi AppBar untuk dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A1A), // Abu-abu sangat gelap
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    
    // CATATAN: CardThemeData masih dalam development di Material 3
    // cardTheme: CardThemeData(  // ✅ COMMENT DULU JIKA MASIH ERROR
    //   elevation: 4,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   color: Color(0xFF1E1E1E),
    //   margin: EdgeInsets.zero,
    // ),
    
    /// Konfigurasi input fields untuk dark mode
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2), // Ungu dengan border tebal
      ),
      filled: true,
      fillColor: const Color(0xFF2D2D2D), // Background abu-abu gelap untuk input
    ),
  );
}