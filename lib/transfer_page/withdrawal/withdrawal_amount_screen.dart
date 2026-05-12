import 'package:flutter/material.dart';
import '/models/bank_account_model.dart';
import '/state/app_state.dart';
import '/shared/thousands_formatter.dart';
import 'withdrawal_review_screen.dart';

class WithdrawalAmountScreen extends StatefulWidget {
  final BankAccount bankAccount;

  const WithdrawalAmountScreen({super.key, required this.bankAccount});

  @override
  State<WithdrawalAmountScreen> createState() => _WithdrawalAmountScreenState();
}

class _WithdrawalAmountScreenState extends State<WithdrawalAmountScreen> {
  final _amountController = TextEditingController();
  String? _errorText;

  static const double _adminFee = 6500;
  static const List<int> _quickAmounts = [100000, 250000, 500000, 1000000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setQuickAmount(int amount) {
    setState(() {
      _amountController.text = ThousandsSeparatorFormatter.format(amount);
      _errorText = null;
    });
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

  String _formatQuick(int amount) {
    if (amount >= 1000000) return 'Rp ${amount ~/ 1000000}jt';
    return 'Rp ${amount ~/ 1000}rb';
  }

  void _onLanjutkan() {
    final raw = _amountController.text.replaceAll('.', '').trim();
    final amount = double.tryParse(raw);

    if (amount == null || amount < 50000) {
      setState(() => _errorText = 'Minimal penarikan Rp 50.000');
      return;
    }
    if (amount + _adminFee > AppState.instance.balance) {
      setState(() => _errorText = 'Saldo tidak mencukupi (termasuk biaya admin)');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WithdrawalReviewScreen(
          bankAccount: widget.bankAccount,
          amount: amount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawAmount = double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;
    final total = rawAmount + _adminFee;

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
          'Jumlah Penarikan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Bank card
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(widget.bankAccount.logoColor).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            widget.bankAccount.logoInitials,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(widget.bankAccount.logoColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.bankAccount.bankName,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '${widget.bankAccount.maskedNumber} • ${widget.bankAccount.accountHolder}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Nominal Penarikan',
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
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0040A1))),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [ThousandsSeparatorFormatter()],
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
                  'Saldo: ${AppState.instance.formattedBalance} • Min. Rp 50.000',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: _quickAmounts.map((a) {
                    return ActionChip(
                      label: Text(_formatQuick(a)),
                      backgroundColor: const Color(0xFF0040A1).withValues(alpha: 0.08),
                      labelStyle: const TextStyle(color: Color(0xFF0040A1), fontWeight: FontWeight.w500),
                      onPressed: () => _setQuickAmount(a),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFE9800).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      _feeRow('Nominal Penarikan', rawAmount > 0 ? _formatRp(rawAmount) : '-'),
                      const Divider(height: 16),
                      _feeRow('Biaya Admin', _formatRp(_adminFee)),
                      const Divider(height: 16),
                      _feeRow('Total Dipotong', rawAmount > 0 ? _formatRp(total) : '-', isBold: true),
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

  Widget _feeRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFFFE9800) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
