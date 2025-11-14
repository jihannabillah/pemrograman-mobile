import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import '../models/user_model.dart';
import '../widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  
  const HomePage({super.key, required this.onThemeChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(onThemeChanged: widget.onThemeChanged), // ✅ TAMBAH PARAMETER
      const ProfilePage(),
      SettingsPage(onThemeChanged: widget.onThemeChanged),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            onPressed: () {
              final newTheme = Theme.of(context).brightness == Brightness.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              widget.onThemeChanged(newTheme);
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ HOME CONTENT DENGAN PARAMETER
class HomeContent extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  
  const HomeContent({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Halo, Jihan! 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selamat datang di Flutter Navigation Demo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          CustomCard(
            title: "Lihat Profil Saya",
            subtitle: "Data lengkap profil mahasiswa",
            icon: Icons.person_rounded,
            color: Colors.blue,
            onTap: () {
              final user = User(
                name: "Jihan Nabillah",
                email: "jihannabillah95@gmail.com",
                phone: "+62 812-7971-7946",
                profileImage: "👩‍🎓",
                semester: 5,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          CustomCard(
            title: "Pengaturan Aplikasi",
            subtitle: "Atur preferensi dan tampilan",
            icon: Icons.settings_rounded,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(onThemeChanged: onThemeChanged), // ✅ PASS PARAMETER
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          CustomCard(
            title: "Info Kampus",
            subtitle: "UIN STS Jambi - Sistem Informasi",
            icon: Icons.school_rounded,
            color: Colors.orange,
            onTap: () {
              _showUniversityInfo(context);
            },
          ),
          
          // ✅ THEME QUICK ACTION CARD
          const SizedBox(height: 30),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.light_mode_rounded),
                          label: const Text('Light Theme'),
                          onPressed: () => onThemeChanged(ThemeMode.light),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.dark_mode_rounded),
                          label: const Text('Dark Theme'),
                          onPressed: () => onThemeChanged(ThemeMode.dark),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUniversityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Info Kampus"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "UIN Sultan Thaha Saifuddin Jambi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Program Studi: Sistem Informasi", style: TextStyle(color: Colors.grey[600])),
            Text("Semester: 5", style: TextStyle(color: Colors.grey[600])),
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
}