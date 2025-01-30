import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: Color.fromARGB(47, 54, 69, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formkey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/sparkpay_logo.webp',
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                          'Welcome to SparkPay',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.visible),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value!.length != 8 || value == '') {
                        return 'Phone number must be 8 characters long';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        hintText: 'Mobile number',
                        prefix: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            '+973',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.white,
                          checkColor: Color(0xFF173261),
                          value: checked,
                          onChanged: (value) => setState(() {
                                checked = value!;
                              })),
                      Expanded(
                          child: Text(
                        'I have read and agreed to the terms and conditions.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          if (checked && phoneController.text.length == 8) {
                            try {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: '+973' + phoneController.text,
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'error occured ${e.code}')));
                                  },
                                  codeSent: (String vid, int? token) {
                                    Navigator.pushNamed(context, '/verify',
                                        arguments: {
                                          'vid': vid,
                                          'phone': phoneController.text,
                                          'reset-pin': args
                                        });
                                  },
                                  codeAutoRetrievalTimeout: (vid) {});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Failed to send OTP')));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'You must accept the terms & conditions to continue')));
                          }
                        }
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                            color: Color.fromARGB(255, 23, 50, 97),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
