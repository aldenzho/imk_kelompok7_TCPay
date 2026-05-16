import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/models/tcpay_contact.dart';
import '/shared/pin_confirmation_screen.dart';
import 'tcpay_success_screen.dart';

class TcPayReviewScreen extends StatelessWidget {
  final TcPayContact recipient;
  final double amount;
  final String note;

  const TcPayReviewScreen({
    super.key,
    required this.recipient,
    required this.amount,
    required this.note,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return 'U';
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

  Future<void> _onConfirm(BuildContext context) async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const PinConfirmationScreen(
          title: 'Konfirmasi Transfer',
          subtitle: 'Masukkan PIN untuk mengirim dana',
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TcPaySuccessScreen(
            recipient: recipient,
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
          'Konfirmasi Transfer',
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
                      // Sender
                      _buildPartyRow(
                        label: 'Dari',
                        name: FirebaseAuth.instance.currentUser?.displayName ?? 'Pengguna TCPay',
                        detail: 'Akun TCPay Saya',
                        initials: _getInitials(FirebaseAuth.instance.currentUser?.displayName ?? 'U'),
                        isBlue: false,
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
                      // Recipient
                      _buildPartyRow(
                        label: 'Ke',
                        name: recipient.name,
                        detail: recipient.tcpayId,
                        initials: recipient.initials,
                        isBlue: true,
                      ),
                      const Divider(height: 32),
                      _buildDetailRow('Nominal', _formatRp(amount)),
                      const SizedBox(height: 10),
                      _buildDetailRow('Catatan', note.isEmpty ? '-' : note),
                      const SizedBox(height: 10),
                      _buildDetailRow('Biaya Admin', 'Gratis'),
                      const Divider(height: 24),
                      _buildDetailRow('Total', _formatRp(amount), isBold: true),
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
                      Icon(Icons.info_outline, color: Color(0xFF0040A1), size: 18),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Transfer sesama TCPay gratis & langsung masuk dalam hitungan detik.',
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

  Widget _buildPartyRow({
    required String label,
    required String name,
    required String detail,
    required String initials,
    required bool isBlue,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: isBlue
              ? const Color(0xFF0040A1)
              : Colors.grey.shade200,
          child: Text(
            initials,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBlue ? Colors.white : Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(detail, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
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
