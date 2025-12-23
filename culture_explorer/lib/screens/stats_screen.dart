import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/travel_provider.dart';
import '../constants.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);
    final detailedStats = travelProvider.getDetailedStatistics();
    final monthlyStats = travelProvider.getMonthlyStatistics();
    final budgetStats = travelProvider.getBudgetStatistics();

    // 1. DETEKSI APAKAH DARK MODE AKTIF
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Warna Kartu (Putih di Light, Abu Gelap di Dark)
    final cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    // Warna Teks Utama
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return Scaffold(
      // Hapus backgroundColor hardcoded agar ikut tema main.dart
      appBar: AppBar(
        title: Text(
          'Statistics Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER OVERVIEW
            Text(
              'Overview',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor, // Gunakan warna dinamis
              ),
            ),
            SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildOverviewCard(
                  'Total Plans',
                  detailedStats['total'].toString(),
                  Icons.map_outlined,
                  AppColors.primary,
                  cardColor, textColor, // Kirim warna tema
                ),
                _buildOverviewCard(
                  'Countries',
                  detailedStats['uniqueCountries'].toString(),
                  Icons.public,
                  AppColors.info,
                  cardColor, textColor,
                ),
                _buildOverviewCard(
                  'Completion',
                  '${_calculateCompletion(detailedStats)}%',
                  Icons.check_circle_outline,
                  AppColors.success,
                  cardColor, textColor,
                ),
                _buildOverviewCard(
                  'Upcoming',
                  detailedStats['upcoming'].toString(),
                  Icons.upcoming_outlined,
                  AppColors.warning,
                  cardColor, textColor,
                ),
              ],
            ),

            SizedBox(height: 24),

            // 2. STATUS DISTRIBUTION
            Text(
              'Status Distribution',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            _buildCustomStatusChart(detailedStats, cardColor, textColor),

            SizedBox(height: 24),

            // 3. BUDGET OVERVIEW
            Text(
              'Budget Overview',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            _buildBudgetCards(budgetStats, cardColor, textColor),

            SizedBox(height: 24),

            // 4. MONTHLY PLANNING
            Text(
              'Monthly Planning',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            _buildMonthlyStats(monthlyStats, cardColor, textColor),

            SizedBox(height: 24),

            // 5. COUNTRY DISTRIBUTION LIST
            if ((detailedStats['countries'] as List).isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Countries Visited',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildCountryList(detailedStats['countries'] as List<String>),
                ],
              ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS (Diupdate dengan parameter warna) ---

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color, Color cardBg, Color textCol) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg, // Warna Background Dinamis
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Spacer(),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomStatusChart(Map<String, dynamic> stats, Color cardBg, Color textCol) {
    int planned = stats['planned'] ?? 0;
    int visited = stats['visited'] ?? 0;
    int cancelled = stats['cancelled'] ?? 0;
    int total = planned + visited + cancelled;
    
    if (total == 0) total = 1; 

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBarItem('Planned', planned, total, AppColors.info, textCol),
          SizedBox(height: 16),
          _buildBarItem('Visited', visited, total, AppColors.success, textCol),
          SizedBox(height: 16),
          _buildBarItem('Cancelled', cancelled, total, AppColors.error, textCol),
        ],
      ),
    );
  }

  Widget _buildBarItem(String label, int count, int total, Color color, Color textCol) {
    double percentage = count / total;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textCol, // Warna Teks Dinamis
              ),
            ),
            Text(
              '$count (${(percentage * 100).toStringAsFixed(0)}%)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 10,
                  width: constraints.maxWidth * percentage,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetCards(Map<String, double> budgetStats, Color cardBg, Color textCol) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBudgetItem('Planned', budgetStats['planned'] ?? 0, AppColors.primary),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildBudgetItem('Spent', budgetStats['spent'] ?? 0, AppColors.success),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildBudgetItem('Remaining', budgetStats['remaining'] ?? 0, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyStats(Map<String, int> monthlyStats, Color cardBg, Color textCol) {
    return Row(
      children: [
        Expanded(
          child: _buildMonthCard(
            'This Month',
            monthlyStats['thisMonth'].toString(),
            Icons.calendar_today,
            AppColors.primary,
            cardBg, textCol
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildMonthCard(
            'Next Month',
            monthlyStats['nextMonth'].toString(),
            Icons.next_plan,
            AppColors.accent,
            cardBg, textCol
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCard(String label, String count, IconData icon, Color color, Color cardBg, Color textCol) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textCol.withOpacity(0.7), // Sesuaikan dengan background
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryList(List<String> countries) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: countries.map((country) {
        return Chip(
          avatar: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.flag, size: 14, color: AppColors.primary),
          ),
          label: Text(
            country,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        );
      }).toList(),
    );
  }

  String _calculateCompletion(Map<String, dynamic> stats) {
    final total = stats['total'] as int;
    final visited = stats['visited'] as int;
    if (total == 0) return '0';
    return ((visited / total) * 100).toStringAsFixed(0);
  }
}