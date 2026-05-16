import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> topUpBalance({
    required int amount,
    required String method,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final userRef = _firestore.collection('users').doc(user.uid);
    final transactionRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw Exception('Data user tidak ditemukan');
      }

      transaction.update(userRef, {
        'balance': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(transactionRef, {
        'id': transactionRef.id,
        'title': 'Isi Saldo',
        'subtitle': method,
        'amount': amount,
        'isDebit': false,
        'type': 'topUp',
        'method': method,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}