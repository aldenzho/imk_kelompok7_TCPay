import 'package:flutter/material.dart';
import '/models/bank_account_model.dart';
import '/services/wallet_service.dart';
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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processWithdrawal();
  }

  Future<void> _processWithdrawal() async {
    try {
      await WalletService().withdrawalToBank(
        amount: widget.amount,
        bankName: widget.bankAccount.bankName,
        accountNumber: widget.bankAccount.maskedNumber,
        accountHolder: widget.bankAccount.accountHolder,
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
                  'Penarikan Gagal',
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
        ReceiptRow(
          label: 'Total Dipotong',
          value: _formatRp(widget.amount + WithdrawalSuccessScreen._adminFee),
          isBold: true,
        ),
        ReceiptRow(label: 'No. Referensi', value: refId),
        ReceiptRow(label: 'Tanggal', value: tanggal),
        ReceiptRow(label: 'Estimasi Dana Masuk', value: '1×24 jam kerja'),
      ],
      onDone: () => Navigator.popUntil(context, (route) => route.isFirst),
    );
  }
}
