// lib/login_screen/pin_login.dart
import 'package:flutter/material.dart';
import '/homepage/homepage.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  String _enteredPin = "";
  final String _correctPin = "123456";

  void _onNumberTap(String number) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += number;
      });
      // Auto-verify when 6 digits are entered
      if (_enteredPin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onDeleteTap() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _verifyPin() {
    if (_enteredPin.length == 6) {
      if (_enteredPin == _correctPin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN benar! Login berhasil.'), backgroundColor: Colors.green),
        );
        // Tunggu sebentar agar snackbar terlihat, lalu kembali
        Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN salah.'), backgroundColor: Colors.red),
        );
        setState(() => _enteredPin = "");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan PIN 6 digit')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Masukan PIN',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white, // AppBar putih
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87), // panah kembali hitam
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                const Text(
                  'Gunakan PIN Livin\' Anda',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                // Indikator 6 lingkaran
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index < _enteredPin.length
                            ? const Color(0xFF0040A1)
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Keypad angka
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['1', '2', '3'].map((number) => _buildNumberButton(number)).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['4', '5', '6'].map((number) => _buildNumberButton(number)).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['7', '8', '9'].map((number) => _buildNumberButton(number)).toList(),
              ),
              const SizedBox(height: 16),
              // Baris bawah: placeholder kiri, tombol 0, tombol backspace (semua Expanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(child: SizedBox()), // spasi kiri
                  _buildNumberButton('0'),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.backspace_outlined, size: 28),
                      onPressed: _onDeleteTap,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          const Spacer(),
          // Tombol Lupa
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur lupa PIN belum tersedia (demo)')),
                );
              },
              child: const Text(
                'Lupa?',
                style: TextStyle(fontSize: 16, color: Color(0xFF0040A1), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onNumberTap(number),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}