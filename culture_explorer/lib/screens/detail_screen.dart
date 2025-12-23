import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../providers/heritage_provider.dart';
import '../providers/travel_provider.dart';
import '../models/heritage.dart';
import '../models/travel_plan.dart';
import '../constants.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isAddingToWishlist = false;

  // --- PERBAIKAN FUNGSI LAUNCHER ---
  Future<void> _openMap(String location, String name) async {
    // Gunakan skema URL Google Maps yang benar agar bisa dibuka di browser atau aplikasi
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('$name $location')}";
    final Uri url = Uri.parse(googleMapsUrl);

    try {
      // Pada Android API 30+, canLaunchUrl akan selalu false jika belum setting AndroidManifest
      // Kita langsung coba launch saja dengan mode externalApplication
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open map: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _addToWishlist(Heritage heritage, BuildContext context) async {
    setState(() => _isAddingToWishlist = true);
    final travelProvider = Provider.of<TravelProvider>(context, listen: false);
    
    final plan = TravelPlan(
      heritageName: heritage.name,
      heritageCountry: heritage.country,
      heritageImage: heritage.imageUrl,
      planDate: DateTime.now().add(Duration(days: 30)),
      notes: 'Plan to visit ${heritage.name} in ${heritage.country}',
      status: 'planned',
      budget: 1000,
    );
    
    final success = await travelProvider.addTravelPlan(plan);
    setState(() => _isAddingToWishlist = false);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to travel plans!'), backgroundColor: AppColors.success),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add. Make sure you use Android Emulator (not Web/Chrome)'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null) return Scaffold(body: Center(child: Text("No ID provided")));
    
    final heritageId = args as int;
    final heritageProvider = Provider.of<HeritageProvider>(context);
    final heritage = heritageProvider.getHeritageById(heritageId);

    if (heritage == null) {
      return Scaffold(appBar: AppBar(backgroundColor: AppColors.primary), body: Center(child: Text('Heritage not found')));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                heritage.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: AppColors.card, child: Icon(Icons.image_not_supported)),
              ),
              title: Text(heritage.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.map, color: Colors.white),
                onPressed: () => _openMap(heritage.location, heritage.name), // Panggil fungsi baru
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(heritage.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Poppins')),
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () => _openMap(heritage.location, heritage.name),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text(heritage.location, style: TextStyle(color: AppColors.textSecondary, decoration: TextDecoration.underline)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildRatingBadge(heritage.rating),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      _buildInfoChip(Icons.category, heritage.category, AppColors.primary),
                      SizedBox(width: 8),
                      _buildInfoChip(Icons.flag, heritage.country, AppColors.success),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Poppins')),
                  SizedBox(height: 12),
                  Text(heritage.description, style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.6)),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isAddingToWishlist ? null : () => _addToWishlist(heritage, context),
                          icon: _isAddingToWishlist ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(Icons.add),
                          label: Text(_isAddingToWishlist ? 'Adding...' : 'Add to Plan'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 16)),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/add_edit', arguments: {'heritage': heritage, 'mode': 'add'}),
                        child: Icon(Icons.edit_calendar),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white, padding: EdgeInsets.all(16)),
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

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.accent)),
      child: Row(children: [Icon(Icons.star, size: 16, color: AppColors.accent), SizedBox(width: 4), Text(rating.toString(), style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: color), SizedBox(width: 6), Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500))]),
    );
  }
}