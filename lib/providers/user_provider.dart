import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparkpay/controllers/db_service.dart';
import 'package:sparkpay/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? userSubscription;
  String name = '';
  String email = '';
  String phone = '';
  String nationalID = '';
  String nationality = '';
  String dob = '';

  UserProvider() {
    loadUserdata();
  }

  void loadUserdata() {
    userSubscription?.cancel();
    userSubscription = DbService().readUserdata().listen((snapshot) {
      if (snapshot.data() != null) {
        final UserModel data =
            UserModel.fromjson(snapshot.data() as Map<String, dynamic>);
        name = data.name;
        email = data.email;
        phone = data.phone;
        nationalID = data.nationalID;
        nationality = data.nationality;
        dob = data.dob;
        notifyListeners();
      }
    });
  }

  void cancelprovider() {
    userSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelprovider();
    super.dispose();
  }
}
