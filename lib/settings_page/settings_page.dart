// lib/settings_page.dart
import 'package:flutter/material.dart';
import '/homepage/homepage.dart';
import '/transfer_page/transfer_page.dart';
import '/riwayat_page/riwayat_page.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F8),
      appBar: AppBar(
        title: const Text(
          'Abimanyu Danendra A.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0040A1),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0040A1)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Profil card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF0040A1).withOpacity(0.1),
                  child: const Icon(Icons.person, size: 32, color: Color(0xFF0040A1)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Abimanyu Danendra A.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '5025231182@student.its.ac.id',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: const [
                            Icon(Icons.email_outlined, size: 14, color: Color(0xFF0040A1)),
                            SizedBox(width: 4),
                            Text(
                              'S1 Teknik Informatika',
                              style: TextStyle(fontSize: 12, color: Color(0xFF0040A1)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section PRIVACY & SECURITY (English)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'PRIVACY & SECURITY',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsTile(
            title: 'Privacy Mode',
            subtitle: 'Mask balances by default',
            icon: Icons.visibility_off,
            trailing: Switch(
              value: false,
              onChanged: (v) {},
              activeColor: const Color(0xFF0040A1),
              activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsTile(
            title: 'Biometric Login',
            subtitle: 'Use FaceID or Fingerprint',
            icon: Icons.fingerprint,
            trailing: Switch(
              value: true,
              onChanged: (v) {},
              activeColor: const Color(0xFF0040A1),
              activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsTile(
            title: 'Two-Factor Auth',
            subtitle: 'Enhanced account protection',
            icon: Icons.security,
            trailing: Switch(
              value: false,
              onChanged: (v) {},
              activeColor: const Color(0xFF0040A1),
              activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),

          // Section PRIVASI & KEAMANAN (Indonesian)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'PRIVASI & KEAMANAN',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsTile(
            title: 'Autentikasi Dua Faktor',
            subtitle: 'Peningkatan perlindungan akun',
            icon: Icons.security,
            trailing: Switch(
              value: false,
              onChanged: (v) {},
              activeColor: const Color(0xFF0040A1),
              activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsTile(
            title: 'Login Biometrik',
            subtitle: 'Gunakan FaceID atau Sidik Jari',
            icon: Icons.fingerprint,
            trailing: Switch(
              value: true,
              onChanged: (v) {},
              activeColor: const Color(0xFF0040A1),
              activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Keluar (background merah oval panjang, icon logout di kiri)
          // Tombol Keluar 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white, // background putih
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text('Keluar', style: TextStyle(color: Colors.black87)),
                      content: const Text('Apakah Anda yakin ingin keluar?', style: TextStyle(color: Colors.black87)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(foregroundColor: Colors.black87),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false,
                            );
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Keluar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Footer versi
          Center(
            child: Text(
              'TCPay MOBILE - VERSION 4.2.0 (ALPHA)',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0040A1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'BERANDA'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'TRANSFER'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'RIMAYAT'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'PENGATURAN'),
        ],
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TransferPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RiwayatPage()));
          }
        },
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF0040A1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}