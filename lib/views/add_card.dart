import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparkpay/controllers/db_service.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select your Bank ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 23, 50, 97),
          foregroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: DbService().readBanks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> banks = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: banks.length,
                  itemBuilder: (context, index) {
                    var bankData = banks[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: bankData['image'] != null
                              ? Image.network(
                                  bankData['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image_not_supported),
                          onTap: () {
                            Navigator.pushNamed(context, '/account-details',
                                arguments: bankData['name']);
                          },
                          title: Text(
                            bankData['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Shimmer(
                  child: Container(
                    width: double.infinity,
                    height: 200,
                  ),
                  gradient: LinearGradient(
                      colors: [Colors.grey.shade200, Colors.white]));
            }
          },
        ));
  }
}
