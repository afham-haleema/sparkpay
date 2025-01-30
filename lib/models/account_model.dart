import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  String accountName, id, iban, nationalID, balance;

  AccountModel(
      {required this.accountName,
      required this.iban,
      required this.id,
      required this.nationalID,
      required this.balance});

  factory AccountModel.fromJson(Map<String, dynamic> json, id) {
    return AccountModel(
        accountName: json['accountName'] ?? '',
        iban: json['iban'] ?? '',
        id: id ?? '',
        nationalID: json['nationalID'] ?? '',
        balance: json['balance'] ?? '');
  }
  static List<AccountModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            AccountModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
