import 'package:flutter/material.dart';
import 'package:flutter_campus_feedback/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// Halaman About yang menampilkan informasi tentang aplikasi, developer, dan institusi
/// Menggunakan gradient background dan card-based layout untuk tampilan yang modern
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient yang responsive terhadap tema
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),  // Warna primer dengan opacity
              Theme.of(context).colorScheme.primary.withOpacity(0.4),  // Gradient menuju transparan
              Theme.of(context).colorScheme.background,                // Berakhir dengan background tema
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ============ HEADER DENGAN BACK BUTTON ============ //
                Row(
                  children: [
                    // Tombol back dengan custom styling
                    IconButton(
                      onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2), // Background semi-transparan
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(), // Mengisi space di antara widget
                    // Judul halaman
                    Text(
                      'Tentang Aplikasi',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Spacer untuk balance layout
                  ],
                ),

                const SizedBox(height: 40),

                // ============ LOGO UIN STS JAMBI ============ //
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 6), // Shadow di bawah
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/uin_logo.png', // Path ke asset logo
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                // ============ JUDUL APLIKASI ============ //
                Text(
                  AppConstants.appName, // Mengambil dari constants
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2, // Spasi huruf untuk estetika
                  ),
                ),
                Text(
                  AppConstants.appSubtitle, // Mengambil dari constants
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                // ============ CARD INFORMASI APLIKASI ============ //
                Container(
                  width: double.infinity, // Memenuhi lebar parent
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10), // Shadow elevation
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoItem(
                        icon: Icons.person,
                        title: 'Dosen Pengampu',
                        subtitle: 'Ahmad Nasukha, S.Hum., M.S.I',
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoItem(
                        icon: Icons.school,
                        title: 'Mata Kuliah',
                        subtitle: 'Pemrograman Perangkat Bergerak\n(Mobile Programming)',
                        color: Colors.green,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoItem(
                        icon: Icons.architecture,
                        title: 'Program Studi',
                        subtitle: 'Sistem Informasi',
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoItem(
                        icon: Icons.location_on,
                        title: 'Institusi',
                        subtitle: 'UIN Sulthan Thaha Saifuddin Jambi',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ============ CARD DEVELOPER INFO ============ //
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Info developer
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.code,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Developer',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Jihan Nabillah',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Mahasiswa Sistem Informasi\nSemester 5 - UIN STS Jambi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey.shade300), // Garis pemisah
                      const SizedBox(height: 16),
                      // Technology chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFeatureChip(
                            icon: Icons.phone_android,
                            text: 'Flutter',
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          _buildFeatureChip(
                            icon: Icons.palette,
                            text: 'Material 3',
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 8),
                          _buildFeatureChip(
                            icon: Icons.storage,
                            text: 'SharedPreferences',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ============ CARD TAHUN AKADEMIK ============ //
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0062A3), // Warna biru kampus
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tahun Akademik',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '2025/2026',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tugas UTS Pemrograman Mobile',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ============ TOMBOL KEMBALI KE BERANDA ============ //
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigasi kembali ke home page (route pertama)
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0062A3),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Kembali ke Beranda',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ============ FOOTER ============ //
                Text(
                  'Dibuat dengan ❤️ untuk UTS Pemrograman Mobile',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method untuk membangun item informasi dengan icon
  /// [icon]: IconData untuk icon item
  /// [title]: Judul informasi
  /// [subtitle]: Detail informasi
  /// [color]: Warna tema untuk icon dan background
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container untuk icon dengan background circle
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // Background dengan opacity rendah
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        // Konten teks
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600, // Warna abu-abu untuk secondary text
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87, // Warna hitam untuk primary text
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method untuk membangun chip teknologi yang digunakan
  /// [icon]: IconData untuk icon chip
  /// [text]: Teks yang ditampilkan
  /// [color]: Warna tema chip
  Widget _buildFeatureChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3), // Border dengan warna tema
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ukuran mengikuti konten
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}