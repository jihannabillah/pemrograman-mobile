import 'package:flutter/material.dart';
import 'package:flutter_campus_feedback/models/feedback_item.dart';
import 'package:flutter_campus_feedback/pages/feedback_list_page.dart';
import 'package:flutter_campus_feedback/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

/// Halaman form untuk mengisi feedback mahasiswa
/// Menggunakan StatefulWidget karena form memiliki state yang berubah-ubah
class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  // GlobalKey untuk mengakses dan memvalidasi form state
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk text fields (mengelola input text)
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  
  // State variables untuk menyimpan nilai form
  String _selectedFakultas = '';                    // Fakultas yang dipilih
  final List<String> _selectedFasilitas = [];       // List fasilitas yang dipilih
  double _nilaiKepuasan = 3.0;                     // Nilai slider (default: 3.0)
  String _selectedJenisFeedback = '';               // Jenis feedback yang dipilih
  bool _setujuSyarat = false;                       // Status persetujuan syarat
  bool _isLoading = false;                          // Loading state saat submit

  // ============ VALIDATION METHODS ============ //

  /// Validator untuk field yang wajib diisi
  /// [value]: Nilai yang akan divalidasi
  /// Return: String error message jika invalid, null jika valid
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini wajib diisi';
    }
    return null;
  }

  /// Validator khusus untuk field NIM
  /// [value]: NIM yang akan divalidasi
  /// Return: String error message jika invalid, null jika valid
  String? _validateNIM(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'NIM harus berupa angka';
    }
    if (value.length < 8) {
      return 'NIM minimal 8 digit';
    }
    return null;
  }

  // ============ FORM SUBMISSION ============ //

  /// Method untuk menangani submit form
  /// Validasi semua field, simpan data, dan navigasi ke halaman list
  void _submitForm() async {
    // Validasi form terlebih dahulu menggunakan form key
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Harap perbaiki error pada form terlebih dahulu', isError: true);
      return;
    }

    // Validasi manual untuk field yang tidak menggunakan TextFormField
    if (_selectedFakultas.isEmpty) {
      _showSnackBar('Harap pilih fakultas', isError: true);
      return;
    }

    if (_selectedJenisFeedback.isEmpty) {
      _showSnackBar('Harap pilih jenis feedback', isError: true);
      return;
    }

    if (_selectedFasilitas.isEmpty) {
      _showSnackBar('Harap pilih minimal satu fasilitas', isError: true);
      return;
    }

    if (!_setujuSyarat) {
      _showTermsDialog(); // Tampilkan dialog jika belum setuju
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    // Simulasi loading process (bisa dihapus di production)
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Create FeedbackItem object dari data form
      final feedbackItem = FeedbackItem(
        nama: _namaController.text.trim(),
        nim: _nimController.text.trim(),
        fakultas: _selectedFakultas,
        fasilitas: List.from(_selectedFasilitas), // Copy list untuk immutability
        nilaiKepuasan: _nilaiKepuasan,
        jenisFeedback: _selectedJenisFeedback,
        pesanTambahan: _pesanController.text.trim().isEmpty ? 
            null : _pesanController.text.trim(), // Null jika kosong
        setujuSyarat: _setujuSyarat,
      );

      // Simpan ke SharedPreferences
      await _saveFeedbackToStorage(feedbackItem);

      // Reset loading state
      setState(() {
        _isLoading = false;
      });

      // Navigate ke list page dengan data baru (replace current route)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackListPage(newFeedback: feedbackItem),
        ),
      );

      // Tampilkan success message
      _showSuccessSnackBar();

    } catch (e) {
      // Handle error saat menyimpan
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Terjadi error saat menyimpan data: $e', isError: true);
    }
  }

  /// Menyimpan feedback ke SharedPreferences
  /// [feedbackItem]: Object feedback yang akan disimpan
  Future<void> _saveFeedbackToStorage(FeedbackItem feedbackItem) async {
    try {
      // Get instance SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Get existing feedback list atau empty list jika belum ada
      final List<String> existingFeedback = prefs.getStringList('feedback_list') ?? [];
      
      // Convert feedback ke JSON string menggunakan toMap() method
      final String feedbackJson = _convertToJson(feedbackItem.toMap());
      existingFeedback.add(feedbackJson);
      
      // Save updated list back ke SharedPreferences
      await prefs.setStringList('feedback_list', existingFeedback);
    } catch (e) {
      throw Exception('Gagal menyimpan ke storage: $e');
    }
  }

  /// Simple JSON conversion (bisa diganti dengan jsonEncode di production)
  /// [map]: Map data yang akan di-convert
  String _convertToJson(Map<String, dynamic> map) {
    return map.toString(); // Simple implementation untuk demo
  }

  // ============ UI FEEDBACK METHODS ============ //

  /// Menampilkan SnackBar dengan pesan tertentu
  /// [message]: Pesan yang akan ditampilkan
  /// [isError]: true jika pesan error (warna merah), false jika info (warna biru)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  /// Menampilkan SnackBar sukses setelah submit
  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Feedback berhasil disimpan!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Menampilkan dialog persetujuan syarat dan ketentuan
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.amber),
            const SizedBox(width: 8),
            Text(
              'Persetujuan Diperlukan',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anda harus menyetujui syarat dan ketentuan sebelum mengirim feedback.',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            Text(
              'Dengan menyetujui, Anda menyatakan bahwa data yang diisi adalah benar dan dapat dipertanggungjawabkan.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
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
          // Tombol setuju
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              setState(() {
                _setujuSyarat = true; // Set status persetujuan
              });
              _showSnackBar('Syarat dan ketentuan telah disetujui');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Setuju & Lanjutkan',
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

  /// Menampilkan dialog konfirmasi reset form
  void _resetForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Form?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Semua data yang sudah diisi akan dihapus. Apakah Anda yakin?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              _formKey.currentState?.reset(); // Reset form state
              setState(() {
                // Clear semua controllers dan reset state variables
                _namaController.clear();
                _nimController.clear();
                _pesanController.clear();
                _selectedFakultas = '';
                _selectedFasilitas.clear();
                _nilaiKepuasan = 3.0;
                _selectedJenisFeedback = '';
                _setujuSyarat = false;
              });
              _showSnackBar('Form telah direset');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Reset',
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

  // ============ EVENT HANDLERS ============ //

  /// Handler untuk perubahan nilai fakultas dropdown
  void _onFakultasChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedFakultas = newValue;
      });
    }
  }

  /// Handler untuk perubahan checkbox fasilitas
  /// [facility]: Fasilitas yang di-check/uncheck
  /// [value]: Nilai checkbox (true/false)
  void _onFacilityChanged(String facility, bool? value) {
    setState(() {
      if (value == true) {
        _selectedFasilitas.add(facility);
      } else {
        _selectedFasilitas.remove(facility);
      }
    });
  }

  // ============ HELPER METHODS FOR RATING ============ //

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

  // ============ HELPER METHODS FOR FEEDBACK TYPE ============ //

  /// Mendapatkan icon berdasarkan jenis feedback
  /// [type]: Jenis feedback (Apresiasi, Saran, Keluhan)
  IconData _getFeedbackIcon(String type) {
    switch (type) {
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

  /// Mendapatkan warna berdasarkan jenis feedback
  /// [type]: Jenis feedback (Apresiasi, Saran, Keluhan)
  Color _getFeedbackColor(String type) {
    switch (type) {
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

  // ============ WIDGET BUILDING METHODS ============ //

  /// Membangun header section dengan icon dan title
  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun text field dengan konfigurasi tertentu
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  /// Membangun dropdown field untuk memilih fakultas
  Widget _buildDropdownField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedFakultas.isEmpty ? null : _selectedFakultas,
        decoration: InputDecoration(
          labelText: 'Fakultas',
          hintText: 'Pilih fakultas Anda',
          prefixIcon: const Icon(Icons.school),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
        items: AppConstants.faculties.map((String faculty) {
          return DropdownMenuItem<String>(
            value: faculty,
            child: Text(
              faculty,
              style: GoogleFonts.poppins(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList(),
        onChanged: _onFakultasChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harap pilih fakultas';
          }
          return null;
        },
      ),
    );
  }

  /// Membangun checkbox list untuk fasilitas
  Widget _buildFacilitiesCheckbox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: AppConstants.facilities.map((facility) {
          return CheckboxListTile(
            title: Text(
              facility,
              style: GoogleFonts.poppins(),
            ),
            value: _selectedFasilitas.contains(facility),
            onChanged: (bool? value) => _onFacilityChanged(facility, value),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              Icons.architecture,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Membangun slider untuk tingkat kepuasan
  Widget _buildSatisfactionSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          // Header dengan nilai dan rating text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nilai: ${_nilaiKepuasan.toStringAsFixed(1)}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRatingColor(_nilaiKepuasan),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getRatingText(_nilaiKepuasan),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Slider component
          Slider(
            value: _nilaiKepuasan,
            min: 1,
            max: 5,
            divisions: 4, // 1, 2, 3, 4, 5
            label: _nilaiKepuasan.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _nilaiKepuasan = value;
              });
            },
            activeColor: _getRatingColor(_nilaiKepuasan),
            inactiveColor: Colors.grey.shade300,
          ),
          const SizedBox(height: 8),
          // Rating scale labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1', '2', '3', '4', '5'].map((text) {
              return Text(
                text,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Membangun radio buttons untuk jenis feedback
  Widget _buildFeedbackTypeRadio() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: AppConstants.feedbackTypes.map((type) {
          return RadioListTile<String>(
            title: Row(
              children: [
                Icon(
                  _getFeedbackIcon(type),
                  color: _getFeedbackColor(type),
                ),
                const SizedBox(width: 12),
                Text(
                  type,
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            value: type,
            groupValue: _selectedJenisFeedback,
            onChanged: (String? value) {
              setState(() {
                _selectedJenisFeedback = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  /// Membangun text field untuk pesan tambahan
  Widget _buildMessageField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _pesanController,
        maxLines: 4, // Multi-line input
        decoration: InputDecoration(
          labelText: 'Pesan Tambahan (Opsional)',
          hintText: 'Tuliskan pesan tambahan, saran, atau kritik...',
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  /// Membangun switch untuk persetujuan syarat
  Widget _buildTermsSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: _setujuSyarat ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Saya menyetujui syarat dan ketentuan pengisian feedback',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: _setujuSyarat,
            onChanged: (bool value) {
              setState(() {
                _setujuSyarat = value;
              });
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  /// Membangun submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, size: 20),
            const SizedBox(width: 8),
            Text(
              'Simpan Feedback',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ MAIN BUILD METHODS ============ //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Form Feedback Mahasiswa',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _resetForm,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState() // Tampilkan loading indicator
          : _buildFormContent(), // Tampilkan form content
    );
  }

  /// Membangun loading state saat submit form
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Menyimpan Feedback...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Harap tunggu sebentar',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun konten form utama
  Widget _buildFormContent() {
    return Container(
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
      child: Form(
        key: _formKey, // Kunci untuk form validation
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataMahasiswaSection(),
                const SizedBox(height: 24),
                _buildFasilitasSection(),
                const SizedBox(height: 24),
                _buildKepuasanSection(),
                const SizedBox(height: 24),
                _buildJenisFeedbackSection(),
                const SizedBox(height: 24),
                _buildPesanTambahanSection(),
                const SizedBox(height: 24),
                _buildTermsSection(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ SECTION BUILDERS ============ //

  Widget _buildDataMahasiswaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.person,
          title: 'Data Mahasiswa',
        ),
        _buildTextField(
          controller: _namaController,
          label: 'Nama Lengkap',
          hintText: 'Masukkan nama lengkap',
          validator: _validateRequired,
          icon: Icons.person,
        ),
        _buildTextField(
          controller: _nimController,
          label: 'NIM',
          hintText: 'Masukkan NIM (hanya angka)',
          validator: _validateNIM,
          keyboardType: TextInputType.number,
          icon: Icons.badge,
        ),
        _buildDropdownField(),
      ],
    );
  }

  Widget _buildFasilitasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.architecture,
          title: 'Fasilitas yang Dinilai',
        ),
        _buildFacilitiesCheckbox(),
      ],
    );
  }

  Widget _buildKepuasanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.star,
          title: 'Tingkat Kepuasan',
        ),
        _buildSatisfactionSlider(),
      ],
    );
  }

  Widget _buildJenisFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.feedback,
          title: 'Jenis Feedback',
        ),
        _buildFeedbackTypeRadio(),
      ],
    );
  }

  Widget _buildPesanTambahanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.message,
          title: 'Pesan Tambahan',
        ),
        _buildMessageField(),
      ],
    );
  }

  Widget _buildTermsSection() {
    return _buildTermsSwitch();
  }

  // ============ CLEANUP ============ //

  @override
  void dispose() {
    // Dispose semua controllers untuk mencegah memory leaks
    _namaController.dispose();
    _nimController.dispose();
    _pesanController.dispose();
    super.dispose();
  }
}