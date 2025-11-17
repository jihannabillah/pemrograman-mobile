import 'package:flutter/material.dart';
import 'package:flutter_campus_feedback/pages/about_page.dart';
import 'package:flutter_campus_feedback/pages/feedback_form_page.dart';
import 'package:flutter_campus_feedback/pages/feedback_list_page.dart';
import 'package:flutter_campus_feedback/pages/home_page.dart';
import 'package:flutter_campus_feedback/themes/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fungsi main adalah titik masuk utama aplikasi Flutter
void main() async {
  // Memastikan binding Flutter diinisialisasi sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load theme preference dari SharedPreferences sebelum app start
  // Ini memungkinkan aplikasi mengingat pilihan tema pengguna
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('is_dark_mode') ?? false;
  
  // Menjalankan aplikasi dengan tema yang sudah di-load
  runApp(CampusFeedbackApp(isDarkMode: isDarkMode));
}

// Widget utama aplikasi yang merupakan StatefulWidget
// StatefulWidget dipilih karena perlu mengelola state tema yang bisa berubah
class CampusFeedbackApp extends StatefulWidget {
  final bool isDarkMode;
  
  const CampusFeedbackApp({super.key, required this.isDarkMode});

  @override
  State<CampusFeedbackApp> createState() => _CampusFeedbackAppState();
}

class _CampusFeedbackAppState extends State<CampusFeedbackApp> {
  // Variabel state untuk menyimpan status tema (gelap/terang)
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi state tema dari nilai yang diterima melalui constructor
    _isDarkMode = widget.isDarkMode;
  }

  // Method untuk mengganti tema antara gelap dan terang
  void _toggleTheme() async {
    // Update state UI dengan tema baru
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    
    // Menyimpan preferensi tema ke SharedPreferences untuk persistensi
    // Data akan tetap tersimpan meski aplikasi ditutup
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah root widget dari aplikasi Flutter
    return MaterialApp(
      title: 'Campus Feedback - UIN STS Jambi',
      
      // Mendefinisikan tema terang dan gelap dari AppThemes
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      
      // Menentukan tema mana yang aktif berdasarkan state _isDarkMode
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Menyembunyikan banner debug di corner aplikasi
      debugShowCheckedModeBanner: false,
      
      // Route awal yang akan diload saat aplikasi pertama kali dibuka
      initialRoute: '/',
      
      // Mendefinisikan semua routes yang tersedia dalam aplikasi
      routes: {
        '/': (context) => HomePage(
              onThemeChanged: _toggleTheme,    // Mengirim callback untuk toggle tema
              isDarkMode: _isDarkMode,         // Mengirim status tema saat ini
            ),
        '/form': (context) => const FeedbackFormPage(),    // Halaman form feedback
        '/list': (context) => const FeedbackListPage(),    // Halaman daftar feedback
        '/about': (context) => const AboutPage(),          // Halaman tentang aplikasi
      },
      
      // Fallback handler untuk routes yang tidak terdaftar di atas
      // Berguna untuk handle dynamic routes atau navigation dengan arguments
      onGenerateRoute: (settings) {
        // Handler khusus untuk route '/detail' dengan arguments
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => args['page'],  // Mengambil halaman dari arguments
          );
        }
        return null; // Return null jika route tidak dikenali
      },
    );
  }
}