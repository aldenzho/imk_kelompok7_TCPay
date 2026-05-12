// lib/homepage/homepage.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '/transfer_page/transfer_page.dart';
import '/riwayat_page/riwayat_page.dart';  // sesuaikan path jika perlu
import '/settings_page/settings_page.dart';  // sesuaikan path jika perlu

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = false;
  final String _actualBalance = "Rp 1.234.567";
  String get _displayBalance => _isBalanceVisible ? _actualBalance : "Rp •••••••";

  Widget _buildQuickAccessGridItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF0040A1)),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF9F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SELAMAT DATANG',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            SizedBox(height: 2),
            Text(
              'Abimanyu Danendra A.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF0056D2)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        children: [
          // Container biru full width
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0040A1), Color(0xFF0056D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Baris Akun Akademik Utama & AKTIF
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Akun Akademik Utama',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'AKTIF',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Baris Saldo dengan efek blur SUPER KUAT saat disembunyikan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isBalanceVisible
                          ? Text(
                              _displayBalance,
                              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          : ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                              child: Text(
                                _displayBalance,
                                style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                      IconButton(
                        icon: Icon(_isBalanceVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                        onPressed: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    '************* 8821',
                    style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 20),

                  // Baris Isi Saldo dan Logo QR
                  // Baris Isi Saldo (full width) dan Logo QR
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline, color: Color(0xFF0040A1), size: 24),
                                  SizedBox(width: 8),
                                  Text('Isi Saldo', style: TextStyle(color: Color(0xFF0040A1), fontWeight: FontWeight.w500, fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFE9800),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ========== KONTEN LAINNYA (tidak berubah) ==========
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    const Text(
                      'Kebutuhan Utama',
                      style: TextStyle(fontSize: 24, color: Color(0xFF0040A1), fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      'PUSAT KAMPUS',
                      style: TextStyle(fontSize: 12, color: Color(0xFF8A5100), fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMenuCard(
                      icon: Icons.qr_code_scanner,
                      label: 'QRIS',
                      subtitle: 'DAYAR INSTAN',
                      bgColor: const Color(0xFFFFFFFF),
                      iconBgColor: const Color(0xFF0040A1).withOpacity(0.1),
                      iconColor: const Color(0xFF0040A1),
                    ),
                    _buildMenuCard(
                      icon: Icons.swap_horiz,
                      label: 'Transfer',
                      subtitle: 'KIRIM DANA',
                      bgColor: const Color(0xFFFFFFFF),
                      iconBgColor: const Color(0xFF8A51001A).withOpacity(0.1),
                      iconColor: const Color(0xFF8A5100),
                    ),
                    _buildMenuCard(
                      icon: Icons.account_balance_wallet,
                      label: 'E-wallet',
                      subtitle: 'TOP UP APLIKASI',
                      bgColor: const Color(0xFFFFFFFF),
                      iconBgColor: const Color(0xFFA938021A).withOpacity(0.1),
                      iconColor: const Color(0xFFA93802),
                    ),
                    _buildMenuCard(
                      icon: Icons.school,
                      label: 'Campus Pay',
                      subtitle: 'BAYA & ACARA',
                      bgColor: const Color(0xFFFFDCBD),
                      iconBgColor: const Color(0xFFFFFFFF),
                      iconColor: const Color(0xFF8A5100),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Pintasan Cepat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pintasan Cepat',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0040A1)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'LIHAT SEMUA',
                      style: TextStyle(color: Color(0xFF737785), fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0, // membuat item berbentuk kotak
                children: [
                  _buildQuickAccessGridItem('Pulsa & Data', Icons.flash_on),
                  _buildQuickAccessGridItem('Kantin Perpus', Icons.coffee),
                  _buildQuickAccessGridItem('Sewa Kos', Icons.house),
                ],
              ),
              const SizedBox(height: 24),

                // Jurnal Transaksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jurnal Transaksi',
                      style: TextStyle(fontSize: 24,color: Color(0xFF0040A1), fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'ANALISIS',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8A5100), fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTransactionItem(
                  title: 'Ayam',
                  titleSpan: ' Jamoer',
                  subtitle: 'HARI INI, 12:45',
                  amount: '-Rp 12.500',
                  color: const Color(0xFFFFDCBD),
                  icon: Icons.restaurant,
                  category: 'MAKANAN',
                ),
                _buildTransactionItem(
                  title: 'Transfer dari Ayah',
                  titleSpan: '',
                  subtitle: 'KEMARIN, 10:15',
                  amount: '+Rp 500.000.000',
                  color: const Color(0xFFDAE2FF),
                  icon: Icons.south_west,
                  category: 'UANG SAKU',
                ),
                _buildTransactionItem(
                  title: 'Sakinah Keputih',
                  titleSpan: '',
                  subtitle: 'OCT 28, 10:25 AM',
                  amount: '-Rp 85.000',
                  color: const Color(0xFFEAE8E7),
                  icon: Icons.bookmark,
                  category: 'BELANJA',
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'RIWAYAT'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'PENGATURAN'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // Navigasi ke halaman Transfer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferPage()),
            );
          } else if (index == 2) {
            // Navigasi ke halaman Riwayat
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RiwayatPage()),
            );
          } else if (index == 3) {
            // Navigasi ke halaman Pengaturan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
      ),
    );
  }

  // Widget pembantu (sama seperti sebelumnya)
  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0040A1)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
  Widget _buildTransactionItem({
    required String title,
    required String titleSpan,
    required String subtitle,
    required String amount,
    required Color color,
    required IconData icon,
    required String category,
  }) {
    // Warna kategori
    Map<String, Color> categoryTextColor = {
      'MAKANAN': const Color(0xFF693C00),
      'UANG SAKU': const Color(0xFF0040A1),
      'BELANJA': const Color(0xFF424654),
    };
    Color textColor = categoryTextColor[category] ?? Colors.grey;
    Color bgColor = textColor.withOpacity(0.15);

    // Warna amount (+ hijau, - merah)
    Color amountColor = Colors.black87;
    if (amount.contains('+')) amountColor = Colors.green;
    else if (amount.contains('-')) amountColor = Colors.red;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20), // <-- rounded corner
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.black54, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        children: [
                          TextSpan(text: title),
                          TextSpan(text: titleSpan),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(fontWeight: FontWeight.bold, color: amountColor),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}