class BankAccount {
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String logoInitials;
  final int logoColor;

  const BankAccount({
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.logoInitials,
    required this.logoColor,
  });

  String get maskedNumber =>
      '****${accountNumber.substring(accountNumber.length - 4)}';

  static const List<BankAccount> mockAccounts = [
    BankAccount(
      bankName: 'BCA',
      accountNumber: '1234567890',
      accountHolder: 'Abimanyu Danendra A.',
      logoInitials: 'BCA',
      logoColor: 0xFF003087,
    ),
    BankAccount(
      bankName: 'Mandiri',
      accountNumber: '0987654321',
      accountHolder: 'Abimanyu Danendra A.',
      logoInitials: 'MDR',
      logoColor: 0xFF0066AE,
    ),
    BankAccount(
      bankName: 'BRI',
      accountNumber: '1122334455',
      accountHolder: 'Abimanyu Danendra A.',
      logoInitials: 'BRI',
      logoColor: 0xFF00529B,
    ),
  ];

  static const List<String> allBankNames = [
    'BCA',
    'Mandiri',
    'BRI',
    'BNI',
    'CIMB Niaga',
    'Danamon',
    'Permata',
    'BTN',
    'Maybank',
    'OCBC',
  ];
}
