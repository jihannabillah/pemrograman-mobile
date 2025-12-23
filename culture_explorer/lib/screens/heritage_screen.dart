import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/heritage_provider.dart';
import '../widgets/heritage_card.dart';
import '../constants.dart';

class HeritageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HeritageProvider>(context);
    
    // Deteksi Dark Mode untuk teks error/empty
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final subTextColor = isDark ? Colors.white70 : AppColors.textSecondary;

    return Scaffold(
      // --- PERBAIKAN UTAMA: HAPUS backgroundColor ---
      // Jangan ada baris: backgroundColor: AppColors.background, 
      // Biarkan kosong agar ikut Theme Data
      
      appBar: AppBar(
        title: Text(
          'Cultural Heritage',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        // Warna AppBar ikut tema juga
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : provider.errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 60, color: AppColors.error),
                      SizedBox(height: 16),
                      Text(
                        'Error Loading Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        provider.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: subTextColor),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => provider.loadHeritageData(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : provider.heritageList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: subTextColor),
                          SizedBox(height: 16),
                          Text(
                            'No Heritage Sites Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(color: subTextColor),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.heritageList.length,
                      itemBuilder: (context, index) {
                        final heritage = provider.heritageList[index];
                        return HeritageCard(
                          imageUrl: heritage.imageUrl,
                          title: heritage.name,
                          country: heritage.country,
                          category: heritage.category,
                          rating: heritage.rating,
                          isPopular: heritage.isPopular,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: heritage.id,
                            );
                          },
                        );
                      },
                    ),
    );
  }
}