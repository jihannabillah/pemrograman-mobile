import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  const ProfilePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada data yang dikirim, tampilkan profile default
    final currentUser = user ?? 
        User(
          name: "Jihan Nabillah",
          email: "jihannabillah95@gmail.com",
          phone: "+62 821-7971-7946",
          profileImage: "👩‍🎓",
          semester: 5,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  currentUser.profileImage,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentUser.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Mahasiswa Sistem Informasi",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            // Profile Info Cards
            _buildInfoCard(
              context,
              Icons.school_rounded,
              "Semester",
              "Semester ${currentUser.semester}",
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              Icons.email_rounded,
              "Email",
              currentUser.email,
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              Icons.phone_rounded,
              "Telepon",
              currentUser.phone,
              Colors.orange,
            ),
            const SizedBox(height: 30),
            // Action Button
            ElevatedButton(
              onPressed: () {
                _showEditDialog(context, currentUser);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Edit Profil"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profil"),
        content: const Text("Fitur edit profil akan segera tersedia!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}