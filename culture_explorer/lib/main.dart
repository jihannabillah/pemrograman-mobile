import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './constants.dart';
import './providers/heritage_provider.dart';
import './providers/travel_provider.dart';
import './providers/theme_provider.dart';

import './screens/main_navigation_screen.dart'; 
import './screens/heritage_screen.dart';
import './screens/detail_screen.dart';
import './screens/wishlist_screen.dart';
import './screens/add_edit_screen.dart';
import './screens/stats_screen.dart';
import './screens/profile_screen.dart';
import './screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HeritageProvider()),
        ChangeNotifierProvider(create: (_) => TravelProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()), 
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CultureExplorer',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            
            // === TEMA TERANG (LIGHT) ===
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: AppColors.background, // Krem
              cardColor: AppColors.surface, // Putih
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              // Text Theme Default Hitam/Gelap
              textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
              useMaterial3: true,
            ),

            // === TEMA GELAP (DARK) ===
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AppColors.primary,
              scaffoldBackgroundColor: Color(0xFF121212), // Hitam Pekat
              cardColor: Color(0xFF1E1E1E), // Abu Gelap
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF1F1F1F),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              // Text Theme Default Putih (PENTING!)
              textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
              useMaterial3: true,
            ),
            
            home: const MainNavigationScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => const MainNavigationScreen(),
              '/heritage': (context) => HeritageScreen(),
              '/detail': (context) => DetailScreen(),
              '/wishlist': (context) => WishlistScreen(),
              '/add_edit': (context) => AddEditScreen(),
              '/stats': (context) => StatsScreen(),
              '/profile': (context) => ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}