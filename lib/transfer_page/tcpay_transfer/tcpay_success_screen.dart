import 'package:flutter/material.dart';
import '/models/tcpay_contact.dart';
import '/services/wallet_service.dart';
import '/shared/transaction_receipt_screen.dart';

class TcPaySuccessScreen extends StatefulWidget {
  final TcPayContact recipient;
  final double amount;
  final String note;

  const TcPaySuccessScreen({
    super.key,
    required this.recipient,
    required this.amount,
    required this.note,
  });

  @override
  State<TcPaySuccessScreen> createState() => _TcPaySuccessScreenState();
}

class _TcPaySuccessScreenState extends State<TcPaySuccessScreen> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processTransfer();
  }

  Future<void> _processTransfer() async {
    try {
      await WalletService().transferToUser(
        recipientTcpayId: widget.recipient.tcpayId,
        recipientName: widget.recipient.name,
        amount: widget.amount,
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
                Text(
                  'Transfer Gagal',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    final refId = 'TCPAY${now.millisecondsSinceEpoch}';
    final tanggal =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return TransactionReceiptScreen(
      title: 'Transfer Berhasil!',
      subtitle: 'Dana telah dikirim ke ${widget.recipient.name}',
      rows: [
        ReceiptRow(label: 'Penerima', value: widget.recipient.name),
        ReceiptRow(label: 'TCPay ID', value: widget.recipient.tcpayId),
        ReceiptRow(label: 'Nominal', value: _formatRp(widget.amount), isBold: true),
        ReceiptRow(label: 'Catatan', value: widget.note.isEmpty ? '-' : widget.note),
        ReceiptRow(label: 'Biaya Admin', value: 'Gratis'),
        ReceiptRow(label: 'No. Referensi', value: refId),
        ReceiptRow(label: 'Tanggal', value: tanggal),
      ],
      onDone: () => Navigator.popUntil(context, (route) => route.isFirst),
    );
  }
}
