import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/models/tcpay_contact.dart';
import '/state/app_state.dart';
import 'tcpay_review_screen.dart';

class TcPayAmountScreen extends StatefulWidget {
  final TcPayContact recipient;

  const TcPayAmountScreen({super.key, required this.recipient});

  @override
  State<TcPayAmountScreen> createState() => _TcPayAmountScreenState();
}

class _TcPayAmountScreenState extends State<TcPayAmountScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _errorText;

  static const List<int> _quickAmounts = [50000, 100000, 250000, 500000];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _setQuickAmount(int amount) {
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
    final raw = _amountController.text.replaceAll('.', '').trim();
    final amount = double.tryParse(raw);

    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Masukkan nominal yang valid');
      return;
    }
    if (amount > AppState.instance.balance) {
      setState(() => _errorText = 'Saldo tidak mencukupi');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TcPayReviewScreen(
          recipient: widget.recipient,
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
          'Jumlah Transfer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Recipient card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0040A1), Color(0xFF0056D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          widget.recipient.initials,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipient.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.recipient.tcpayId,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Amount input
                const Text(
                  'Nominal Transfer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                ),
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
                      const Text('Rp ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0040A1))),
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
                const SizedBox(height: 8),
                Text(
                  'Saldo: ${AppState.instance.formattedBalance}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Quick amounts
                Wrap(
                  spacing: 8,
                  children: _quickAmounts.map((amount) {
                    return ActionChip(
                      label: Text(_formatQuick(amount)),
                      backgroundColor: const Color(0xFF0040A1).withValues(alpha: 0.08),
                      labelStyle: const TextStyle(color: Color(0xFF0040A1), fontWeight: FontWeight.w500),
                      onPressed: () => _setQuickAmount(amount),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Note field
                const Text(
                  'Catatan (opsional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                ),
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
                      hintText: 'Contoh: Bayar makan siang',
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
