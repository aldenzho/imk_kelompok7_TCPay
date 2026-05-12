import '/models/transaction_model.dart';

class AppState {
  static final AppState instance = AppState._internal();
  AppState._internal();

  double balance = 1234567.0;
  List<TransactionModel> transactions = TransactionModel.mockTransactions;

  void deductBalance(double amount) {
    balance -= amount;
    if (balance < 0) balance = 0;
  }

  void addTransaction(TransactionModel tx) {
    transactions = [tx, ...transactions];
  }

  String get formattedBalance {
    final intPart = balance.toInt();
    final str = intPart.toString();
    final result = StringBuffer('Rp ');
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result.write('.');
      result.write(str[i]);
    }
    return result.toString();
  }
}
