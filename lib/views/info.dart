import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparkpay/controllers/auth_service.dart';
import 'package:sparkpay/providers/user_provider.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController walletPinController = TextEditingController();
  TextEditingController nationalIDController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final phone = args['phone'];
    final resetwalletpin = args['resetwalletpin'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fill in the Details to continue',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Name cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter name',
                        labelText: 'Name'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) =>
                        value!.isEmpty ? 'Email cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter email',
                        labelText: 'Email'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nationalIDController,
                    validator: (value) =>
                        value!.isEmpty ? 'ID cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter CPR',
                        labelText: 'National ID'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: walletPinController,
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Pin cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Pin',
                        labelText: 'wallet Pin'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    initialValue: phone.toString(),
                    decoration: InputDecoration(
                        prefix: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '+973',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Enter phone',
                        labelText: 'Phone'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          final userDoc = await FirebaseFirestore.instance
                              .collection('bank_users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get();

                          if (userDoc.exists) {
                            if (resetwalletpin == 'Reset Wallet Pin') {
                              final data = userDoc.data();
                              if (data!['name'] == nameController.text &&
                                  data['email'] == emailController.text &&
                                  data['nationalID'] ==
                                      nationalIDController.text) {
                                await AuthService()
                                    .saveUserData(
                                        nameController.text,
                                        emailController.text,
                                        walletPinController.text,
                                        nationalIDController.text,
                                        phone.toString())
                                    .then((value) {
                                  if (value == 'data saved') {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .loadUserdata();
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/wallet', (route) => false);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        value,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red.shade400,
                                    ));
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Incorrect Details',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                ));
                              }
                            }
                          } else {
                            await AuthService()
                                .saveUserData(
                                    nameController.text,
                                    emailController.text,
                                    walletPinController.text,
                                    nationalIDController.text,
                                    phone.toString())
                                .then((value) {
                              if (value == 'data saved') {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .loadUserdata();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/wallet', (route) => false);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    value,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                ));
                              }
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Color.fromARGB(255, 23, 50, 97),
                          foregroundColor: Colors.white),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
