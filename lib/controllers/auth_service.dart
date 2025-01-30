import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sparkpay/controllers/db_service.dart';

class AuthService {
  Future<String> saveUserData(String name, String email, String walletPin,
      String nationalID, String phone) async {
    try {
      await DbService().saveUserdata(
          name: name,
          email: email,
          walletPin: walletPin,
          nationalID: nationalID,
          phone: phone);
      return 'data saved';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getWalletPin() async {
    try {
      DocumentSnapshot userdata = await DbService().readUserdata().first;
      return userdata['walletPin'];
    } catch (e) {
      print('Error fetching wallet pin ${e}');
    }
    ;
    return null;
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isLoggedIn() async {
    var user = await FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
