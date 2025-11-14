import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ✅ STATE UNTUK THEME GLOBAL
  ThemeMode _currentThemeMode = ThemeMode.light;

  // ✅ FUNCTION UNTUK UBAH THEME
  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _currentThemeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _currentThemeMode, // ✅ PAKAI STATE THEME
      home: HomePage(
        onThemeChanged: _changeTheme, // ✅ PASS CALLBACK KE HOMEPAGE
      ),
    );
  }
}