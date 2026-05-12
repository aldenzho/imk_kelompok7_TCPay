// lib/riwayat_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '/homepage/homepage.dart';
import '/transfer_page/transfer_page.dart';
import '/settings_page/settings_page.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  bool _isBalanceVisible = false;
  final String _actualBalance = "Rp 12.400.000";
  String get _displayBalance => _isBalanceVisible ? _actualBalance : "Rp •••••••";

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
          // Dompet
          const Text(
            'Dompet',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          // Tabungan Akademik (di sini)
          const Text(
            'Tabungan Akademik',
            style: TextStyle(fontSize: 16, color: Color(0xFF424654)),
          ),
          const SizedBox(height: 16),

          // Total Saldo - Container biru gradien (mirip isi saldo di homepage)
          Container(
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
              children: [
                // Baris TOTAL SALDO & TINGKAT GOLD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'TOTAL SALDO',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'TINGKAT GOLD',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Baris saldo dengan visibility
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isBalanceVisible
                        ? Text(
                            _displayBalance,
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          )
                        : ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Text(
                              _displayBalance,
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 12),
                // Baris NOMOR REKENING + nomor & ikon
                Row(
                  children: [
                    const Text(
                      'NOMOR REKENING',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const Spacer(),
                    const Text(
                      '**** **** 8982',
                      style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.2),
                    ),
                    const SizedBox(width: 12),
                    // Ikon topi wisuda (background bulat)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFE9800),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, color: Color(0xFF643900), size: 18),
                    ),
                    const SizedBox(width: 8),
                    // Ikon dompet (background #A93802, icon #FFCEBD)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFA93802),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance_wallet, color: Color(0xFFFFCEBD), size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ========== Pengeluaran Bulanan (card putih) ==========
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pengeluaran Bulanan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Color(0xFFFFDCBD).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Text('8% vs bulan lalu', style: TextStyle(fontSize: 10, color: Color(0xFF8A5100))),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Area chart dengan tinggi tetap agar tidak tumpang tindih
                SizedBox(
                  height: 80, // cukup untuk bar + label
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _buildBarChartItems(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // KATEGORI UTAMA & TARGET TABUNGAN
          Row(
            children: [
              Expanded(
                child: _buildInfoCardVertical(
                  'KATEGORI UTAMA',
                  'Makanan & Minuman',
                  Icons.restaurant,
                  const Color(0xFF8A5100), // warna icon coklat
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCardVertical(
                  'TARGET TABUNGAN',
                  'Rp 12.400.000',
                  Icons.savings,
                  const Color(0xFF0040A1), // warna icon biru
                ),
              ),
            ],
          ),

          // Aktivitas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Aktivitas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0040A1))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityGroup('KEMARIN — 23 AGU', [
            _buildActivityItem('Toko Universitas', 'Buku • 15:20', '-Rp 1.150.000', Icons.menu_book),
            _buildActivityItem('Ojek Kampus ', 'Transportasi • 09:12', '-Rp 15.000', Icons.motorcycle),
          ]),
          const SizedBox(height: 16),
          _buildActivityGroup('KEMARIN — 23 AGU', [
            _buildActivityItem('Toko Universitas Buku', 'Buku • 15:20', '-Rp 1.150.000', Icons.menu_book),
            _buildActivityItem('Ojek Kampus Tempatan', 'Transportasi • 09:12', '-Rp 15.000', Icons.motorcycle),
          ]),
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'RIMAYAT'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'PENGATURAN'),
        ],
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TransferPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          }
        },
      ),
    );
  }

  Widget _buildBarChartItem(String day, double heightPercent) {
    double maxHeight = 40;
    double barHeight = (heightPercent / 100) * maxHeight;
    return Column(
      children: [
        Container(
          width: 20,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF0040A1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(day, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
  Widget _buildInfoCardVertical(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActivityGroup(String date, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            date,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, String amount, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        ],
      ),
    );
  }
  List<Widget> _buildBarChartItems() {
    final List<Map<String, dynamic>> data = [
      {'day': 'SEN', 'value': 30},
      {'day': 'SEL', 'value': 50},
      {'day': 'RAB', 'value': 20},
      {'day': 'KAM', 'value': 70},
      {'day': 'JUM', 'value': 40},
      {'day': 'SAB', 'value': 60},
    ];

    final List<double> values = data.map((e) => (e['value'] as num).toDouble()).toList();
    final double maxValue = values.reduce((a, b) => a > b ? a : b);
    const double maxBarHeight = 50;
    const double barWidth = 42;
    const double spacing = 16; // jarak antar bar

    List<Widget> bars = [];
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final double value = (item['value'] as num).toDouble();
      final double barHeight = (value / maxValue) * maxBarHeight;
      final bool isHighest = value == maxValue;

      bars.add(
        SizedBox(
          width: barWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: barWidth,
                height: barHeight,
                decoration: BoxDecoration(
                  color: isHighest ? const Color(0xFF0056D2) : const Color(0xFFEAE8E7),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
              const SizedBox(height: 8),
              Text(item['day'], style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      );
      if (i < data.length - 1) {
        bars.add(SizedBox(width: spacing));
      }
    }
    return bars;
  }
}