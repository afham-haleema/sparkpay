import 'package:flutter/material.dart';
import 'package:sparkpay/controllers/db_service.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Enter Account details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: accountNameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Name cant be null' : null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Text('Account Name')),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: ibanController,
                  validator: (value) =>
                      value!.isEmpty ? 'IBAN cant be null' : null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Text('IBAN Number')),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: nationalIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Text('National ID')),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> data = {
                          'accountname': accountNameController.text,
                          'iban': ibanController.text,
                          'nationalID': nationalIdController.text,
                          'bankname': args
                        };
                        if (formkey.currentState!.validate()) {
                          // to check in bank db if account exists

                          // bool isVerified = await DbService()
                          //     .verifyAccount(data['iban'], data['bankname']);
                          // if (isVerified) {
                          //   await DbService()
                          //       .createAccount(data: data)
                          //       .then((_) {
                          //     Navigator.pushNamedAndRemoveUntil(
                          //         context, '/home', (route) => false);
                          //   });
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //       content: Text(
                          //           'Account verification failed. Please check the IBAN or bank name.')));
                          // }

                          await DbService().createAccount(data: data).then((_) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          });
                        }
                      },
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 23, 50, 97),
                          foregroundColor: Colors.white),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
