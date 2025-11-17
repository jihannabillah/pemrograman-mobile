import 'package:flutter/material.dart';
import 'package:flutter_campus_feedback/models/feedback_item.dart';
import 'package:google_fonts/google_fonts.dart';

/// Halaman untuk menampilkan detail lengkap dari sebuah feedback
/// Menampilkan semua informasi feedback dengan UI yang terorganisir dan informatif
class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem feedback;        // Data feedback yang akan ditampilkan
  final Function(FeedbackItem) onDelete; // Callback function untuk menghapus feedback

  const FeedbackDetailPage({
    super.key,
    required this.feedback,
    required this.onDelete,
  });

  /// Menampilkan dialog konfirmasi sebelum menghapus feedback
  /// [context]: BuildContext untuk showDialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Hapus Feedback?',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus feedback dari ${feedback.nama}? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          // Tombol batal
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Tombol hapus
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              onDelete(feedback);     // Panggil callback delete
              Navigator.pop(context); // Kembali ke halaman list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Helper method untuk membangun item detail informasi
  /// [context]: BuildContext untuk mengakses theme
  /// [label]: Label/title untuk informasi
  /// [value]: Nilai/informasi yang ditampilkan
  /// [icon]: Icon opsional untuk item
  Widget _buildDetailItem(BuildContext context, String label, String value, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan section rating dengan progress bar
  Widget _buildRatingSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getRatingColor(feedback.nilaiKepuasan).withOpacity(0.1),
            _getRatingColor(feedback.nilaiKepuasan).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getRatingColor(feedback.nilaiKepuasan).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Header rating dengan nilai
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nilai Kepuasan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              // Badge dengan nilai rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getRatingColor(feedback.nilaiKepuasan),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      feedback.nilaiKepuasan.toStringAsFixed(1), // Format 1 decimal
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar visualisasi rating
          LinearProgressIndicator(
            value: feedback.nilaiKepuasan / 5, // Convert ke range 0-1
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getRatingColor(feedback.nilaiKepuasan),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          // Label rating scale
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1', // Minimum rating
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _getRatingText(feedback.nilaiKepuasan), // Textual rating
                style: GoogleFonts.poppins(
                  color: _getRatingColor(feedback.nilaiKepuasan),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '5', // Maximum rating
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan chips fasilitas yang dinilai
  /// [context]: BuildContext untuk mengakses theme
  Widget _buildFacilitiesChips(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header fasilitas
          Row(
            children: [
              const Icon(Icons.architecture, size: 20),
              const SizedBox(width: 8),
              Text(
                'Fasilitas yang Dinilai',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Chips untuk setiap fasilitas
          Wrap(
            spacing: 8, // Spasi horizontal antar chips
            runSpacing: 8, // Spasi vertical antar baris chips
            children: feedback.fasilitas.map((facility) {
              return Chip(
                label: Text(
                  facility,
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact, // Ukuran compact
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan badge jenis feedback
  Widget _buildFeedbackTypeBadge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getFeedbackColor(feedback.jenisFeedback).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getFeedbackColor(feedback.jenisFeedback).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFeedbackIcon(feedback.jenisFeedback),
            color: _getFeedbackColor(feedback.jenisFeedback),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Feedback',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  feedback.jenisFeedback,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getFeedbackColor(feedback.jenisFeedback),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ HELPER METHODS ============ //

  /// Mendapatkan warna berdasarkan nilai rating
  /// [rating]: Nilai kepuasan (1-5)
  Color _getRatingColor(double rating) {
    if (rating < 2) return Colors.red;        // Sangat buruk
    if (rating < 3) return Colors.orange;     // Buruk
    if (rating < 4) return Colors.yellow.shade700; // Cukup
    if (rating < 5) return Colors.lightGreen; // Baik
    return Colors.green;                      // Sangat baik
  }

  /// Mendapatkan teks deskriptif berdasarkan nilai rating
  /// [rating]: Nilai kepuasan (1-5)
  String _getRatingText(double rating) {
    if (rating < 2) return 'Sangat Buruk';
    if (rating < 3) return 'Buruk';
    if (rating < 4) return 'Cukup';
    if (rating < 5) return 'Baik';
    return 'Sangat Baik';
  }

  /// Mendapatkan warna berdasarkan jenis feedback
  /// [jenisFeedback]: Jenis feedback (Apresiasi, Saran, Keluhan)
  Color _getFeedbackColor(String jenisFeedback) {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return Colors.green;  // Hijau untuk positif
      case 'Saran':
        return Colors.blue;   // Biru untuk netral
      case 'Keluhan':
        return Colors.red;    // Merah untuk negatif
      default:
        return Colors.grey;   // Abu-abu untuk default
    }
  }

  /// Mendapatkan icon berdasarkan jenis feedback
  /// [jenisFeedback]: Jenis feedback (Apresiasi, Saran, Keluhan)
  IconData _getFeedbackIcon(String jenisFeedback) {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return Icons.thumb_up;    // Thumbs up untuk apresiasi
      case 'Saran':
        return Icons.lightbulb;   // Lampu untuk saran
      case 'Keluhan':
        return Icons.warning;     // Warning untuk keluhan
      default:
        return Icons.feedback;    // Default feedback icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Feedback',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Tombol hapus di app bar
          IconButton(
            onPressed: () => _showDeleteConfirmation(context),
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Feedback',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============ HEADER WITH AVATAR ============ //
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar dengan icon feedback type
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getFeedbackColor(feedback.jenisFeedback),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getFeedbackIcon(feedback.jenisFeedback),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Informasi mahasiswa
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedback.nama,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              feedback.nim,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              feedback.fakultas,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ============ RATING SECTION ============ //
                _buildRatingSection(),

                // ============ FEEDBACK TYPE BADGE ============ //
                _buildFeedbackTypeBadge(),

                const SizedBox(height: 16),

                // ============ FACILITIES CHIPS ============ //
                _buildFacilitiesChips(context),

                // ============ PESAN TAMBAHAN (OPTIONAL) ============ //
                if (feedback.pesanTambahan != null && feedback.pesanTambahan!.isNotEmpty)
                  _buildDetailItem(
                    context,
                    'Pesan Tambahan',
                    feedback.pesanTambahan!,
                    icon: Icons.message,
                  ),

                // ============ STATUS PERSETUJUAN ============ //
                _buildDetailItem(
                  context,
                  'Status Persetujuan',
                  feedback.setujuSyarat ? 'Telah Menyetujui Syarat' : 'Belum Menyetujui',
                  icon: Icons.verified,
                ),

                // ============ TANGGAL SUBMIT ============ //
                _buildDetailItem(
                  context,
                  'Tanggal Submit',
                  '${feedback.createdAt.day}/${feedback.createdAt.month}/${feedback.createdAt.year} ${feedback.createdAt.hour}:${feedback.createdAt.minute.toString().padLeft(2, '0')}', // Format: DD/MM/YYYY HH:MM
                  icon: Icons.calendar_today,
                ),

                const SizedBox(height: 32),

                // ============ ACTION BUTTONS ============ //
                Row(
                  children: [
                    // Tombol kembali
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Kembali',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Tombol hapus
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showDeleteConfirmation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}