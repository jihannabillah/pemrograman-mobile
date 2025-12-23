import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/heritage_provider.dart';
import '../widgets/heritage_card.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HeritageProvider>(context, listen: false);
      provider.loadHeritageData();
      
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_currentPage + 1) % 5;
          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HeritageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark; // Cek Mode Gelap
    
    return Scaffold(
      // HAPUS backgroundColor: AppColors.background agar ikut tema main.dart
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.refreshData(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark), // Kirim status dark mode
                SizedBox(height: 20),
                _buildSearchBar(context),
                SizedBox(height: 20),
                _buildFeaturedCarousel(provider, isDark),
                SizedBox(height: 24),
                _buildCategories(provider, isDark),
                SizedBox(height: 24),
                _buildPopularDestinations(provider, isDark),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Cultural',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              // Ganti warna hardcoded dengan logika tema
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            'Heritage Sites',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Explore UNESCO World Heritage Sites from around the globe',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : AppColors.surface, // Warna Card Dinamis
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => Provider.of<HeritageProvider>(context, listen: false).searchHeritage(value),
          style: TextStyle(color: isDark ? Colors.white : Colors.black), // Warna teks input
          decoration: InputDecoration(
            hintText: 'Search heritage sites...',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(Icons.search, color: AppColors.primary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel(HeritageProvider provider, bool isDark) {
    final popularHeritage = provider.popularHeritage;
    
    if (popularHeritage.isEmpty) {
      return Container(
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: provider.isLoading
              ? CircularProgressIndicator(color: AppColors.primary)
              : Text(
                  'No featured sites available',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Featured Heritage',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: popularHeritage.length.clamp(0, 5),
            padEnds: false,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final heritage = popularHeritage[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: heritage.id);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(heritage.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heritage.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          heritage.country,
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            popularHeritage.length.clamp(0, 5),
            (index) => Container(
              width: 8, height: 8, margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? AppColors.primary : AppColors.textHint.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(HeritageProvider provider, bool isDark) {
    final categories = ['All', 'Cultural', 'Natural', 'Mixed'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Categories',
            style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(category),
                  selected: provider.selectedCategory == category,
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? Color(0xFF1E1E1E) : null,
                  labelStyle: TextStyle(
                    color: provider.selectedCategory == category
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.textPrimary),
                  ),
                  onSelected: (_) {
                    provider.filterByCategory(category);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations(HeritageProvider provider, bool isDark) {
    if (provider.isLoading) {
      return Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator(color: AppColors.primary)));
    }
    
    // ... Error & Empty handling (sama) ...
    // Langsung ke return list
    
    final heritageList = provider.heritageList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Destinations',
                style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Text(
                '${heritageList.length} sites',
                style: TextStyle(
                  color: isDark ? Colors.grey : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: heritageList.length,
          itemBuilder: (context, index) {
            final heritage = heritageList[index];
            return HeritageCard(
              imageUrl: heritage.imageUrl,
              title: heritage.name,
              country: heritage.country,
              category: heritage.category,
              rating: heritage.rating,
              isPopular: heritage.isPopular,
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: heritage.id);
              },
            );
          },
        ),
      ],
    );
  }
}