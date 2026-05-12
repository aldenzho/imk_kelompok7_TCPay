import 'package:flutter/material.dart';
import '/models/bank_account_model.dart';
import '/models/transaction_model.dart';
import '/state/app_state.dart';
import '/shared/transaction_receipt_screen.dart';

class WithdrawalSuccessScreen extends StatefulWidget {
  final BankAccount bankAccount;
  final double amount;

  static const double _adminFee = 6500;

  const WithdrawalSuccessScreen({
    super.key,
    required this.bankAccount,
    required this.amount,
  });

  @override
  State<WithdrawalSuccessScreen> createState() => _WithdrawalSuccessScreenState();
}

class _WithdrawalSuccessScreenState extends State<WithdrawalSuccessScreen> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final total = widget.amount + WithdrawalSuccessScreen._adminFee;
    AppState.instance.deductBalance(total);
    AppState.instance.addTransaction(TransactionModel(
      id: 'WDR-${now.millisecondsSinceEpoch}',
      title: 'Tarik Tunai ke ${widget.bankAccount.bankName}',
      subtitle: '${_timeLabel(now)} • PENARIKAN',
      amount: total,
      isDebit: true,
      dateTime: now,
      type: TransactionType.withdrawal,
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
    final refId = 'WDR${now.millisecondsSinceEpoch}';
    final tanggal =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return TransactionReceiptScreen(
      title: 'Penarikan Berhasil!',
      subtitle: 'Dana sedang diproses ke ${widget.bankAccount.bankName}',
      rows: [
        ReceiptRow(label: 'Bank Tujuan', value: widget.bankAccount.bankName),
        ReceiptRow(label: 'Nomor Rekening', value: widget.bankAccount.maskedNumber),
        ReceiptRow(label: 'Nama Pemilik', value: widget.bankAccount.accountHolder),
        ReceiptRow(label: 'Nominal', value: _formatRp(widget.amount)),
        ReceiptRow(label: 'Biaya Admin', value: _formatRp(WithdrawalSuccessScreen._adminFee)),
        ReceiptRow(label: 'Total Dipotong', value: _formatRp(widget.amount + WithdrawalSuccessScreen._adminFee), isBold: true),
        ReceiptRow(label: 'No. Referensi', value: refId),
        ReceiptRow(label: 'Tanggal', value: tanggal),
        ReceiptRow(label: 'Estimasi Dana Masuk', value: '1×24 jam kerja'),
      ],
      onDone: () => Navigator.popUntil(context, (route) => route.isFirst),
    );
  }
}
