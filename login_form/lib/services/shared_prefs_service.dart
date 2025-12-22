import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _keyRememberMe = 'remember_me';
  static const String _keyEmail = 'saved_email';
  static const String _keyPassword = 'saved_password';

  static Future<void> saveLoginCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
      await prefs.setBool(_keyRememberMe, true);

      // Debug: Verify save
      print('✅ Data DISIMPAN ke SharedPreferences');
      print('   Email: $email');
      print('   Password: ${password.length} karakter');
      print('   Remember Me: $rememberMe');
    } else {
      await clearCredentials();
    }
  }

  static Future<Map<String, dynamic>> getSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
      final email = prefs.getString(_keyEmail) ?? '';
      final password = prefs.getString(_keyPassword) ?? '';

      return {
        'rememberMe': rememberMe,
        'email': email,
        'password': password,
      };
    } catch (e) {
      print('❌ Error reading SharedPreferences: $e');
      return {
        'rememberMe': false,
        'email': '',
        'password': '',
      };
    }
  }

  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.setBool(_keyRememberMe, false);
    print('🗑️ Data DIHAPUS dari SharedPreferences');
  }

  // Method untuk debugging
  static Future<void> printAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('=== SHAREDPREFERENCES DATA ===');
    for (var key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    print('==============================');
  }
}