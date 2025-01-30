import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset(
                  'assets/sparkpay_logo.webp',
                  width: 60,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Email us',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Contact us through customerservice@sparkpay.bh'),
              SizedBox(
                height: 30,
              ),
              Text(
                'Call us',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Our call center is available 24/7 +973 1111 1111'),
              SizedBox(
                height: 30,
              ),
              Text(
                'Social Media',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Get in touch through our social media channels'),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
