import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;
  Future saveUserdata(
      {required String name,
      required String email,
      required String walletPin,
      required String nationalID,
      required String phone}) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'walletPin': walletPin,
        'nationalID': nationalID,
        'phone': phone
      };
      await FirebaseFirestore.instance
          .collection('bank_users')
          .doc(user!.uid)
          .set(data);
    } catch (e) {
      print('Error on saving data ${e}');
    }
  }

  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection('bank_users')
        .doc(user!.uid)
        .update(extraData);
  }

  Stream<DocumentSnapshot> readUserdata() {
    return FirebaseFirestore.instance
        .collection('bank_users')
        .doc(user!.uid)
        .snapshots();
  }

  // To check banks db

  Future<bool> verifyAccount(String iban, String bankName) async {
    final uri = Uri.parse('https://mockbankapi.com/verify-account');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'iban': iban, 'bankName': bankName}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['isValid'] == true;
    } else {
      return false;
    }
  }

  Future createAccount({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection('bank_users')
        .doc(user!.uid)
        .collection('accounts')
        .add({
      'accountname': data['accountname'],
      'iban': data['iban'],
      'nationalID': data['nationalID'],
      'balance': 'BHD 100',
      'bankname': data['bankname']
    });
  }

  Future updateAccount(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection('bank_users')
        .doc(docId)
        .collection('accounts')
        .doc(user!.uid)
        .update(data);
  }

  Stream<QuerySnapshot> readAccount() {
    return FirebaseFirestore.instance
        .collection('bank_users')
        .doc(user!.uid)
        .collection('accounts')
        .snapshots();
  }

  Stream<QuerySnapshot> readBanks() {
    return FirebaseFirestore.instance.collection('banks').snapshots();
  }

  // Transactions
  Future<DocumentSnapshot?> getUserByPhone(String phone) async {
    var query = await FirebaseFirestore.instance
        .collection('bank_users')
        .where('phone', isEqualTo: phone)
        .get();
    return query.docs.isNotEmpty ? query.docs.first : null;
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> readTransactions() {
    return FirebaseFirestore.instance
        .collection('bank_users')
        .doc(user!.uid)
        .collection('accounts')
        .snapshots()
        .asyncMap((accountSnapshot) async {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> allTransactions = [];
      for (var account in accountSnapshot.docs) {
        var transactionSnapshot = await account.reference
            .collection('transactions')
            .orderBy('date', descending: true)
            .limit(15)
            .get();
        allTransactions.addAll(transactionSnapshot.docs);
      }
      return allTransactions;
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAccounts(
      String userId) async {
    var query = await FirebaseFirestore.instance
        .collection('bank_users')
        .doc(userId)
        .collection('accounts')
        .get();
    return query.docs;
  }

  // Account balance
  Future<double> getAccountBalance(String userId) async {
    try {
      var accountQuery = await FirebaseFirestore.instance
          .collection('bank_users')
          .doc(userId)
          .collection('accounts')
          .get();

      if (accountQuery.docs.isEmpty) {
        throw Exception("Account not found");
      }

      var accountSnapshot = accountQuery.docs.first;

      String balanceString = accountSnapshot['balance'];
      double balance = double.parse(balanceString.split(' ')[1]);

      return balance;
    } catch (e) {
      throw Exception('Error fetching account balance: $e');
    }
  }

  // SEND MONEY
  Future<void> sendMoney(
    String senderId,
    String receiverId,
    String receiverAccountId,
    double amount,
    String description,
  ) async {
    try {
      var senderAccountQuery = await FirebaseFirestore.instance
          .collection('bank_users')
          .doc(senderId)
          .collection('accounts')
          .get();
      var receiverAccountQuery = await FirebaseFirestore.instance
          .collection('bank_users')
          .doc(receiverId)
          .collection('accounts')
          .doc(receiverAccountId);

      if (senderAccountQuery.docs.isEmpty) {
        throw Exception("Account not found");
      }

      var senderAccount = senderAccountQuery.docs.first.reference;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        var senderSnapshot = await transaction.get(senderAccount);
        var receiverSnapshot = await transaction.get(receiverAccountQuery);
        double senderBalance =
            double.parse(senderSnapshot['balance'].split(' ')[1]);
        double receiverBalance =
            double.parse(receiverSnapshot['balance'].split(' ')[1]);

        if (senderBalance >= amount) {
          transaction.update(
              senderAccount, {'balance': 'BHD ${senderBalance - amount}'});
          transaction.update(receiverAccountQuery,
              {'balance': 'BHD ${receiverBalance + amount}'});
        } else {
          throw Exception("Insufficient balance");
        }

        var now = DateTime.now().toIso8601String();
        transaction.set(senderAccount.collection('transactions').doc(), {
          'amount': '-BHD $amount',
          'date': now,
          'description': description,
        });
        transaction.set(receiverAccountQuery.collection('transactions').doc(), {
          'amount': '+BHD $amount',
          'date': now,
          'description': description,
        });
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future saveRequests(
    String senderId,
    String senderName,
    String senderAccountId,
    String receiverId,
    String receiverName,
    String receiverAccountId,
    double amount,
    String description,
  ) async {
    // generate a request Id
    String requestId = Uuid().v4();
    try {
      Map<String, dynamic> data = {
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'senderAccountId': senderAccountId,
        'receiverAccountId': receiverAccountId,
        'amount': amount,
        'description': description,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'requestId': requestId,
      };
      await FirebaseFirestore.instance
          .collection('bank_users')
          .doc(senderId)
          .collection('accounts')
          .doc(senderAccountId)
          .collection('requests')
          .doc(requestId)
          .set(data);

      await FirebaseFirestore.instance
          .collection('bank_users')
          .doc(receiverId)
          .collection('accounts')
          .doc(receiverAccountId)
          .collection('requests')
          .doc(requestId)
          .set(data);
    } catch (e) {
      print('Error on saving Requests ${e}');
    }
  }

  Stream<QuerySnapshot> getRequests(String accountId) {
    return FirebaseFirestore.instance
        .collection('bank_users')
        .doc(user!.uid)
        .collection('accounts')
        .doc(accountId)
        .collection('requests')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }
}
