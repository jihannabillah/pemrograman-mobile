/// Kelas konstanta aplikasi yang menyimpan semua nilai tetap (constants)
/// Digunakan untuk mengelola string, list, dan konfigurasi yang digunakan di seluruh aplikasi
/// Pattern ini disebut "Constants Class" dan membantu maintainability code
class AppConstants {
  // Informasi dasar aplikasi
  static const String appName = 'Campus Feedback';      // Nama aplikasi
  static const String appSubtitle = 'UIN STS Jambi';    // Subtitle/nama institusi
  static const String appVersion = '1.0.0';             // Versi aplikasi
  
  // Daftar fakultas untuk Dropdown menu
  // Digunakan di form feedback untuk memilih fakultas mahasiswa
  static const List<String> faculties = [
    'Fakultas Sains dan Teknologi',
    'Fakultas Adab dan Humaniora', 
    'Fakultas Ekonomi dan Bisnis Islam',
    'Fakultas Syariah',
    'Fakultas Tarbiyah dan Keguruan',
    'Fakultas Dakwah',
    'Fakultas Usluhuddin dan Studi Agama',
    'Fakultas Kedokteran',
  ];

  // Jenis-jenis feedback yang dapat dipilih user
  // Digunakan untuk Radio buttons di form
  static const List<String> feedbackTypes = [
    'Apresiasi',  // Feedback positif/pujian
    'Saran',      // Feedback konstruktif  
    'Keluhan',    // Feedback negatif/masalah
  ];

  // Daftar fasilitas kampus yang dapat dinilai user
  // Digunakan untuk Checkbox group di form feedback
  static const List<String> facilities = [
    'Perpustakaan',
    'Laboratorium Komputer',
    'Ruang Kelas', 
    'Wi-Fi Kampus',
    'Area Parkir',
    'Kantin',
    'Auditorium',
    'Fasilitas Olahraga',
    'Mushola',
    'Administrasi Akademik',
    'Layanan Kemahasiswaan',
  ];

  // Quote motivasi untuk ditampilkan di aplikasi
  // Bisa digunakan di splash screen, about page, atau home page
  static const String motivationQuote = 
      "Coding adalah seni memecahkan masalah dengan logika dan kreativitas.";

  // Key untuk penyimpanan lokal (SharedPreferences)
  // Digunakan sebagai identifier untuk menyimpan dan mengambil data
  static const String feedbackListKey = 'feedback_list';  // Key untuk menyimpan list feedback
  static const String isDarkModeKey = 'is_dark_mode';     // Key untuk menyimpan preferensi tema
}

/// Kelas untuk mengelola path asset aplikasi (images, icons, dll)
/// Memusatkan semua referensi asset di satu tempat untuk memudahkan maintenance
class AppAssets {
  // Logo dan images aplikasi
  static const String flutterLogo = 'assets/images/flutter_logo.png';      // Logo Flutter framework
  static const String uinLogo = 'assets/images/uin_logo.png';              // Logo UIN STS Jambi
  static const String backgroundLight = 'assets/images/bg_light.jpg';      // Background untuk light mode
  static const String backgroundDark = 'assets/images/bg_dark.jpg';        // Background untuk dark mode
  
  // CATATAN: Pastikan file-file tersebut benar-benar ada di folder assets/images/
  // dan sudah dikonfigurasi di file pubspec.yaml
}

/// Kelas untuk mengelola named routes aplikasi
/// Memusatkan semua route names untuk menghindari hardcoded strings di seluruh aplikasi
class AppRoutes {
  static const String home = '/';        // Route untuk home page
  static const String form = '/form';    // Route untuk feedback form page  
  static const String list = '/list';    // Route untuk feedback list page
  static const String detail = '/detail'; // Route untuk feedback detail page (dynamic route)
  static const String about = '/about';  // Route untuk about page
}