import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparkpay/controllers/db_service.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accounts',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DbService().readAccount(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var accounts = snapshot.data!.docs;
            if (accounts.isEmpty) {
              return Center(
                child: Text('No accounts linked '),
              );
            }
            return ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  var bankData = accounts[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bankData['bankname'],
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                bankData['iban'],
                              )
                            ],
                          ),
                          Text(
                            bankData['accountname'],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text('No accounts linked '),
            );
          }
        },
      ),
    );
  }
}
