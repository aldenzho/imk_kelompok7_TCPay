// lib/transfer_page.dart
import 'package:flutter/material.dart';
import '/homepage/homepage.dart';
import '/riwayat_page/riwayat_page.dart';
import '/settings_page/settings_page.dart';
import 'package:dotted_border/dotted_border.dart';


class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF9F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          const Text(
            'Pindahkan Dana Anda.',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Cepat, aman, dan terintegrasi kampus.',
            style: TextStyle(fontSize: 16, color: Color(0xFF424654)),
          ),
          const SizedBox(height: 20),
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kontak atau layanan',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // GRID DUA KOLOM (antar-bank & sesama bank) - layout ikon di atas, rata kiri
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTransferOption(
                  icon: Icons.account_balance,
                  title: 'Antar-bank',
                  subtitle: 'Ke bank mana saja',
                  bgColor: Colors.white,
                  iconBgColor: const Color(0xFF0040A1).withOpacity(0.1),
                  iconColor: const Color(0xFF0040A1),
                  textColor: Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTransferOption(
                  icon: Icons.people,
                  title: 'Sesama Bank',
                  subtitle: 'Gratis & instan',
                  bgColor: const Color(0xFF0040A1),
                  iconBgColor: Colors.white.withOpacity(0.2),
                  iconColor: Colors.white,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // UKT & Biaya Kampus full width
          _buildFullWidthTransferOption(
            icon: Icons.school,
            title: 'UKT & Biaya Kampus',
            subtitle: 'Bayar kuliah dengan NRP',
            bgColor: const Color(0xFFFE9800),
            iconBgColor: const Color(0xFF643900).withOpacity(0.1),
            iconColor: const Color(0xFF643900),
            labelText: 'Kampus Ready',
            labelBgColor: const Color(0xFF643900),
          ),
          const SizedBox(height: 24),

          // Top up E-wallet
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top up E-wallet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0040A1))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEwalletItem('assets/gopay.png', 'GoPay'),
              _buildEwalletItem('assets/ovo.png', 'OVO'),
              _buildEwalletItem('assets/shopeepay.png', 'ShopeePay'),
              _buildEwalletItem('', 'Lainnya', isAddButton: true),
            ],
          ),
          const SizedBox(height: 24),

          // Transfer terakhir berhasil
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F3F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF6F3F2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transfer terakhir berhasil',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pembayaran Anda sebesar Rp 1.250.000 ke "Tojo Buku Universitas" telah terkirim.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Detail', style: TextStyle(color: Color(0xFF0040A1))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Transfer Terbaru
          const Text(
            'Transfer Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRecentTransfer('AZM', 'Aiden Zhorif Muhammad', 'BANK TC + 4492'),
          _buildRecentTransfer('RA', 'Rusdi Anto', 'BRH + 8011'),
          const SizedBox(height: 80),
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
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'SETTINGS'),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RiwayatPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
      ),
    );
  }

  // Layout vertikal: icon di atas, teks di bawah, rata kiri (start)
  Widget _buildTransferOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: bgColor == Colors.white ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
        mainAxisAlignment: MainAxisAlignment.start,   // Mulai dari atas
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  // Full width UKT & Biaya Kampus (tanpa panah, icon di kanan)
  Widget _buildFullWidthTransferOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
    required String labelText,
    required Color labelBgColor,
  }) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: labelBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              labelText,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEwalletItem(String assetPath, String label, {bool isAddButton = false}) {
    if (isAddButton) {
      return Column(
        children: [
          DottedBorder(
            color: Colors.grey.shade400,
            strokeWidth: 1.5,
            dashPattern: [6, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(16),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      label[0],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
    }
  }


  Widget _buildRecentTransfer(String initial, String name, String accountInfo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // putih
          borderRadius: BorderRadius.circular(20),
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
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Text(initial, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(accountInfo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}