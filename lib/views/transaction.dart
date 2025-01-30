import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sparkpay/controllers/db_service.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  double amount = 0;
  String? selectedRecipientAccountId;

  String? get senderAccountd => null;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      DbService().getAccountBalance(user!.uid).then((balance) {
        setState(() {
          amount = balance;
        });
      });
    }
  }

  void _showRecipientAccountSelectorForRecipient(
      DocumentSnapshot userDoc, List<DocumentSnapshot> accounts, String type) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true, // Ensure content doesn't get clipped
      builder: (
        context,
      ) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Recipient Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: accounts.map((account) {
                    var accountData = account.data() as Map<String, dynamic>;
                    return RadioListTile<String>(
                      title: Text(accountData['accountname']),
                      value: account.id,
                      groupValue: selectedRecipientAccountId,
                      onChanged: (value) {
                        setState(() {
                          selectedRecipientAccountId = value!;
                          print(
                              "Value: ${account.id}, GroupValue: $selectedRecipientAccountId");
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('cancel')),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRecipientAccountId != null) {
                        Navigator.pop(context);
                        print(
                            "Selected Account ID: $selectedRecipientAccountId");
                        type == 'fawri+'
                            ? _sendMoneyToAccount(
                                userDoc.id, selectedRecipientAccountId!)
                            : _RequestMoneyFromAccount(
                                userDoc.id, selectedRecipientAccountId!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please select an account')));
                      }
                    },
                    child: Text('Send'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 23, 50, 97),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _sendMoneyToAccount(String recipientId, String recipientAccountId) {
    try {
      DbService().sendMoney(user!.uid, recipientId, recipientAccountId,
          double.parse(amountController.text), descriptionController.text);
      Navigator.pushNamedAndRemoveUntil(context, '/home-nav', (route) => false);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().contains('Insufficient balance')
              ? 'Insufficient funds'
              : 'Transaction failed')));
    }
  }

  void _RequestMoneyFromAccount(
      String recipientId, String recipientAccountId) async {
    try {
      var senderaccounts = await DbService().getAccounts(user!.uid);
      var receiveraccounts = await DbService().getAccounts(recipientId);
      String senderAccountId =
          senderaccounts.isNotEmpty ? senderaccounts.first.id : '';
      String senderName =
          senderaccounts.isNotEmpty ? senderaccounts.first['accountname'] : '';
      String receiverName = receiveraccounts.isNotEmpty
          ? receiveraccounts.first['accountname']
          : '';
      if (recipientId == user!.uid) {
        throw Exception("Cannot send requests to yourself.");
      }
      if (senderName.isEmpty) {
        senderName = 'Unknown';
      }

      DbService().saveRequests(
          user!.uid,
          senderName,
          senderAccountId,
          recipientId,
          receiverName,
          recipientAccountId,
          double.parse(amountController.text),
          descriptionController.text);

      Navigator.pushNamedAndRemoveUntil(context, '/home-nav', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Money Request sent successfully')));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> confirmAccount(String phone, String type) async {
    var userDoc = await DbService().getUserByPhone(phone);

    if (userDoc != null) {
      var recipientAccounts = await DbService().getAccounts(userDoc.id);
      if (recipientAccounts.length > 1) {
        _showRecipientAccountSelectorForRecipient(
            userDoc, recipientAccounts, type);
      } else {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Confirm Receipient',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        type == 'fawri+'
                            ? 'Send to ${(userDoc.data() as Map<String, dynamic>)['name']}'
                            : 'Request from ${(userDoc.data() as Map<String, dynamic>)['name']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              )),
                          ElevatedButton(
                            onPressed: () {
                              type == 'fawri+'
                                  ? _sendMoneyToAccount(
                                      userDoc.id, recipientAccounts.first.id)
                                  : _RequestMoneyFromAccount(
                                      userDoc.id, recipientAccounts.first.id);
                            },
                            child: Text(
                              type == 'fawri+' ? 'Send' : 'Request',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 23, 50, 97),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String type = args['type'];
    selectedRecipientAccountId =
        args['selectedAccountId'] ?? selectedRecipientAccountId;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
        title: Text(
          type == 'fawri+' ? 'Send Fawri+' : 'Request Fawri+',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                      'Enter Receipient Info',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Number cant be null' : null,
                    decoration: InputDecoration(
                        prefix: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '+973',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Mobile')),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Amount cant be null' : null,
                    decoration: InputDecoration(
                        suffix: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'BHD',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Amount')),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Description')),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            if (type == 'fawri+') {
                              if (double.parse(amountController.text) >
                                  amount) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Insufficient Funds')));
                              } else {
                                confirmAccount(phoneController.text, type);
                              }
                            } else {
                              confirmAccount(phoneController.text, type);
                            }
                          }
                        },
                        child: Text('Next'),
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
      ),
    );
  }
}
