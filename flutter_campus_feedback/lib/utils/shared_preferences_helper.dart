import 'package:shared_preferences/shared_preferences.dart';

/// Helper class untuk mengelola penyimpanan lokal menggunakan SharedPreferences
/// SharedPreferences menyimpan data dalam key-value pairs secara persisten
/// 
/// Pattern Singleton: Menggunakan static methods untuk akses global
/// Lazy Initialization: SharedPreferences di-initialize saat pertama kali digunakan
class SharedPreferencesHelper {
  // Instance SharedPreferences yang disimpan secara static
  // Nullable karena belum di-initialize di awal
  static SharedPreferences? _prefs;

  /// Menginisialisasi SharedPreferences instance
  /// Harus dipanggil sebelum menggunakan methods lainnya
  /// Biasanya dipanggil di main() sebelum runApp()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ FEEDBACK LIST MANAGEMENT ============ //

  /// Menyimpan list feedback ke local storage
  /// [feedbackList] adalah list of JSON strings yang di-convert dari FeedbackItem
  /// 
  /// Return: Future<bool> - true jika berhasil, false jika gagal
  static Future<bool> saveFeedbackList(List<String> feedbackList) async {
    // Validasi instance sudah di-initialize
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    
    // Menyimpan list string ke key 'feedback_list'
    // Data akan tersimpan secara persisten meski app ditutup
    return await _prefs!.setStringList('feedback_list', feedbackList);
  }

  /// Mengambil list feedback dari local storage
  /// 
  /// Return: List<String> - list of JSON strings, atau empty list jika tidak ada data
  static List<String> getFeedbackList() {
    // Validasi instance sudah di-initialize
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    
    // Mengambil data dari key 'feedback_list'
    // Jika tidak ada data, return empty list untuk avoid null errors
    return _prefs!.getStringList('feedback_list') ?? [];
  }

  // ============ THEME PREFERENCE MANAGEMENT ============ //

  /// Menyimpan preferensi tema user (dark/light mode)
  /// [isDarkMode] - true untuk dark mode, false untuk light mode
  /// 
  /// Return: Future<bool> - true jika berhasil, false jika gagal
  static Future<bool> saveThemePreference(bool isDarkMode) async {
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    
    // Menyimpan boolean preference untuk tema
    return await _prefs!.setBool('is_dark_mode', isDarkMode);
  }

  /// Mengambil preferensi tema yang disimpan user
  /// 
  /// Return: bool - true jika dark mode, false jika light mode (default: light mode)
  static bool getThemePreference() {
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    
    // Mengambil preference tema, default false (light mode) jika belum ada setting
    return _prefs!.getBool('is_dark_mode') ?? false;
  }

  // ============ DATA MANAGEMENT ============ //

  /// Menghapus semua data yang disimpan di SharedPreferences
  /// Berguna untuk testing, debugging, atau reset aplikasi
  /// 
  /// Return: Future<bool> - true jika berhasil, false jika gagal
  static Future<bool> clearAllData() async {
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    
    // Menghapus semua key-value pairs dari storage
    return await _prefs!.clear();
  }

  // ============ ADDITIONAL USEFUL METHODS (OPTIONAL) ============ //

  /// Menghapus data spesifik berdasarkan key
  /// Berguna untuk management storage yang lebih granular
  static Future<bool> removeData(String key) async {
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    return await _prefs!.remove(key);
  }

  /// Mengecek apakah data dengan key tertentu exists
  static bool containsKey(String key) {
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    return _prefs!.containsKey(key);
  }

  /// Mendapatkan semua keys yang ada di storage
  /// Berguna untuk debugging purposes
  static Set<String> getAllKeys() {
    assert(_prefs != null, 'SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    return _prefs!.getKeys();
  }
}