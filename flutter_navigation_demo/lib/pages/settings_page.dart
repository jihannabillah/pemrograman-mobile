import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  
  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            "Tampilan",
            [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: Colors.deepPurple,
                  ),
                ),
                title: const Text("Theme Mode"),
                subtitle: Text(_isDarkMode ? "Mode Gelap" : "Mode Terang"),
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    final newTheme = value ? ThemeMode.dark : ThemeMode.light;
                    widget.onThemeChanged(newTheme);
                    _showThemeChangeSuccess(context, value);
                  },
                  activeColor: Colors.deepPurple,
                ),
              ),
              _buildSettingsItem(
                Icons.language_rounded,
                "Bahasa",
                "Indonesia",
                Icons.arrow_forward_ios_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            "Akun",
            [
              _buildSettingsItem(
                Icons.security_rounded,
                "Privasi & Keamanan",
                "Kelola pengaturan privasi",
                Icons.arrow_forward_ios_rounded,
              ),
              _buildSettingsItem(
                Icons.notifications_rounded,
                "Notifikasi",
                "Aktif",
                Icons.arrow_forward_ios_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            "Tentang",
            [
              _buildSettingsItem(
                Icons.info_rounded,
                "Versi Aplikasi",
                "1.0.0",
                null,
              ),
              _buildSettingsItem(
                Icons.school_rounded,
                "Tentang Developer",
                "Jihan Nabillah - SI Semester 5",
                Icons.arrow_forward_ios_rounded,
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Theme Preview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.grey[800] : Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.palette_rounded,
                          color: _isDarkMode ? Colors.amber : Colors.deepPurple,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _isDarkMode 
                              ? "Sekarang menggunakan Dark Theme! 🌙" 
                              : "Sekarang menggunakan Light Theme! ☀️",
                            style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ TAMBAHKAN METHOD YANG MISSING
  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData leadingIcon,
    String title,
    String subtitle,
    IconData? trailingIcon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(leadingIcon, color: Colors.deepPurple),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailingIcon != null
          ? Icon(trailingIcon, size: 16)
          : null,
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tentang Developer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jihan Nabillah",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Mahasiswa Sistem Informasi", style: TextStyle(color: Colors.grey[600])),
            Text("UIN STS Jambi - Semester 5", style: TextStyle(color: Colors.grey[600])),
            Text("Mata Kuliah: Pemrograman Mobile", style: TextStyle(color: Colors.grey[600])),
            Text("Dosen: Ahmad Nasukha, S.Hum., M.S.I", style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showThemeChangeSuccess(BuildContext context, bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDarkMode 
            ? "✅ Theme berubah ke Dark Mode" 
            : "✅ Theme berubah ke Light Mode",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}