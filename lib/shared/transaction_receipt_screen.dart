import 'package:flutter/material.dart';

class ReceiptRow {
  final String label;
  final String value;
  final bool isBold;

  const ReceiptRow({required this.label, required this.value, this.isBold = false});
}

class TransactionReceiptScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ReceiptRow> rows;
  final Color accentColor;
  final VoidCallback onDone;

  const TransactionReceiptScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.onDone,
    this.accentColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle, color: accentColor, size: 48),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0040A1)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 28),
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
                      children: rows.map((row) {
                        final isLast = row == rows.last;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    row.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Flexible(
                                    child: Text(
                                      row.value,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: row.isBold ? FontWeight.bold : FontWeight.w500,
                                        color: row.isBold ? const Color(0xFF0040A1) : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast) Divider(height: 1, color: Colors.grey.shade100),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0040A1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bukti transaksi sedang disiapkan...')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0040A1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'Bagikan Bukti',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF0040A1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
