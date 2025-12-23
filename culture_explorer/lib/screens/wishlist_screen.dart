import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/travel_provider.dart';
import '../widgets/travel_card.dart';
import '../constants.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TravelProvider>(context, listen: false).loadTravelPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);
    final stats = travelProvider.getStatistics();
    
    // 1. Deteksi Dark Mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final subTextColor = isDark ? Colors.white70 : AppColors.textSecondary;

    // Filter Logic
    List<dynamic> filteredPlans = travelProvider.travelPlans;
    if (_selectedFilter != 'All') {
      filteredPlans = travelProvider.getPlansByStatus(_selectedFilter.toLowerCase());
    }

    return Scaffold(
      // Hapus backgroundColor agar mengikuti tema
      appBar: AppBar(
        title: Text(
          'My Travel Plans',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: travelProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Statistics Cards
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        count: stats['total'] ?? 0,
                        label: 'Total',
                        color: AppColors.primary,
                        isDark: isDark,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        count: stats['planned'] ?? 0,
                        label: 'Planned',
                        color: AppColors.info,
                        isDark: isDark,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        count: stats['visited'] ?? 0,
                        label: 'Visited',
                        color: AppColors.success,
                        isDark: isDark,
                      ),
                      SizedBox(width: 12),
                      _buildStatCard(
                        count: stats['cancelled'] ?? 0,
                        label: 'Cancel',
                        color: AppColors.error,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                // Filter Chips
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', 'Planned', 'Visited', 'Cancelled'].map((filter) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          selectedColor: AppColors.primary,
                          backgroundColor: isDark ? Color(0xFF1E1E1E) : null,
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter 
                                ? Colors.white 
                                : textColor,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 8),

                // Travel Plans List
                Expanded(
                  child: filteredPlans.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.travel_explore, size: 60, color: subTextColor),
                              SizedBox(height: 16),
                              Text(
                                'No Travel Plans Yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add your first travel plan from heritage details',
                                style: TextStyle(color: subTextColor),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              
                              // --- BAGIAN YANG DIPERBAIKI ---
                              ElevatedButton(
                                onPressed: () {
                                  // Navigasi aman: Kembali ke Home Screen utama
                                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Explore Heritage'),
                              ),
                              // ------------------------------
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredPlans.length,
                          itemBuilder: (context, index) {
                            final plan = filteredPlans[index];
                            return TravelCard(
                              imageUrl: plan.heritageImage,
                              title: plan.heritageName,
                              country: plan.heritageCountry,
                              date: plan.planDate,
                              status: plan.status,
                              notes: plan.notes,
                              budget: plan.budget,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/add_edit',
                                  arguments: {
                                    'plan': plan,
                                    'mode': 'edit',
                                  },
                                );
                              },
                              onDelete: () {
                                _showDeleteDialog(context, plan);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_edit',
            arguments: {'mode': 'add'},
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildStatCard({required int count, required String label, required Color color, required bool isDark}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8), // Padding sedikit dikecilkan agar muat
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10, // Font diperkecil sedikit
                color: isDark ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Travel Plan'),
        content: Text('Are you sure you want to delete "${plan.heritageName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await Provider.of<TravelProvider>(context, listen: false)
                  .deleteTravelPlan(plan.id!);
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Travel plan deleted'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}