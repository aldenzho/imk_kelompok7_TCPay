// lib/riwayat_page/riwayat_page.dart
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String _formatSignedAmount({
    required dynamic amount,
    required bool isDebit,
  }) {
    final prefix = isDebit ? '-' : '+';
    return '$prefix${_formatCurrency(amount)}';
  }

  String _lastFourUid(String uid) {
    if (uid.length <= 4) return uid.toUpperCase();
    return uid.substring(uid.length - 4).toUpperCase();
  }

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();

    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == date.year &&
        yesterday.month == date.month &&
        yesterday.day == date.day;

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    if (isToday) {
      return 'HARI INI, $hour:$minute';
    }

    if (isYesterday) {
      return 'KEMARIN, $hour:$minute';
    }

    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGS',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];

    return '${date.day} ${months[date.month - 1]}, $hour:$minute';
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'transferOut':
        return Icons.arrow_upward;
      case 'transferIn':
        return Icons.arrow_downward;
      case 'withdrawal':
        return Icons.account_balance;
      case 'qrisPayment':
        return Icons.qr_code;
      case 'topUp':
        return Icons.add_circle_outline;
      default:
        return Icons.receipt_long;
    }
  }

  Color _getTransactionIconBg(String type) {
    switch (type) {
      case 'transferOut':
        return const Color(0xFFFFDCBD);
      case 'transferIn':
        return const Color(0xFFDAE2FF);
      case 'withdrawal':
        return const Color(0xFFEAE8E7);
      case 'qrisPayment':
        return const Color(0xFFFFDCBD);
      case 'topUp':
        return const Color(0xFFDDF7E8);
      default:
        return const Color(0xFFEAE8E7);
    }
  }

  String _getTransactionSubtitle(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    final method = data['method']?.toString();
    final createdAt = _parseDate(data['createdAt']);
    final dateLabel = _formatDateLabel(createdAt);

    if (type == 'topUp') {
      return '$dateLabel • ${method ?? 'ISI SALDO'}';
    }

    final subtitle = data['subtitle']?.toString();
    if (subtitle != null && subtitle.isNotEmpty) {
      return subtitle;
    }

    return dateLabel;
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

    final userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .snapshots();

    final transactionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDocStream,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFBF9F8),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0040A1),
              ),
            ),
          );
        }

        if (userSnapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFFBF9F8),
            body: Center(
              child: Text('Terjadi kesalahan: ${userSnapshot.error}'),
            ),
          );
        }

        final userData = userSnapshot.data?.data();

        final userName = userData?['name']?.toString() ??
            _currentUser.displayName ??
            'Pengguna TCPay';

        final balanceValue = userData?['balance'] ?? 0;
        final actualBalance = _formatCurrency(balanceValue);
        final accountNumber = '**** **** ${_lastFourUid(_currentUser.uid)}';

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
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              const Text(
                'Dompet',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Tabungan Akademik',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF424654),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL SALDO',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'TINGKAT GOLD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ValueListenableBuilder<bool>(
                      valueListenable: _isBalanceVisibleNotifier,
                      builder: (context, isVisible, _) {
                        final displayBalance =
                            isVisible ? actualBalance : 'Rp •••••••';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isVisible
                                ? Text(
                                    displayBalance,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
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
                                        fontSize: 28,
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

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Text(
                          'NOMOR REKENING',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          accountNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFE9800),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Color(0xFF643900),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFA93802),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Color(0xFFFFCEBD),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pengeluaran Bulanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDCBD).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '8% vs bulan lalu',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8A5100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 80,
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

              Row(
                children: [
                  Expanded(
                    child: _buildInfoCardVertical(
                      'KATEGORI UTAMA',
                      'Makanan & Minuman',
                      Icons.restaurant,
                      const Color(0xFF8A5100),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCardVertical(
                      'TARGET TABUNGAN',
                      'Rp 12.400.000',
                      Icons.savings,
                      const Color(0xFF0040A1),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Aktivitas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Color(0xFF0040A1)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: transactionStream,
                builder: (context, txSnapshot) {
                  if (txSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0040A1),
                        ),
                      ),
                    );
                  }

                  if (txSnapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Gagal memuat transaksi: ${txSnapshot.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  final docs = txSnapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return _buildEmptyTransaction();
                  }

                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data();
                      return _buildFirestoreTxItem(data);
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 80),
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
            currentIndex: 2,
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
              } else if (index == 3) {
                Navigator.pushReplacement(
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

  Widget _buildInfoCardVertical(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransaction() {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: const Row(
        children: [
          Icon(
            Icons.receipt_long,
            color: Color(0xFF0040A1),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Belum ada transaksi. Aktivitas isi saldo, transfer, dan QRIS akan muncul di sini.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirestoreTxItem(Map<String, dynamic> data) {
    final String title = data['title']?.toString() ?? 'Transaksi';
    final String type = data['type']?.toString() ?? '';
    final bool isDebit = data['isDebit'] == true;
    final dynamic amount = data['amount'] ?? 0;

    final IconData icon = _getTransactionIcon(type);
    final Color iconBg = _getTransactionIconBg(type);
    final String subtitle = _getTransactionSubtitle(data);
    final String formattedAmount = _formatSignedAmount(
      amount: amount,
      isDebit: isDebit,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.black54,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              formattedAmount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDebit ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
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

    final List<double> values =
        data.map((e) => (e['value'] as num).toDouble()).toList();

    final double maxValue = values.reduce((a, b) => a > b ? a : b);

    const double maxBarHeight = 50;
    const double barWidth = 42;
    const double spacing = 16;

    final List<Widget> bars = [];

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
                  color: isHighest
                      ? const Color(0xFF0056D2)
                      : const Color(0xFFEAE8E7),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['day'],
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      );

      if (i < data.length - 1) {
        bars.add(const SizedBox(width: spacing));
      }
    }

    return bars;
  }
}