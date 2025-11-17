import 'package:flutter/material.dart';
import 'package:flutter_campus_feedback/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// Halaman utama (Home) aplikasi Campus Feedback
/// Menampilkan menu navigasi utama dengan gradient background dan UI yang menarik
class HomePage extends StatelessWidget {
  final VoidCallback onThemeChanged;  // Callback untuk toggle tema gelap/terang
  final bool isDarkMode;              // Status tema saat ini (true = dark mode)

  const HomePage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  // ============ NAVIGATION METHODS ============ //

  /// Navigasi ke halaman Form Feedback
  void _navigateToForm(BuildContext context) {
    Navigator.pushNamed(context, '/form');
  }

  /// Navigasi ke halaman Daftar Feedback
  void _navigateToList(BuildContext context) {
    Navigator.pushNamed(context, '/list');
  }

  /// Navigasi ke halaman Tentang Aplikasi
  void _navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient yang responsive terhadap tema
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    // Gradient untuk dark mode
                    const Color(0xFF1A1A1A),  // Hitam pekat
                    const Color(0xFF2D2D2D),  // Abu-abu gelap
                    const Color(0xFF1A1A1A),  // Hitam pekat
                  ]
                : [
                    // Gradient untuk light mode  
                    const Color(0xFF0062A3),  // Biru tua (warna kampus)
                    const Color(0xFF00B0FF),  // Biru muda
                    Colors.white,             // Putih
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ============ HEADER DENGAN THEME TOGGLE ============ //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Theme toggle button
                    IconButton(
                      onPressed: onThemeChanged,
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                        size: 28,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2), // Background semi-transparan
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    // App title
                    Text(
                      'Campus Feedback',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Spacer untuk balance layout (menggantikan widget kosong)
                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 40),

                // ============ LOGO DAN JUDUL APLIKASI ============ //
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // Background semi-transparan
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3), // Border subtle
                    ),
                  ),
                  child: Column(
                    children: [
                      // Logo container dengan shadow
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4), // Shadow di bawah
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/flutter_logo.png', // Logo Flutter framework
                          fit: BoxFit.contain,
                         ),
                      ),
                      const SizedBox(height: 20),
                      // Nama aplikasi
                      Text(
                        AppConstants.appName, // Mengambil dari constants
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2, // Spasi huruf untuk estetika
                        ),
                      ),
                      // Subtitle aplikasi
                      Text(
                        AppConstants.appSubtitle, // Mengambil dari constants
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ============ MENU BUTTONS ============ //
                Expanded(
                 child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Button Formulir Feedback
                      _buildMenuButton(
                        context,
                        icon: Icons.feedback,
                        title: 'Formulir Feedback',
                        subtitle: 'Isi kuesioner kepuasan',
                        onTap: () => _navigateToForm(context),
                        color: const Color(0xFF4CAF50), // Hijau
                      ),
                      const SizedBox(height: 16),
                      // Button Daftar Feedback
                      _buildMenuButton(
                        context,
                        icon: Icons.list_alt,
                        title: 'Daftar Feedback',
                        subtitle: 'Lihat semua masukan',
                        onTap: () => _navigateToList(context),
                        color: const Color(0xFF2196F3), // Biru
                      ),
                      const SizedBox(height: 16),
                      // Button Tentang Aplikasi
                      _buildMenuButton(
                        context,
                        icon: Icons.info,
                        title: 'Tentang Aplikasi',
                        subtitle: 'Profil & developer',
                        onTap: () => _navigateToAbout(context),
                        color: const Color(0xFF9C27B0), // Ungu
                      ),
                    ],
                  ),
                ),
                ),

                // ============ MOTIVATIONAL QUOTE ============ //
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon lampu untuk quote motivasi
                      Icon(
                        Icons.lightbulb,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      // Quote text
                      Expanded(
                        child: Text(
                          AppConstants.motivationQuote, // Mengambil dari constants
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontStyle: FontStyle.italic, // Style italic untuk quote
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method untuk membangun menu button yang konsisten
  /// [context]: BuildContext untuk theme access
  /// [icon]: IconData untuk button
  /// [title]: Judul menu
  /// [subtitle]: Deskripsi menu
  /// [onTap]: Function yang dipanggil saat button ditekan
  /// [color]: Warna utama button (untuk gradient)
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent, // Transparent agar gradient terlihat
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity, // Memenuhi lebar available
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // Gradient background dengan warna yang ditentukan
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8), // Warna lebih solid di kiri atas
                color.withOpacity(0.6), // Warna lebih transparan di kanan bawah
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3), // Shadow dengan warna tema
                blurRadius: 10,
                offset: const Offset(0, 4), // Shadow di bawah
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Background semi-transparan
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8), // Sedikit transparan
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Navigation arrow
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.7),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}