import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Dasar App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Tambahan Material 3 untuk design yang lebih modern
      ),
      home: const BiodataPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  bool isPressed = false;
  int pressCount = 0; // Tambahan fitur: counter untuk interaksi yang lebih engaging

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF), // Warna background 
      appBar: AppBar(
        title: const Text(
          'Biodata Mahasiswa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4, // Tambahan shadow untuk depth
      ),
      body: SingleChildScrollView( // Agar bisa scroll jika konten panjang
        child: Center(
          child: Container(
            width: 350, // Sedikit lebih lebar untuk tampilan yang lebih baik
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24), // Padding yang lebih proporsional
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // Border radius yang lebih smooth
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              gradient: LinearGradient( // Tambahan gradient subtle
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.purple.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =============== IMAGE WIDGET ===============
                Stack(
                  children: [
                    // 🔸 IMAGE: Foto profil dengan frame
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple,
                            Colors.purpleAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.asset(
                            'assets/images/foto_jihan.jpg',
                            width: 132,
                            height: 132,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.person, size: 60, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Badge status online
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // =============== TEXT WIDGETS ===============
                // 🔸 TEXT: Nama dengan style yang lebih menarik
                const Text(
                  'Jihan Nabillah',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                // 🔸 TEXT: Deskripsi dengan style yang berbeda
                const Text(
                  'Mahasiswa Sistem Informasi - Semester 5',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // 🔸 TEXT: Quote motivasi
                const Text(
                  '"Passionate about technology and innovation"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // 🔸 DIVIDER dengan style
                Divider(
                  color: Colors.deepPurple.shade100,
                  thickness: 1,
                  height: 20,
                ),

                // =============== COLUMN WIDGET ===============
                // 🔸 COLUMN: Container untuk section biodata
                Column(
                  children: [
                    const SizedBox(height: 8),
                    // 🔸 TEXT: Section title
                    const Text(
                      'Informasi Pribadi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // =============== ROW WIDGETS ===============
                    // 🔸 ROW: Data biodata 
                    buildBiodataRow('NIM', '701230022', Icons.badge),
                    buildBiodataRow('Program Studi', 'Sistem Informasi', Icons.school),
                    buildBiodataRow('Semester', '5 (Lima)', Icons.calendar_today),
                    buildBiodataRow('Hobi', 'Coding dan Game Teka-Teki', Icons.favorite),
                    buildBiodataRow('Email', 'jihannabillah95@gmail.com', Icons.email),
                    buildBiodataRow('Lokasi', 'Indonesia', Icons.location_on),
                  ],
                ),
                const SizedBox(height: 24),

                // =============== BUTTON WIDGETS ===============
                // 🔸 BUTTON: Elevated Button dengan interaksi
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isPressed = !isPressed;
                          pressCount++;
                        });
                      },
                      icon: Icon(
                        isPressed ? Icons.check_circle : Icons.touch_app,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        isPressed ? 'Tertekan!' : 'Tekan Saya',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPressed ? Colors.green : Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.deepPurple.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // 🔸 TEXT: Feedback interaksi button
                    Text(
                      isPressed 
                          ? '👍 Wow! Tombol sudah ditekan $pressCount kali!' 
                          : '👆 Tekan tombol di atas untuk memulai!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isPressed ? Colors.green.shade700 : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // 🔸 BUTTON: Secondary button untuk reset
                    if (pressCount > 0) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isPressed = false;
                            pressCount = 0;
                          });
                        },
                        child: const Text(
                          'Reset Counter',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      
      // 🔸 BUTTON: Floating Action Button tambahan
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            pressCount++;
          });
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Tambah Counter',
      ),
    );
  }

  // =============== FUNGSI PEMBANTU UNTUK ROW ===============
  // 🔸 ROW: Fungsi untuk merapikan baris biodata dengan icon
  Widget buildBiodataRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // 🔸 ICON untuk setiap row
              Icon(
                icon,
                color: Colors.deepPurple,
                size: 18,
              ),
              const SizedBox(width: 12),
              
              // 🔸 TEXT: Label
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              
              // 🔸 TEXT: Value
              Expanded(
                flex: 6,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}