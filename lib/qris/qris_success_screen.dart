import 'package:flutter/material.dart';
import '/models/transaction_model.dart';
import '/state/app_state.dart';
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
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    AppState.instance.deductBalance(widget.amount);
    AppState.instance.addTransaction(TransactionModel(
      id: 'QRIS-${now.millisecondsSinceEpoch}',
      title: widget.merchantName,
      subtitle: '${_timeLabel(now)} • QRIS',
      amount: widget.amount,
      isDebit: true,
      dateTime: now,
      type: TransactionType.qrisPayment,
      note: widget.note.isEmpty ? null : widget.note,
    ));
  }

  String _timeLabel(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return 'HARI INI, $h:$m';
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
