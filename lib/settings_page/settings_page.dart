// lib/settings_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/homepage/homepage.dart';
import '/transfer_page/transfer_page.dart';
import '/riwayat_page/riwayat_page.dart';
import '/auth/security_choice_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _privacyMode = false;
  bool _biometricLogin = true;

  void _goToSecurityChoice(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SecurityChoicePage()),
      (route) => false,
    );
  }

  void _showComingSoon(String fitur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$fitur segera hadir')),
    );
  }

  String _getUserName({
    required Map<String, dynamic>? data,
    required User user,
  }) {
    return data?['name']?.toString() ??
        user.displayName ??
        'Pengguna TCPay';
  }

  String _getUserEmail({
    required Map<String, dynamic>? data,
    required User user,
  }) {
    return data?['email']?.toString() ??
        user.email ??
        'Email tidak tersedia';
  }

  String _getUserInfo({
    required Map<String, dynamic>? data,
  }) {
    return data?['major']?.toString() ??
        data?['program']?.toString() ??
        data?['username']?.toString() ??
        'S1 Teknik Informatika';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return SecurityChoicePage();
    }

    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userStream,
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final userName = _getUserName(data: data, user: user);
        final userEmail = _getUserEmail(data: data, user: user);
        final userInfo = _getUserInfo(data: data);

        return Scaffold(
          backgroundColor: const Color(0xFFFBF9F8),
          appBar: AppBar(
            title: Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0040A1),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF0040A1),
                ),
                onPressed: () => _showComingSoon('Notifikasi'),
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
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          const Color(0xFF0040A1).withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Color(0xFF0040A1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  size: 14,
                                  color: Color(0xFF0040A1),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    userInfo,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0040A1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                  'PRIVASI & KEAMANAN',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                title: 'Privacy Mode',
                subtitle: 'Sembunyikan saldo secara default',
                icon: Icons.visibility_off,
                trailing: Switch(
                  value: _privacyMode,
                  onChanged: (v) => setState(() => _privacyMode = v),
                  activeThumbColor: const Color(0xFF0040A1),
                  activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                title: 'Login Biometrik',
                subtitle: 'Gunakan FaceID atau Sidik Jari',
                icon: Icons.fingerprint,
                trailing: Switch(
                  value: _biometricLogin,
                  onChanged: (v) => setState(() => _biometricLogin = v),
                  activeThumbColor: const Color(0xFF0040A1),
                  activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsTile(
                title: 'Autentikasi Dua Faktor',
                subtitle: 'Peningkatan perlindungan akun',
                icon: Icons.security,
                trailing: Switch(
                  value: false,
                  onChanged: (v) => _showComingSoon('Autentikasi Dua Faktor'),
                  activeThumbColor: const Color(0xFF0040A1),
                  activeTrackColor: const Color(0xFF0040A1).withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 24),

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
                        builder: (dialogContext) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            'Keluar',
                            style: TextStyle(color: Colors.black87),
                          ),
                          content: const Text(
                            'Apakah Anda yakin ingin keluar?',
                            style: TextStyle(color: Colors.black87),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black87,
                              ),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                _goToSecurityChoice(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
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
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'BERANDA',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz),
                label: 'TRANSFER',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'RIMAYAT',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'PENGATURAN',
              ),
            ],
            currentIndex: 3,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TransferPage()),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatPage()),
                );
              }
            },
          ),
        );
      },
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
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
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
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.settings,
              color: Color(0xFF0040A1),
              size: 0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Builder(
              builder: (context) {
                return Row(
                  children: [
                    Icon(icon, color: const Color(0xFF0040A1), size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}