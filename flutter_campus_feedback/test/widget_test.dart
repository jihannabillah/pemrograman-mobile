// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_campus_feedback/main.dart';

/// Test suite untuk aplikasi Campus Feedback
/// Widget testing digunakan untuk menguji UI dan interaksi pengguna
void main() {
  /// Test 1: Memverifikasi bahwa home page load dengan benar
  /// Menguji elemen-elemen UI utama yang seharusnya tampil di home page
  testWidgets('Home page loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // tester.pumpWidget() membangun widget dan melakukan rendering pertama
    await tester.pumpWidget(const CampusFeedbackApp(isDarkMode: false));

    // Verify that home page loads with app name
    // expect() dengan findsOneWidget memastikan widget ditemukan tepat satu kali
    expect(find.text('Campus Feedback'), findsOneWidget);
    expect(find.text('UIN STS Jambi'), findsOneWidget);
    
    // Verify that main navigation buttons are present
    // Menguji bahwa semua tombol navigasi utama ada di home page
    expect(find.text('Formulir Feedback'), findsOneWidget);
    expect(find.text('Daftar Feedback'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });

  /// Test 2: Menguji navigasi dari home page ke form page
  /// Simulasi user men-tap tombol dan memverifikasi navigasi berhasil
  testWidgets('Navigation to form page', (WidgetTester tester) async {
    // Build aplikasi
    await tester.pumpWidget(const CampusFeedbackApp(isDarkMode: false));

    // Tap the form button and trigger a frame.
    // tester.tap() mensimulasikan tap gesture user pada widget dengan text tertentu
    await tester.tap(find.text('Formulir Feedback'));
    
    // tester.pumpAndSettle() menunggu semua animasi dan frame selesai
    // Penting untuk navigasi karena ada transition animations
    await tester.pumpAndSettle();

    // Verify that we navigated to form page
    // Memastikan kita sudah berada di halaman form dengan mengidentifikasi elemen khasnya
    expect(find.text('Form Feedback Mahasiswa'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
  });

  /// Test 3: Menguji navigasi dari home page ke about page
  /// Verifikasi konten about page tampil dengan benar
  testWidgets('Navigation to about page', (WidgetTester tester) async {
    // Build aplikasi
    await tester.pumpWidget(const CampusFeedbackApp(isDarkMode: false));

    // Tap the about button and trigger a frame.
    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();

    // Verify that we navigated to about page
    // Menguji berbagai teks yang seharusnya ada di about page
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
    expect(find.text('Dosen Pengampu'), findsOneWidget);
    expect(find.text('Ahmad Nasukha, S.Hum., M.S.I'), findsOneWidget);
  });
}