import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qris_pay_review_screen.dart';

class QrisPayAmountScreen extends StatefulWidget {
  final String merchantName;
  final String merchantId;

  const QrisPayAmountScreen({
    super.key,
    required this.merchantName,
    required this.merchantId,
  });

  @override
  State<QrisPayAmountScreen> createState() => _QrisPayAmountScreenState();
}

class _QrisPayAmountScreenState extends State<QrisPayAmountScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _errorText;
  double _balance = 0;

  static const List<int> _quickAmounts = [10000, 25000, 50000, 100000];

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (mounted) {
      setState(() => _balance = (snap.data()?['balance'] ?? 0).toDouble());
    }
  }

  String _formatRp(double val) {
    final str = val.toInt().toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _setQuick(int amount) {
    setState(() {
      _amountController.text = amount.toString();
      _errorText = null;
    });
  }

  String _formatQuick(int amount) {
    if (amount >= 1000000) return 'Rp ${amount ~/ 1000000}jt';
    return 'Rp ${amount ~/ 1000}rb';
  }

  void _onLanjutkan() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Masukkan nominal yang valid');
      return;
    }
    if (amount > _balance) {
      setState(() => _errorText = 'Saldo tidak mencukupi');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrisPayReviewScreen(
          merchantName: widget.merchantName,
          merchantId: widget.merchantId,
          amount: amount,
          note: _noteController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Bayar QRIS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Merchant card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFE9800).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.store, color: Color(0xFFFE9800), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.merchantName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified, color: Color(0xFF0040A1), size: 16),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'NMID: ${widget.merchantId}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Nominal Pembayaran',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _errorText != null ? Colors.red : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('Rp ',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0040A1))),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: '0',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onChanged: (_) => setState(() => _errorText = null),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 6),
                  Text(_errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
                const SizedBox(height: 6),
                Text(
                  'Saldo: ${_formatRp(_balance)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: _quickAmounts
                      .map((a) => ActionChip(
                            label: Text(_formatQuick(a)),
                            backgroundColor: const Color(0xFFFE9800).withValues(alpha: 0.1),
                            labelStyle: const TextStyle(color: Color(0xFFFE9800), fontWeight: FontWeight.w500),
                            onPressed: () => _setQuick(a),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),

                const Text('Catatan (opsional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Makan siang',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onLanjutkan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE9800),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
