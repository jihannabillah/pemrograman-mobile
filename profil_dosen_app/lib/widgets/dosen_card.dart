import 'package:flutter/material.dart';
import '../models/dosen_model.dart';

class DosenCard extends StatelessWidget {
  final Dosen dosen;
  final VoidCallback onTap;

  const DosenCard({
    super.key,
    required this.dosen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE3F2FD),
                Colors.white,
                Color(0xFFE3F2FD),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // Avatar Container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getAvatarColor(dosen.id),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    dosen.avatar,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Informasi Dosen
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dosen.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getJabatanColor(dosen.jabatan),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dosen.jabatan,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getJabatanTextColor(dosen.jabatan),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 14,
                          color: Color(0xFF1976D2),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            dosen.bidang,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1976D2),
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF1976D2),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function untuk warna avatar berdasarkan ID
  Color _getAvatarColor(String id) {
    final colors = [
      const Color(0xFFE3F2FD), // Blue 50
      const Color(0xFFE8F5E8), // Green 50
      const Color(0xFFFBE9E7), // Orange 50
      const Color(0xFFF3E5F5), // Purple 50
      const Color(0xFFFFEBEE), // Red 50
      const Color(0xFFE0F2F1), // Teal 50
    ];
    final index = int.parse(id) % colors.length;
    return colors[index];
  }

  // Helper function untuk warna badge jabatan
  Color _getJabatanColor(String jabatan) {
    if (jabatan.toLowerCase().contains('pns')) {
      return const Color(0xFFE8F5E8); // Green 50 untuk PNS
    } else if (jabatan.toLowerCase().contains('luar biasa')) {
      return const Color(0xFFFFF3E0); // Orange 50 untuk Luar Biasa
    } else if (jabatan.toLowerCase().contains('guru besar')) {
      return const Color(0xFFFFEBEE); // Red 50
    } else if (jabatan.toLowerCase().contains('ketua') || 
               jabatan.toLowerCase().contains('wakil')) {
      return const Color(0xFFE3F2FD); // Blue 50
    } else {
      return const Color(0xFFF3E5F5); // Purple 50 default
    }
  }

  // Helper function untuk warna text badge jabatan
  Color _getJabatanTextColor(String jabatan) {
    if (jabatan.toLowerCase().contains('pns')) {
      return const Color(0xFF2E7D32); // Green 800 untuk PNS
    } else if (jabatan.toLowerCase().contains('luar biasa')) {
      return const Color(0xFFEF6C00); // Orange 800 untuk Luar Biasa
    } else if (jabatan.toLowerCase().contains('guru besar')) {
      return const Color(0xFFC62828); // Red 800
    } else if (jabatan.toLowerCase().contains('ketua') || 
               jabatan.toLowerCase().contains('wakil')) {
      return const Color(0xFF1565C0); // Blue 800
    } else {
      return const Color(0xFF7B1FA2); // Purple 800 default
    }
  }
}