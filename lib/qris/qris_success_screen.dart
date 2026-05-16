import 'package:flutter/material.dart';
import '/services/wallet_service.dart';
import '/shared/transaction_receipt_screen.dart';

class QrisSuccessScreen extends StatefulWidget {
  final String merchantName;
  final String merchantId;
  final double amount;
  final String note;

  const QrisSuccessScreen({
    super.key,
    required this.merchantName,
    required this.merchantId,
    required this.amount,
    required this.note,
  });

  @override
  State<QrisSuccessScreen> createState() => _QrisSuccessScreenState();
}

class _QrisSuccessScreenState extends State<QrisSuccessScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {
    try {
      await WalletService().qrisPayment(
        amount: widget.amount,
        merchantName: widget.merchantName,
        merchantId: widget.merchantId,
        note: widget.note,
      );
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Pembayaran Gagal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text('Kembali ke Beranda'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final refId = 'QRIS${now.millisecondsSinceEpoch}';
    final tanggal =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return TransactionReceiptScreen(
      title: 'Pembayaran Berhasil!',
      subtitle: 'Terima kasih telah membayar di ${widget.merchantName}',
      rows: [
        ReceiptRow(label: 'Merchant', value: widget.merchantName),
        ReceiptRow(label: 'NMID', value: widget.merchantId),
        ReceiptRow(label: 'Nominal', value: _formatRp(widget.amount), isBold: true),
        ReceiptRow(label: 'Catatan', value: widget.note.isEmpty ? '-' : widget.note),
        ReceiptRow(label: 'Biaya Transaksi', value: 'Gratis'),
        ReceiptRow(label: 'No. Referensi', value: refId),
        ReceiptRow(label: 'Tanggal', value: tanggal),
      ],
      onDone: () => Navigator.popUntil(context, (route) => route.isFirst),
    );
  }
}
