import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sparkpay/containers/request_container.dart';
import 'package:sparkpay/controllers/db_service.dart';

class RequestMoney extends StatefulWidget {
  //
  final String? selectedAccountId;
  //
  const RequestMoney({super.key, this.selectedAccountId});

  @override
  State<RequestMoney> createState() => _RequestMoneyState();
}

class _RequestMoneyState extends State<RequestMoney> {
  String accountId = '';

  @override
  void initState() {
    super.initState();
    _initializeAccountId();
  }

  Future<void> _initializeAccountId() async {
    var senderaccounts =
        await DbService().getAccounts(FirebaseAuth.instance.currentUser!.uid);

    if (senderaccounts.isNotEmpty) {
      setState(() {
        accountId = senderaccounts.first.id;
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
      ),
      body: accountId.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: DbService().getRequests(accountId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var requests = snapshot.data!.docs;
                            if (requests.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Requests',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              );
                            }
                            return Column(
                                children: requests.map((doc) {
                              var requestdata =
                                  doc.data() as Map<String, dynamic>;
                              Timestamp timestamp = requestdata['timestamp'];
                              DateTime date = timestamp.toDate();

                              String formattedDate =
                                  '${date.day}/${date.month}/${date.year}';

                              return RequestContainer(
                                  amount: requestdata['amount'],
                                  date: formattedDate,
                                  name: requestdata['receiverName'] ?? '',
                                  description: requestdata['description'] ?? '',
                                  status: requestdata['status'] ?? 'pending',
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  receiverId: requestdata['receiverId'],
                                  onYes: () async {
                                    FirebaseFirestore.instance
                                        .collection('bank_users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('accounts')
                                        .doc(accountId)
                                        .collection('requests')
                                        .doc(requestdata['requestId'])
                                        .update({'status': 'approved'});

                                    await FirebaseFirestore.instance
                                        .collection('bank_users')
                                        .doc(requestdata['senderId'])
                                        .collection('accounts')
                                        .doc(requestdata['senderAccountId'])
                                        .collection('requests')
                                        .doc(requestdata['requestId'])
                                        .update({'status': 'approved'});

                                    // Call sendMoney function
                                    DbService().sendMoney(
                                        requestdata['receiverId'],
                                        requestdata['senderId'],
                                        requestdata['senderAccountId'],
                                        requestdata['amount'],
                                        requestdata['description']);
                                    print('Money transferred successfully');
                                  },
                                  onNo: () async {
                                    await FirebaseFirestore.instance
                                        .collection('bank_users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('accounts')
                                        .doc(accountId)
                                        .collection('requests')
                                        .doc(requestdata['requestId'])
                                        .update({'status': 'cancelled'});

                                    await FirebaseFirestore.instance
                                        .collection('bank_users')
                                        .doc(requestdata['senderId'])
                                        .collection('accounts')
                                        .doc(requestdata['senderAccountId'])
                                        .collection('requests')
                                        .doc(requestdata['requestId'])
                                        .update({'status': 'cancelled'});
                                  });
                            }).toList());
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
