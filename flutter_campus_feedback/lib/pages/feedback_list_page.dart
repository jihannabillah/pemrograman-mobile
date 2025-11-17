import 'package:flutter/material.dart';
import 'package:flutter_campus_feedback/models/feedback_item.dart';
import 'package:flutter_campus_feedback/pages/feedback_detail_page.dart';
import 'package:flutter_campus_feedback/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// Halaman untuk menampilkan daftar feedback yang telah disimpan
/// Mendukung fitur pencarian, filter, dan navigasi ke detail feedback
class FeedbackListPage extends StatefulWidget {
  final FeedbackItem? newFeedback; // Feedback baru yang mungkin ditambahkan dari form

  const FeedbackListPage({super.key, this.newFeedback});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  // Data lists
  final List<FeedbackItem> _feedbackList = [];      // List utama feedback
  final List<FeedbackItem> _filteredList = [];      // List hasil filter/pencarian
  final TextEditingController _searchController = TextEditingController(); // Controller untuk search field
  bool _isLoading = true;                           // Loading state saat initial load

  @override
  void initState() {
    super.initState();
    _loadFeedbackData(); // Load data saat widget diinisialisasi
  }

  /// Memuat data feedback (saat ini menggunakan dummy data)
  /// Di production, data akan di-load dari SharedPreferences/database
  void _loadFeedbackData() async {
    // Simulasi loading data dari network/storage
    await Future.delayed(const Duration(milliseconds: 1000));

    // Data dummy untuk demonstrasi - menggunakan constants dari AppConstants
    final dummyData = [
      FeedbackItem(
        nama: 'Jihan Nabillah',
        nim: '701230022',
        fakultas: AppConstants.faculties[0], // Fakultas Sains dan Teknologi
        fasilitas: [
          AppConstants.facilities[0], // Perpustakaan
          AppConstants.facilities[4], // Wi-Fi Kampus  
          AppConstants.facilities[1], // Laboratorium Komputer
        ],
        nilaiKepuasan: 4.5,
        jenisFeedback: AppConstants.feedbackTypes[0], // Apresiasi
        pesanTambahan: 'Pelayanan perpustakaan sangat memuaskan',
        setujuSyarat: true,
      ),
      FeedbackItem(
        nama: 'Park Sunghoon',
        nim: '801250001',
        fakultas: AppConstants.faculties[1], // Fakultas Kedokteran
        fasilitas: [
          AppConstants.facilities[6], // Kantin
          AppConstants.facilities[5], // Area Parkir
        ],
        nilaiKepuasan: 3.0,
        jenisFeedback: AppConstants.feedbackTypes[1], // Saran
        pesanTambahan: 'Mohon perbaikan fasilitas parkir yang lebih luas',
        setujuSyarat: true,
      ),
      FeedbackItem(
        nama: 'Aski Maya Partiwi', 
        nim: '401239000',
        fakultas: AppConstants.faculties[2], // Fakultas Ekonomi dan Bisnis Islam
        fasilitas: [
          AppConstants.facilities[3], // Ruang Kelas
          AppConstants.facilities[7], // Auditorium
        ],
        nilaiKepuasan: 2.5,
        jenisFeedback: AppConstants.feedbackTypes[2], // Keluhan
        pesanTambahan: 'AC di ruang kelas sering mati',
        setujuSyarat: true,
      ),
    ];

    setState(() {
      _feedbackList.addAll(dummyData);
      
      // Tambahkan feedback baru jika ada (dari form submission)
      if (widget.newFeedback != null) {
        _feedbackList.insert(0, widget.newFeedback!); // Insert di awal list
      }
      
      _filteredList.addAll(_feedbackList); // Initialize filtered list dengan semua data
      _isLoading = false; // Set loading selesai
    });
  }

  /// Method untuk melakukan pencarian feedback
  /// [query]: Kata kunci pencarian
  void _searchFeedback(String query) {
    setState(() {
      _filteredList.clear();
      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua data
        _filteredList.addAll(_feedbackList);
      } else {
        // Filter data berdasarkan kata kunci
        _filteredList.addAll(
          _feedbackList.where((feedback) =>
              feedback.nama.toLowerCase().contains(query.toLowerCase()) ||
              feedback.nim.toLowerCase().contains(query.toLowerCase()) ||
              feedback.fakultas.toLowerCase().contains(query.toLowerCase()) ||
              feedback.jenisFeedback.toLowerCase().contains(query.toLowerCase())),
        );
      }
    });
  }

  /// Method untuk membersihkan pencarian
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredList.clear();
      _filteredList.addAll(_feedbackList); // Reset ke semua data
    });
  }

  /// Navigasi ke halaman detail feedback
  /// [feedback]: Feedback item yang akan ditampilkan detailnya
  void _navigateToDetail(FeedbackItem feedback) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackDetailPage(
          feedback: feedback,
          onDelete: (deletedFeedback) {
            _deleteFeedback(deletedFeedback); // Callback untuk delete
          },
        ),
      ),
    );
  }

  /// Method untuk menghapus feedback dari list
  /// [feedback]: Feedback item yang akan dihapus
  void _deleteFeedback(FeedbackItem feedback) {
    setState(() {
      _feedbackList.remove(feedback);
      _filteredList.remove(feedback);
    });
    
    // Tampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Feedback dari ${feedback.nama} telah dihapus',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============ WIDGET BUILDING METHODS ============ //

  /// Membangun search bar dengan decoration dan clear functionality
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: TextField(
        controller: _searchController,
        onChanged: _searchFeedback, // Real-time search
        decoration: InputDecoration(
          hintText: 'Cari di ${AppConstants.appName}',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch, // Clear search functionality
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  /// Membangun card untuk menampilkan feedback item
  /// [feedback]: Data feedback yang akan ditampilkan
  /// [index]: Index dalam list (untuk key dan animation)
  Widget _buildFeedbackCard(FeedbackItem feedback, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(feedback), // Navigasi ke detail saat di-tap
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getFeedbackColor(feedback.jenisFeedback).withOpacity(0.1),
                _getFeedbackColor(feedback.jenisFeedback).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Avatar/Icon dengan warna berdasarkan jenis feedback
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getFeedbackColor(feedback.jenisFeedback),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getFeedbackIcon(feedback.jenisFeedback),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan nama dan jenis feedback badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          feedback.nama,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        // Badge jenis feedback
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getFeedbackColor(feedback.jenisFeedback).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            feedback.jenisFeedback,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getFeedbackColor(feedback.jenisFeedback),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // NIM mahasiswa
                    Text(
                      'NIM: ${feedback.nim}',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Fakultas dengan ellipsis untuk long text
                    Text(
                      feedback.fakultas,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Rating stars dan nilai
                    Row(
                      children: [
                        _buildRatingStars(feedback.nilaiKepuasan),
                        const SizedBox(width: 8),
                        Text(
                          '${feedback.nilaiKepuasan.toStringAsFixed(1)}/5.0',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: _getRatingColor(feedback.nilaiKepuasan),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Navigation arrow
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membangun widget bintang rating
  /// [rating]: Nilai rating (1-5)
  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  /// Mendapatkan warna berdasarkan jenis feedback
  Color _getFeedbackColor(String jenisFeedback) {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return Colors.green;  // Hijau untuk feedback positif
      case 'Saran':
        return Colors.blue;   // Biru untuk saran/netral
      case 'Keluhan':
        return Colors.red;    // Merah untuk keluhan/negatif
      default:
        return Colors.grey;   // Abu-abu untuk default
    }
  }

  /// Mendapatkan icon berdasarkan jenis feedback
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

  /// Mendapatkan warna berdasarkan nilai rating
  Color _getRatingColor(double rating) {
    if (rating < 2) return Colors.red;        // Merah untuk sangat buruk
    if (rating < 3) return Colors.orange;     // Orange untuk buruk
    if (rating < 4) return Colors.yellow.shade700; // Kuning untuk cukup
    if (rating < 5) return Colors.lightGreen; // Hijau muda untuk baik
    return Colors.green;                      // Hijau untuk sangat baik
  }

  /// Membangun empty state ketika tidak ada feedback
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feedback_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Feedback di ${AppConstants.appName}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.motivationQuote, // Quote motivasi dari constants
            style: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Isi form feedback terlebih dahulu untuk melihat data',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Feedback - ${AppConstants.appSubtitle}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data feedback...'),
                ],
              ),
            )
          : Column(
              children: [
                _buildSearchBar(), // Search bar di atas list
                
                // Conditional rendering berdasarkan state pencarian
                _filteredList.isEmpty && _searchController.text.isNotEmpty
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ditemukan di ${AppConstants.appName}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Coba dengan kata kunci lain',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: _filteredList.isEmpty
                            ? _buildEmptyState() // Empty state ketika tidak ada data
                            : ListView.builder(
                                itemCount: _filteredList.length,
                                itemBuilder: (context, index) {
                                  return _buildFeedbackCard(_filteredList[index], index);
                                },
                              ),
                      ),
              ],
            ),
      // Floating action button untuk navigasi ke form feedback
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}