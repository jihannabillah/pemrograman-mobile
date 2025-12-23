import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Wajib ada untuk Logout
import '../constants.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengakses ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jihan Nabillah',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mahasiswa Sistem Informasi',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'UIN STS Jambi',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // App Settings Section
          _buildSectionHeader(context, 'App Settings'),
          
          _buildSettingTile(
            context,
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Dark Mode',
            subtitle: isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
            trailing: Switch(
              value: isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          
          _buildSettingTile(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Enable push notifications',
            trailing: Switch(
              value: true, 
              activeColor: AppColors.primary,
              onChanged: (value) {},
            ),
          ),
          
          SizedBox(height: 40),
          
          // --- LOGOUT BUTTON (Sekarang berada di dalam children ListView) ---
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: Icon(Icons.logout),
              label: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Fungsi Dialog Logout yang dipisah agar kode bersih
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false); //
              
              if (!context.mounted) return;
              Navigator.pop(context); 
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); //
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Berhasil keluar'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Ya, Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDestructive ? AppColors.error : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}