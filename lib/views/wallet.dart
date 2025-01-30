import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparkpay/controllers/auth_service.dart';
import 'package:sparkpay/providers/user_provider.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
        title: Text(
          'wallet Pin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().logout();
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1.3,
                          blurRadius: 4,
                          offset: Offset(2, 2))
                    ]),
                child: Image.asset(
                  'assets/padlock.png',
                  width: 65,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildOtpTextField(val1, focusNode1, focusNode2),
                  SizedBox(
                    width: 10,
                  ),
                  buildOtpTextField(val2, focusNode2, focusNode3),
                  SizedBox(
                    width: 10,
                  ),
                  buildOtpTextField(val3, focusNode3, focusNode4),
                  SizedBox(
                    width: 10,
                  ),
                  buildOtpTextField(val4, focusNode4, focusNode5),
                  SizedBox(
                    width: 10,
                  ),
                  buildOtpTextField(val5, focusNode5, focusNode6),
                  SizedBox(
                    width: 10,
                  ),
                  buildOtpTextField(val6, focusNode6, null),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login',
                        arguments: 'Reset Wallet Pin');
                  },
                  child: Text('Forgot pin')),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: ElevatedButton(
                    onPressed: () async {
                      final walletPin = val1.text +
                          val2.text +
                          val3.text +
                          val4.text +
                          val5.text +
                          val6.text;
                      if (formkey.currentState!.validate()) {
                        if (await AuthService().getWalletPin() == walletPin) {
                          Provider.of<UserProvider>(context, listen: false)
                              .loadUserdata();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home-nav', (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Incorrect wallet pin')));
                        }
                      }
                    },
                    child: Text('Enter')),
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
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: controller.text.isNotEmpty
              ? Color.fromARGB(255, 23, 50, 97)
              : Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(50)),
      child: TextFormField(
        decoration: InputDecoration(border: InputBorder.none),
        obscureText: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w800,
            color: controller.text.isNotEmpty
                ? Color.fromARGB(255, 23, 50, 97)
                : Colors.white),
        controller: controller,
        focusNode: currentFocus,
        onChanged: (value) {
          setState(() {});
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
