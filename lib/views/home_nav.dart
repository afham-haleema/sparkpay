import 'package:flutter/material.dart';
import 'package:sparkpay/views/home.dart';
import 'package:sparkpay/views/request_money.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int selectedindex = 0;
  String? selectedAccountId;
  int pendingRequestCount = 0;
  List pages = [Home(), RequestMoney()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedindex,
          onTap: (value) {
            setState(() {
              selectedindex = value;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Color.fromARGB(255, 23, 50, 97),
          unselectedItemColor: Colors.grey.shade400,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.request_page,
                ),
                label: 'Requests')
          ]),
    );
  }
}
