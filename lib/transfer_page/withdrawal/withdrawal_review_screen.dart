import 'package:flutter/material.dart';
import '/models/bank_account_model.dart';
import '/shared/pin_confirmation_screen.dart';
import 'withdrawal_success_screen.dart';

class WithdrawalReviewScreen extends StatelessWidget {
  final BankAccount bankAccount;
  final double amount;

  static const double _adminFee = 6500;

  const WithdrawalReviewScreen({
    super.key,
    required this.bankAccount,
    required this.amount,
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
          title: 'Konfirmasi Penarikan',
          subtitle: 'Masukkan PIN untuk mencairkan dana',
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawalSuccessScreen(
            bankAccount: bankAccount,
            amount: amount,
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
          'Konfirmasi Penarikan',
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
                    children: [
                      // From
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0040A1), Color(0xFF0056D2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dari', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              const Text('Saldo TCPay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const Text('Akun Akademik Utama', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0040A1).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_downward, color: Color(0xFF0040A1), size: 20),
                        ),
                      ),
                      // To
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Color(bankAccount.logoColor).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                bankAccount.logoInitials,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(bankAccount.logoColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Ke', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text(bankAccount.bankName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(
                                '${bankAccount.maskedNumber} • ${bankAccount.accountHolder}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _row('Nominal Penarikan', _formatRp(amount)),
                      const SizedBox(height: 10),
                      _row('Biaya Admin', _formatRp(_adminFee)),
                      const Divider(height: 24),
                      _row('Total Dipotong', _formatRp(amount + _adminFee), isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8ED),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.access_time, color: Color(0xFFFE9800), size: 18),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Dana akan masuk ke rekening dalam 1×24 jam hari kerja.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF8A5100)),
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
                  'Konfirmasi dengan PIN',
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
