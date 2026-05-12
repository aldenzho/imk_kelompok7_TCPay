enum TransactionType { transferOut, transferIn, withdrawal, qrisPayment }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final bool isDebit;
  final DateTime dateTime;
  final TransactionType type;
  final String? note;
  final String? recipientName;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    required this.dateTime,
    required this.type,
    this.note,
    this.recipientName,
  });

  String get formattedAmount {
    final prefix = isDebit ? '-' : '+';
    return '$prefix${_formatCurrency(amount)}';
  }

  static String _formatCurrency(double amount) {
    final parts = amount.toInt().toString().split('');
    final result = StringBuffer('Rp ');
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) result.write('.');
      result.write(parts[i]);
    }
    return result.toString();
  }

  static List<TransactionModel> get mockTransactions => [
        TransactionModel(
          id: 'TXN-001',
          title: 'Ayam Jamoer',
          subtitle: 'HARI INI, 12:45 • QRIS',
          amount: 12500,
          isDebit: true,
          dateTime: DateTime.now().subtract(const Duration(hours: 2)),
          type: TransactionType.qrisPayment,
        ),
        TransactionModel(
          id: 'TXN-002',
          title: 'Transfer dari Ayah',
          subtitle: 'KEMARIN, 10:15 • TRANSFER MASUK',
          amount: 500000000,
          isDebit: false,
          dateTime: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.transferIn,
          recipientName: 'Ayah',
        ),
        TransactionModel(
          id: 'TXN-003',
          title: 'Sakinah Keputih',
          subtitle: 'OCT 28, 10:25 • TRANSFER KELUAR',
          amount: 85000,
          isDebit: true,
          dateTime: DateTime.now().subtract(const Duration(days: 3)),
          type: TransactionType.transferOut,
          recipientName: 'Sakinah Keputih',
        ),
      ];
}
