// lib/homepage/homepage.dart
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/transfer_page/transfer_page.dart';
import '/transfer_page/campus_pay/campus_pay.dart';
import '/riwayat_page/riwayat_page.dart';
import '/settings_page/settings_page.dart';
import '/qris/qris_menu_screen.dart';
import '/isi_saldo/isi_saldo_screen.dart';
import '/pintasan_cepat/pintasan_cepat_screen.dart';
import '/pintasan_cepat/semua_pintasan_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _isBalanceVisibleNotifier = ValueNotifier(false);

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _isBalanceVisibleNotifier.dispose();
    super.dispose();
  }

  String _formatCurrency(dynamic value) {
    final double amount = value is int
        ? value.toDouble()
        : value is double
            ? value
            : double.tryParse(value.toString()) ?? 0;

    final String number = amount.toStringAsFixed(0);
    final String formatted = number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );

    return 'Rp $formatted';
  }

  String _lastFourUid(String uid) {
    if (uid.length <= 4) return uid.toUpperCase();
    return uid.substring(uid.length - 4).toUpperCase();
  }

  void _goToQris() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrisMenuScreen()),
    );
  }

  Widget _buildQuickAccessGridItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: const Color(0xFF0040A1),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('User belum login'),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFBF9F8),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0040A1),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFFBF9F8),
            body: Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            ),
          );
        }

        final data = snapshot.data?.data();

        final String userName = data?['name']?.toString() ??
            _currentUser.displayName ??
            'Pengguna TCPay';

        final dynamic balanceValue = data?['balance'] ?? 0;
        final String actualBalance = _formatCurrency(balanceValue);

        final String accountNumber =
            '************* ${_lastFourUid(_currentUser.uid)}';

        return Scaffold(
          backgroundColor: const Color(0xFFFBF9F8),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SELAMAT DATANG',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0040A1),
                  ),
                  overflow: TextOverflow.ellipsis,
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
                    GestureDetector(
                      onTap: _goToQris,
                      child: _buildMenuCard(
                        icon: Icons.qr_code_scanner,
                        label: 'QRIS',
                        subtitle: 'BAYAR INSTAN',
                        bgColor: Colors.white,
                        iconBgColor: const Color(0xFF0040A1).withValues(alpha: 0.1),
                        iconColor: const Color(0xFF0040A1),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TransferPage()),
                      ).then((_) => setState(() {})),
                      child: _buildMenuCard(
                        icon: Icons.swap_horiz,
                        label: 'Transfer',
                        subtitle: 'KIRIM DANA',
                        bgColor: Colors.white,
                        iconBgColor: const Color(0xFF8A5100).withValues(alpha: 0.1),
                        iconColor: const Color(0xFF8A5100),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
                      ),
                      child: _buildMenuCard(
                        icon: Icons.account_balance_wallet,
                        label: 'E-wallet',
                        subtitle: 'TOP UP APLIKASI',
                        bgColor: Colors.white,
                        iconBgColor: const Color(0xFFA93802).withValues(alpha: 0.1),
                        iconColor: const Color(0xFFA93802),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CampusPayPage()),
                      ),
                      child: _buildMenuCard(
                        icon: Icons.school,
                        label: 'Campus Pay',
                        subtitle: 'BAYA & ACARA',
                        bgColor: const Color(0xFFFFDCBD),
                        iconBgColor: Colors.white,
                        iconColor: const Color(0xFF8A5100),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF0056D2),
                ),
                onPressed: () {},
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black87,
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0040A1),
                        Color(0xFF0056D2),
                      ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Akun Akademik Utama',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'AKTIF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ValueListenableBuilder<bool>(
                        valueListenable: _isBalanceVisibleNotifier,
                        builder: (context, isVisible, _) {
                          final String displayBalance =
                              isVisible ? actualBalance : 'Rp •••••••';

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isVisible
                                  ? Text(
                                      displayBalance,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: 3.0,
                                        sigmaY: 3.0,
                                      ),
                                      child: Text(
                                        displayBalance,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              IconButton(
                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _isBalanceVisibleNotifier.value = !isVisible;
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 24,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      Text(
                        accountNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 20),

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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const IsiSaldoScreen(),
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Color(0xFF0040A1),
                                        size: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Isi Saldo',
                                        style: TextStyle(
                                          color: Color(0xFF0040A1),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _goToQris,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFE9800),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kebutuhan Utama',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF0040A1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'PUSAT KAMPUS',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8A5100),
                            fontWeight: FontWeight.w700,
                          ),
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
                        GestureDetector(
                          onTap: _goToQris,
                          child: _buildMenuCard(
                            icon: Icons.qr_code_scanner,
                            label: 'QRIS',
                            subtitle: 'BAYAR INSTAN',
                            bgColor: Colors.white,
                            iconBgColor:
                                const Color(0xFF0040A1).withOpacity(0.1),
                            iconColor: const Color(0xFF0040A1),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TransferPage(),
                              ),
                            );
                          },
                          child: _buildMenuCard(
                            icon: Icons.swap_horiz,
                            label: 'Transfer',
                            subtitle: 'KIRIM DANA',
                            bgColor: Colors.white,
                            iconBgColor:
                                const Color(0xFF8A5100).withOpacity(0.1),
                            iconColor: const Color(0xFF8A5100),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const IsiSaldoScreen()),
                          ),
                          child: _buildMenuCard(
                            icon: Icons.account_balance_wallet,
                            label: 'E-wallet',
                            subtitle: 'TOP UP APLIKASI',
                            bgColor: Colors.white,
                            iconBgColor:
                                const Color(0xFFA93802).withOpacity(0.1),
                            iconColor: const Color(0xFFA93802),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CampusPayPage()),
                          ),
                          child: _buildMenuCard(
                            icon: Icons.school,
                            label: 'Campus Pay',
                            subtitle: 'BAYA & ACARA',
                            bgColor: const Color(0xFFFFDCBD),
                            iconBgColor: Colors.white,
                            iconColor: const Color(0xFF8A5100),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pintasan Cepat',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0040A1),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SemuaPintasanScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'LIHAT SEMUA',
                            style: TextStyle(
                              color: Color(0xFF737785),
                              fontWeight: FontWeight.w700,
                            ),
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
                      childAspectRatio: 1.0,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PintasanCepatScreen(
                                title: 'Pulsa & Data',
                                icon: Icons.flash_on,
                                color: Color(0xFF0040A1),
                                paymentType: 'pulsaData',
                                items: [
                                  PintasanCepatItem(label: 'Pulsa 10.000', amount: 11000, description: 'Pulsa reguler semua operator'),
                                  PintasanCepatItem(label: 'Pulsa 25.000', amount: 26500, description: 'Pulsa reguler semua operator'),
                                  PintasanCepatItem(label: 'Pulsa 50.000', amount: 52000, description: 'Pulsa reguler semua operator'),
                                  PintasanCepatItem(label: 'Data 1GB/7 hari', amount: 15000, description: 'Paket data internet'),
                                  PintasanCepatItem(label: 'Data 5GB/30 hari', amount: 45000, description: 'Paket data internet'),
                                ],
                              ),
                            ),
                          ),
                          child: _buildQuickAccessGridItem('Pulsa & Data', Icons.flash_on),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PintasanCepatScreen(
                                title: 'Kantin Perpus',
                                icon: Icons.coffee,
                                color: Color(0xFF8A5100),
                                paymentType: 'kantinPerpus',
                                items: [
                                  PintasanCepatItem(label: 'Paket Makan Siang', amount: 15000, description: 'Nasi + lauk + minuman'),
                                  PintasanCepatItem(label: 'Minuman & Snack', amount: 8000, description: 'Minuman dan camilan'),
                                  PintasanCepatItem(label: 'Kopi & Roti', amount: 12000, description: 'Kopi + roti bakar'),
                                  PintasanCepatItem(label: 'Paket Sarapan', amount: 10000, description: 'Bubur/nasi uduk + minuman'),
                                ],
                              ),
                            ),
                          ),
                          child: _buildQuickAccessGridItem('Kantin Perpus', Icons.coffee),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PintasanCepatScreen(
                                title: 'Sewa Kos',
                                icon: Icons.house,
                                color: Color(0xFF2E7D32),
                                paymentType: 'sewaKos',
                                items: [
                                  PintasanCepatItem(label: 'Kos Bulanan Tipe A', amount: 500000, description: 'Kamar standar tanpa AC'),
                                  PintasanCepatItem(label: 'Kos Bulanan Tipe B', amount: 750000, description: 'Kamar dengan AC'),
                                  PintasanCepatItem(label: 'Kos Bulanan Tipe C', amount: 1000000, description: 'Kamar AC + kamar mandi dalam'),
                                  PintasanCepatItem(label: 'Perpanjang 3 Bulan', amount: 2100000, description: 'Paket 3 bulan hemat 10%'),
                                ],
                              ),
                            ),
                          ),
                          child: _buildQuickAccessGridItem('Sewa Kos', Icons.house),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jurnal Transaksi',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF0040A1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RiwayatPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'ANALISIS',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A5100),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    _buildTransactionItem(
                      title: 'Lihat riwayat transaksi',
                      titleSpan: '',
                      subtitle: 'Aktivitas terbaru tersedia di halaman riwayat',
                      amount: 'Rp 0',
                      color: const Color(0xFFEAE8E7),
                      icon: Icons.receipt_long,
                      category: 'INFO',
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
                label: 'RIWAYAT',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'PENGATURAN',
              ),
            ],
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransferPage()),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatPage()),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              }
            },
          ),
        );
      },
    );
  }

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
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
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
    final Map<String, Color> categoryTextColor = {
      'MAKANAN': const Color(0xFF693C00),
      'UANG SAKU': const Color(0xFF0040A1),
      'BELANJA': const Color(0xFF424654),
      'INFO': const Color(0xFF424654),
    };

    final textColor = categoryTextColor[category] ?? Colors.grey;
    final bgColor = textColor.withOpacity(0.15);

    Color amountColor = Colors.black87;
    if (amount.contains('+')) {
      amountColor = Colors.green;
    } else if (amount.contains('-')) {
      amountColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
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
                child: Icon(
                  icon,
                  color: Colors.black54,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(text: title),
                          TextSpan(text: titleSpan),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
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