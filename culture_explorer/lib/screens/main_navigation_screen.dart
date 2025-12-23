import 'package:flutter/material.dart';
import '../constants.dart';
import 'home_screen.dart';
import 'heritage_screen.dart';
import 'wishlist_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    HeritageScreen(),
    WishlistScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Deteksi Dark Mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // 2. Tentukan warna background menu (Putih atau Abu Gelap)
    final navBarColor = isDark ? Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      body: _screens[_selectedIndex],
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBarColor, // Gunakan variabel dinamis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          height: 70,
          elevation: 0,
          backgroundColor: navBarColor, // Gunakan variabel dinamis
          indicatorColor: AppColors.primary.withOpacity(isDark ? 0.4 : 0.2), // Indikator lebih gelap di dark mode
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: Duration(milliseconds: 500),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: isDark ? Colors.white : AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: isDark ? Colors.white : AppColors.primary),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark, color: isDark ? Colors.white : AppColors.primary),
              label: 'Plans',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart, color: isDark ? Colors.white : AppColors.primary),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person, color: isDark ? Colors.white : AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}