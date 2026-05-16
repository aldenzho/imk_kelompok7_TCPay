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
    if (user == null) throw Exception('User belum login');

    final userRef = _firestore.collection('users').doc(user.uid);
    final transactionRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(userRef);
      if (!snap.exists) throw Exception('Data user tidak ditemukan');

      txn.update(userRef, {
        'balance': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      txn.set(transactionRef, {
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

  Future<void> transferToUser({
    required String recipientTcpayId,
    required String recipientName,
    required double amount,
    required String note,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    final senderRef = _firestore.collection('users').doc(user.uid);
    final senderTxRef = senderRef.collection('transactions').doc();

    // Cari penerima berdasarkan tcpayId
    final recipientQuery = await _firestore
        .collection('users')
        .where('tcpayId', isEqualTo: recipientTcpayId)
        .limit(1)
        .get();

    await _firestore.runTransaction((txn) async {
      final senderSnap = await txn.get(senderRef);
      if (!senderSnap.exists) throw Exception('Data pengirim tidak ditemukan');

      final currentBalance = (senderSnap.data()?['balance'] ?? 0).toDouble();
      if (currentBalance < amount) throw Exception('Saldo tidak mencukupi');

      // Kurangi saldo pengirim
      txn.update(senderRef, {
        'balance': FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Catat transaksi pengirim
      txn.set(senderTxRef, {
        'id': senderTxRef.id,
        'title': 'Transfer ke $recipientName',
        'subtitle': recipientTcpayId,
        'amount': amount,
        'isDebit': true,
        'type': 'transferOut',
        'note': note,
        'recipientName': recipientName,
        'recipientTcpayId': recipientTcpayId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Tambah saldo & catat transaksi penerima jika ada di Firestore
      if (recipientQuery.docs.isNotEmpty) {
        final recipientRef = recipientQuery.docs.first.reference;
        final recipientTxRef = recipientRef.collection('transactions').doc();

        final senderData = senderSnap.data();
        final senderName = senderData?['name'] ?? 'Pengguna TCPay';

        txn.update(recipientRef, {
          'balance': FieldValue.increment(amount),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        txn.set(recipientTxRef, {
          'id': recipientTxRef.id,
          'title': 'Terima dari $senderName',
          'subtitle': 'Transfer masuk',
          'amount': amount,
          'isDebit': false,
          'type': 'transferIn',
          'note': note,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Future<void> withdrawalToBank({
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    const adminFee = 6500.0;
    final total = amount + adminFee;

    final userRef = _firestore.collection('users').doc(user.uid);
    final txRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(userRef);
      if (!snap.exists) throw Exception('Data user tidak ditemukan');

      final currentBalance = (snap.data()?['balance'] ?? 0).toDouble();
      if (currentBalance < total) throw Exception('Saldo tidak mencukupi');

      txn.update(userRef, {
        'balance': FieldValue.increment(-total),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      txn.set(txRef, {
        'id': txRef.id,
        'title': 'Tarik Tunai ke $bankName',
        'subtitle': 'Penarikan • $accountNumber',
        'amount': total,
        'isDebit': true,
        'type': 'withdrawal',
        'bankName': bankName,
        'accountNumber': accountNumber,
        'accountHolder': accountHolder,
        'adminFee': adminFee,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> qrisPayment({
    required double amount,
    required String merchantName,
    required String merchantId,
    required String note,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    final userRef = _firestore.collection('users').doc(user.uid);
    final txRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(userRef);
      if (!snap.exists) throw Exception('Data user tidak ditemukan');

      final currentBalance = (snap.data()?['balance'] ?? 0).toDouble();
      if (currentBalance < amount) throw Exception('Saldo tidak mencukupi');

      txn.update(userRef, {
        'balance': FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      txn.set(txRef, {
        'id': txRef.id,
        'title': merchantName,
        'subtitle': 'QRIS • $merchantId',
        'amount': amount,
        'isDebit': true,
        'type': 'qrisPayment',
        'merchantName': merchantName,
        'merchantId': merchantId,
        'note': note,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> genericPayment({
    required double amount,
    required String title,
    required String subtitle,
    required String type,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    final userRef = _firestore.collection('users').doc(user.uid);
    final txRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(userRef);
      if (!snap.exists) throw Exception('Data user tidak ditemukan');

      final currentBalance = (snap.data()?['balance'] ?? 0).toDouble();
      if (currentBalance < amount) throw Exception('Saldo tidak mencukupi');

      txn.update(userRef, {
        'balance': FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      txn.set(txRef, {
        'id': txRef.id,
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'isDebit': true,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> campusPayment({
    required double amount,
    required String semester,
    required String description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User belum login');

    final userRef = _firestore.collection('users').doc(user.uid);
    final txRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(userRef);
      if (!snap.exists) throw Exception('Data user tidak ditemukan');

      final currentBalance = (snap.data()?['balance'] ?? 0).toDouble();
      if (currentBalance < amount) throw Exception('Saldo tidak mencukupi');

      txn.update(userRef, {
        'balance': FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      txn.set(txRef, {
        'id': txRef.id,
        'title': 'Pembayaran UKT',
        'subtitle': 'Campus Pay • $semester',
        'amount': amount,
        'isDebit': true,
        'type': 'campusPayment',
        'semester': semester,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
