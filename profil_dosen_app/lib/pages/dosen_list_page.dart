import 'package:flutter/material.dart';
import '../widgets/dosen_card.dart';
import '../data/dosen_data.dart';
import 'dosen_detail_page.dart';

class DosenListPage extends StatelessWidget {
  const DosenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Daftar Dosen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Dosen Program Studi Sistem Informasi',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF424242),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: DosenData.dosenList.length,
              itemBuilder: (context, index) {
                final dosen = DosenData.dosenList[index];
                return DosenCard(
                  dosen: dosen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DosenDetailPage(dosen: dosen),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}