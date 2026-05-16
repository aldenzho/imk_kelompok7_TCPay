import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PinConfirmationScreen extends StatefulWidget {
  final String title;
  final String subtitle;

  const PinConfirmationScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<PinConfirmationScreen> createState() => _PinConfirmationScreenState();
}

class _PinConfirmationScreenState extends State<PinConfirmationScreen> {
  String _enteredPin = '';
  bool _hasError = false;
  bool _isLoading = true;
  String? _correctPin;

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      _correctPin = snap.data()?['pin']?.toString();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _onNumberTap(String number) {
    if (_isLoading) return;
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += number;
        _hasError = false;
      });
      if (_enteredPin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _hasError = false;
      });
    }
  }

  void _verifyPin() {
    if (_correctPin == null) {
      // PIN belum diset, tolak
      setState(() {
        _hasError = true;
        _enteredPin = '';
      });
      return;
    }
    if (_enteredPin == _correctPin) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _hasError = true;
        _enteredPin = '';
      });
    }
  }

  Widget _buildNumberButton(String label) {
    return Expanded(
      child: TextButton(
        onPressed: label.isEmpty ? null : () => _onNumberTap(label),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0040A1)),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Icon(Icons.lock_outline, size: 48, color: Color(0xFF0040A1)),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      final filled = index < _enteredPin.length;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _hasError
                              ? Colors.red
                              : filled
                                  ? const Color(0xFF0040A1)
                                  : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),
                  if (_hasError) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'PIN salah. Coba lagi.',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 40),
                  Row(children: [_buildNumberButton('1'), _buildNumberButton('2'), _buildNumberButton('3')]),
                  Row(children: [_buildNumberButton('4'), _buildNumberButton('5'), _buildNumberButton('6')]),
                  Row(children: [_buildNumberButton('7'), _buildNumberButton('8'), _buildNumberButton('9')]),
                  Row(
                    children: [
                      _buildNumberButton(''),
                      _buildNumberButton('0'),
                      Expanded(
                        child: TextButton(
                          onPressed: _onBackspace,
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                          child: const Icon(Icons.backspace_outlined, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
