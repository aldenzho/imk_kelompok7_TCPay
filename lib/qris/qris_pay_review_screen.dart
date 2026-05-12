import 'package:flutter/material.dart';
import '/shared/pin_confirmation_screen.dart';
import 'qris_success_screen.dart';

class QrisPayReviewScreen extends StatelessWidget {
  final String merchantName;
  final String merchantId;
  final double amount;
  final String note;

  const QrisPayReviewScreen({
    super.key,
    required this.merchantName,
    required this.merchantId,
    required this.amount,
    required this.note,
  });

  String _formatRp(double val) {
    final str = val.toInt().toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  Future<void> _onConfirm(BuildContext context) async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const PinConfirmationScreen(
          title: 'Konfirmasi Pembayaran',
          subtitle: 'Masukkan PIN untuk membayar',
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QrisSuccessScreen(
            merchantName: merchantName,
            merchantId: merchantId,
            amount: amount,
            note: note,
          ),
        ),
      );
    }
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
          'Konfirmasi Pembayaran',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                        merchantName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified, color: Color(0xFF0040A1), size: 16),
                                  ],
                                ),
                                Text(
                                  'NMID: $merchantId',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28),
                      _row('Nominal', _formatRp(amount)),
                      const SizedBox(height: 10),
                      _row('Catatan', note.isEmpty ? '-' : note),
                      const SizedBox(height: 10),
                      _row('Biaya Transaksi', 'Gratis'),
                      const Divider(height: 24),
                      _row('Total Pembayaran', _formatRp(amount), isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Color(0xFF0040A1), size: 18),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Pembayaran QRIS dijamin aman oleh sistem TCPay.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF0040A1)),
                        ),
                      ),
                    ],
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
                onPressed: () => _onConfirm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE9800),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Bayar dengan PIN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFF0040A1) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
