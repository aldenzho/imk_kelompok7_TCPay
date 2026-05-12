import 'package:flutter/material.dart';
import '/models/tcpay_contact.dart';
import '/models/transaction_model.dart';
import '/state/app_state.dart';
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
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    AppState.instance.deductBalance(widget.amount);
    AppState.instance.addTransaction(TransactionModel(
      id: 'TXN-${now.millisecondsSinceEpoch}',
      title: 'Transfer ke ${widget.recipient.name}',
      subtitle:
          '${_timeLabel(now)} • TRANSFER KELUAR',
      amount: widget.amount,
      isDebit: true,
      dateTime: now,
      type: TransactionType.transferOut,
      note: widget.note.isEmpty ? null : widget.note,
      recipientName: widget.recipient.name,
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
