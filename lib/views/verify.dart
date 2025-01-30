import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController val1 = TextEditingController();
  TextEditingController val2 = TextEditingController();
  TextEditingController val3 = TextEditingController();
  TextEditingController val4 = TextEditingController();
  TextEditingController val5 = TextEditingController();
  TextEditingController val6 = TextEditingController();
  final formkey = GlobalKey<FormState>();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();

    super.dispose();
  }

  late String vid;
  late String phone;
  late String walletpin;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // if (args != null && args is Map<String, dynamic>) {
    vid = args['vid'] ?? '';
    phone = args['phone'] ?? '';
    walletpin = args['reset-pin'] ?? '';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
        title: Text(
          'Activation Code',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Verify your number',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Enter 6 digit code sent to your number'),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildOtpTextField(val1, focusNode1, focusNode2),
                  buildOtpTextField(val2, focusNode2, focusNode3),
                  buildOtpTextField(val3, focusNode3, focusNode4),
                  buildOtpTextField(val4, focusNode4, focusNode5),
                  buildOtpTextField(val5, focusNode5, focusNode6),
                  buildOtpTextField(val6, focusNode6, null),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Didnt get code ?'),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Resend code',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    final otp = val1.text +
                        val2.text +
                        val3.text +
                        val4.text +
                        val5.text +
                        val6.text;
                    if (otp.length == 6) {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: vid, smsCode: otp);
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) async {
                          final userDoc = await FirebaseFirestore.instance
                              .collection('bank_users')
                              .doc(value.user!.uid)
                              .get();

                          if (userDoc.exists) {
                            if (walletpin == 'Reset Wallet Pin') {
                              Navigator.pushNamed(context, '/info', arguments: {
                                'phone': phone,
                                'resetwalletpin': walletpin
                              });
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/wallet', (route) => false);
                            }
                          } else {
                            Navigator.pushNamed(context, '/info',
                                arguments: phone);
                          }
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to verify OTP ${e}')));
                      }
                    }
                  },
                  child: Text(
                    'Verify',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 23, 50, 97)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpTextField(TextEditingController controller,
      FocusNode currentFocus, FocusNode? nextFocus) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: TextFormField(
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        controller: controller,
        focusNode: currentFocus,
        onChanged: (value) {
          if (value.length == 1 && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        textInputAction:
            nextFocus != null ? TextInputAction.next : TextInputAction.done,
        keyboardType: TextInputType.number,
      ),
    );
  }
}
