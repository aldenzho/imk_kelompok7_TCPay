import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrisMyCodeScreen extends StatefulWidget {
  const QrisMyCodeScreen({super.key});

  @override
  State<QrisMyCodeScreen> createState() => _QrisMyCodeScreenState();
}

class _QrisMyCodeScreenState extends State<QrisMyCodeScreen> {
  bool _isBalanceVisible = false;

  String _formatRp(double val) {
    final str = val.toInt().toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Belum login')));
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final name = data?['name']?.toString() ?? user.displayName ?? 'Pengguna TCPay';
        final tcpayId = data?['tcpayId']?.toString() ?? user.uid.substring(0, 12).toUpperCase();
        final balance = (data?['balance'] ?? 0).toDouble();
        final qrData = 'TCPAY://USER/$tcpayId';

        return Scaffold(
          backgroundColor: const Color(0xFFFBF9F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0040A1)),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Kode QRIS Saya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // User info card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0040A1), Color(0xFF0056D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        _initials(name),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tcpayId,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // QR Code card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan untuk membayar ke akun ini',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 220,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF0040A1),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF0040A1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Balance with blur toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isBalanceVisible
                            ? Text(
                                _formatRp(balance),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0040A1),
                                ),
                              )
                            : ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Text(
                                  _formatRp(balance),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0040A1),
                                  ),
                                ),
                              ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('QR Code disimpan ke galeri')),
                      ),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Simpan QR'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0040A1),
                        side: const BorderSide(color: Color(0xFF0040A1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membagikan kode QRIS...')),
                      ),
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Bagikan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0040A1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Warning footer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFF8A5100), size: 18),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'QR Code ini unik untuk akun Anda. Jangan bagikan kepada pihak yang tidak dikenal.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8A5100)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
