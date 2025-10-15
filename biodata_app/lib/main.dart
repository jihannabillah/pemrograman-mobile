import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hilangkan tulisan debug
      title: 'Biodata App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Poppins', // font 
      ),
      home: const BiodataPage(),
    );
  }
}

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Biodata Mahasiswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 4, // efek bayangan bawah appbar
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/profile.jpg'), // foto profil 
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Jihan Nabillah',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Mahasiswa Sistem Informasi',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const Divider(height: 30, thickness: 1),
              const SizedBox(height: 4),
              const InfoRow(label: 'NIM', value: '701230022'),
              const InfoRow(label: 'Program Studi', value: 'Sistem Informasi'),
              const InfoRow(label: 'Hobi', value: 'Berdoa dan Ngoding'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget kecil biar tampilan biodata rapi & konsisten
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
