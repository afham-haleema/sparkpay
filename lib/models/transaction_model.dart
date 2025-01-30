import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String fromAccount;
  final String toAccount;
  final double amount;
  final String currency;
  final String transactionId;
  final DateTime timestamp;
  TransactionModel({
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.currency,
    required this.transactionId,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json, id) {
    return TransactionModel(
      amount: json['amount'] ?? 0,
      fromAccount: json['fromAccount'] ?? '',
      toAccount: json['toAccount'] ?? '',
      currency: json['currency'] ?? '',
      timestamp: json['timestamp'] ?? '',
      transactionId: json['transactionId'] ?? '',
    );
  }

  static List<TransactionModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            TransactionModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
