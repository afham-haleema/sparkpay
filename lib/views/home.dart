import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sparkpay/containers/add_card_container.dart';
import 'package:sparkpay/containers/card_container.dart';
import 'package:sparkpay/containers/services_container.dart';
import 'package:sparkpay/containers/transaction_container.dart';
import 'package:sparkpay/controllers/db_service.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CarouselSliderController _carouselController = CarouselSliderController();
  int currentIndex = 0;
  String? selectedAccountId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to SparkPay',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-card');
              },
              icon: Icon(
                Icons.add,
                size: 35,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: Icon(
                Icons.account_circle,
                size: 35,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: DbService().readAccount(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var accounts = snapshot.data!.docs;
                    if (accounts.isEmpty) {
                      return AddCardContainer();
                    }
                    List<Widget> accountcards = accounts.map((e) {
                      var accountData = e.data() as Map<String, dynamic>;
                      return CardContainer(accountData: accountData);
                    }).toList();
                    return Column(
                      children: [
                        CarouselSlider(
                            items: accountcards,
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              height: 180,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                  selectedAccountId = accounts[index].id;
                                  print(
                                      'selectedAccountId ${selectedAccountId}');
                                });
                              },
                            )),
                      ],
                    );
                  } else {
                    return AddCardContainer();
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Services',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ServicesContainer(
                      text: 'Fawri+',
                      onTap: () {
                        Navigator.pushNamed(context, '/transaction',
                            arguments: {
                              'type': 'fawri+',
                              'selectedAccountId': selectedAccountId
                            });
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    ServicesContainer(
                      text: 'Request Money',
                      onTap: () {
                        Navigator.pushNamed(context, '/transaction',
                            arguments: {
                              'type': 'request money',
                              'selectedAccountId': selectedAccountId
                            });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Recent Transactions',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                  stream: DbService().readTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var transactions = snapshot.data!;
                      if (transactions.isEmpty) {
                        return Center(
                          child: Text(
                            'No Transactions',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        );
                      }
                      return Column(
                          children: transactions.map((doc) {
                        var transactiondata = doc.data();
                        return TransactionContainer(
                            amount: transactiondata['amount'],
                            date: transactiondata['date'],
                            name: transactiondata['description']);
                      }).toList());
                    } else {
                      return CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
