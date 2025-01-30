import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About SparkPay',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About SparkPay Section
            Text(
              'About SparkPay',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'SparkPay is a modern digital wallet solution for Bahrain. It provides secure and efficient money transfer, bill payment, and wallet services. Users can link their bank accounts, make payments, and track their transactions all in one app.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            // Terms and Conditions Section
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '''1. Use of SparkPay services implies agreement to the terms of service. 
2. Users must ensure all personal and financial information provided is accurate.
3. SparkPay is not liable for errors due to incorrect data entry or unauthorized use of the user’s account.
4. Transactions may be subject to fees depending on your bank’s policies.
5. SparkPay reserves the right to modify these terms at any time without prior notice.''',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            // Privacy Policy Section
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '''1. SparkPay collects personal data, including name, email, phone number, and transaction details, to provide better services.
2. All user data is stored securely and will not be shared without explicit consent except as required by law.
3. SparkPay uses encryption to ensure the safety of your financial information.
4. Users can request deletion of their data by contacting support.''',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
