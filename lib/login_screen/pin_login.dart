import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../homepage/homepage.dart';
import '../auth/login_page.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String _pin = '';
  bool _isLoading = false;

  static const Color primaryBlue = Color(0xFF0040A1);
  static const Color softBackground = Color(0xFFFAF7FC);

  void _onNumberTap(String number) {
    if (_isLoading) return;
    if (_pin.length >= 6) return;

    setState(() {
      _pin += number;
    });

    if (_pin.length == 6) {
      Future.delayed(const Duration(milliseconds: 180), _verifyPin);
    }
  }

  void _onDeleteTap() {
    if (_isLoading) return;
    if (_pin.isEmpty) return;

    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _verifyPin() async {
    if (_pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN harus 6 digit'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi login tidak ditemukan. Silakan login ulang.'),
          backgroundColor: Colors.redAccent,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );

      return;
    }

    setState(() => _isLoading = true);

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = userDoc.data();

      if (data == null) {
        throw Exception('Data user tidak ditemukan');
      }

      final savedPin = data['pin']?.toString();

      if (savedPin == null || savedPin.isEmpty) {
        if (!mounted) return;

        setState(() {
          _pin = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN belum dibuat. Silakan buat PIN terlebih dahulu.'),
            backgroundColor: Colors.orange,
          ),
        );

        return;
      }

      if (_pin != savedPin) {
        if (!mounted) return;

        setState(() {
          _pin = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN salah'),
            backgroundColor: Colors.redAccent,
          ),
        );

        return;
      }

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _pin = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memverifikasi PIN: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _changeAccount() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildPinIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final bool filled = index < _pin.length;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(horizontal: 7),
          width: filled ? 16 : 14,
          height: filled ? 16 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? primaryBlue : Colors.transparent,
            border: Border.all(
              color: filled ? primaryBlue : Colors.grey.shade400,
              width: 1.6,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () => _onNumberTap(number),
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2024),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: SizedBox(
        width: 76,
        height: 76,
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.backspace_outlined,
              onTap: _pin.isEmpty ? null : _onDeleteTap,
            ),
            _buildNumberButton('0'),
            _buildActionButton(
              icon: Icons.fingerprint,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Biometrik bisa dipakai dari halaman sebelumnya'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        backgroundColor: softBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1F2024),
          ),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 31,
                        color: primaryBlue,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'TCPay',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 54),

                  const Text(
                    'Masukkan PIN',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2024),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Gunakan PIN keamanan TCPay Anda',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 34),

                  _buildPinIndicator(),

                  const SizedBox(height: 42),

                  _buildKeypad(),

                  const SizedBox(height: 26),

                  TextButton(
                    onPressed: _isLoading ? null : _changeAccount,
                    child: const Text(
                      'Ganti Akun',
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 13,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'PIN AMAN UNTUK AKUN TCPAY',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),

            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.18),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: primaryBlue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}