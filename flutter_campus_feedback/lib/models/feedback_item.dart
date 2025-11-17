import 'package:uuid/uuid.dart';

/// Kelas model yang merepresentasikan satu entri feedback dari mahasiswa
/// Model ini digunakan untuk menyimpan data feedback dan konversi ke/dari format penyimpanan
class FeedbackItem {
  // Properti final untuk immutability - sekali dibuat tidak bisa diubah
  final String id;                    // ID unik untuk setiap feedback
  final String nama;                  // Nama mahasiswa
  final String nim;                   // NIM mahasiswa
  final String fakultas;              // Fakultas mahasiswa
  final List<String> fasilitas;       // Daftar fasilitas yang dinilai
  final double nilaiKepuasan;         // Nilai kepuasan (1-5)
  final String jenisFeedback;         // Jenis: Apresiasi, Saran, atau Keluhan
  final String? pesanTambahan;        // Pesan tambahan (opsional)
  final bool setujuSyarat;            // Persetujuan syarat dan ketentuan
  final DateTime createdAt;           // Waktu feedback dibuat

  /// Constructor untuk membuat instance FeedbackItem
  /// Parameter opsional [id] dan [createdAt] untuk kasus edit/load dari storage
  FeedbackItem({
    String? id,
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitas,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    this.pesanTambahan,
    required this.setujuSyarat,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),  // Generate UUID jika tidak disediakan
        createdAt = createdAt ?? DateTime.now(); // Gunakan waktu sekarang jika tidak disediakan

  /// Method untuk konversi object ke Map<String, dynamic>
  /// Digunakan untuk penyimpanan di SharedPreferences atau database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'fakultas': fakultas,
      'fasilitas': fasilitas,                    // List<String> bisa langsung disimpan
      'nilaiKepuasan': nilaiKepuasan,
      'jenisFeedback': jenisFeedback,
      'pesanTambahan': pesanTambahan,
      'setujuSyarat': setujuSyarat,
      'createdAt': createdAt.toIso8601String(),  // Convert DateTime ke String
    };
  }

  /// Factory method untuk membuat object FeedbackItem dari Map
  /// Digunakan ketika load data dari SharedPreferences atau database
  factory FeedbackItem.fromMap(Map<String, dynamic> map) {
    return FeedbackItem(
      id: map['id'],
      nama: map['nama'],
      nim: map['nim'],
      fakultas: map['fakultas'],
      fasilitas: List<String>.from(map['fasilitas']), // Convert kembali ke List<String>
      nilaiKepuasan: map['nilaiKepuasan']?.toDouble() ?? 0.0, // Handle null safety
      jenisFeedback: map['jenisFeedback'],
      pesanTambahan: map['pesanTambahan'],
      setujuSyarat: map['setujuSyarat'] ?? false,     // Default false jika null
      createdAt: DateTime.parse(map['createdAt']),    // Parse String ke DateTime
    );
  }

  /// Method untuk membuat salinan object dengan beberapa properti yang di-update
  /// Pattern ini disebut "copyWith" dan umum dalam pemrograman Dart/Flutter
  /// Berguna untuk update data tanpa mengubah object asli (immutable)
  FeedbackItem copyWith({
    String? nama,
    String? nim,
    String? fakultas,
    List<String>? fasilitas,
    double? nilaiKepuasan,
    String? jenisFeedback,
    String? pesanTambahan,
    bool? setujuSyarat,
  }) {
    return FeedbackItem(
      id: id,                          // ID tetap sama karena ini update
      nama: nama ?? this.nama,         // Gunakan nilai baru atau tetap yang lama
      nim: nim ?? this.nim,
      fakultas: fakultas ?? this.fakultas,
      fasilitas: fasilitas ?? this.fasilitas,
      nilaiKepuasan: nilaiKepuasan ?? this.nilaiKepuasan,
      jenisFeedback: jenisFeedback ?? this.jenisFeedback,
      pesanTambahan: pesanTambahan ?? this.pesanTambahan,
      setujuSyarat: setujuSyarat ?? this.setujuSyarat,
      createdAt: createdAt,            // CreatedAt tidak bisa diubah
    );
  }

  /// Getter untuk mendapatkan icon berdasarkan jenis feedback
  /// Mengembalikan emoji yang sesuai dengan jenis feedback
  String get feedbackIcon {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return '👍';  // Thumbs up untuk apresiasi
      case 'Saran':
        return '💡';  // Lampu ide untuk saran
      case 'Keluhan':
        return '😞';  // Wajah sedih untuk keluhan
      default:
        return '📝';  // Default notes icon
    }
  }

  /// Getter untuk mendapatkan color code berdasarkan jenis feedback
  /// Mengembalikan string color code dalam format ARGB
  String get feedbackColor {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return '0xFF4CAF50'; // Green - positif
      case 'Saran':
        return '0xFF2196F3'; // Blue - netral/informatif
      case 'Keluhan':
        return '0xFFF44336'; // Red - negatif/perhatian
      default:
        return '0xFF9E9E9E'; // Grey - default
    }
  }

  /// Override method toString untuk representasi string yang meaningful
  /// Berguna untuk debugging dan logging
  @override
  String toString() {
    return 'FeedbackItem(id: $id, nama: $nama, nim: $nim, fakultas: $fakultas, nilai: $nilaiKepuasan)';
  }

  /// Override operator equality untuk membandingkan dua FeedbackItem
  /// Dua FeedbackItem dianggap sama jika ID-nya sama
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackItem && other.id == id;
  }

  /// Override hashCode konsisten dengan operator equality
  /// Jika dua object sama (==), hashCode-nya harus sama
  @override
  int get hashCode => id.hashCode;
}