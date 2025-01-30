import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparkpay/controllers/auth_service.dart';
import 'package:sparkpay/providers/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, value, child) {
                return Card(
                  child: ListTile(
                    title: Text(value.name),
                    subtitle: Text(value.email),
                    onTap: () {
                      Navigator.pushNamed(context, '/update-profile');
                    },
                    trailing: Icon(Icons.edit),
                  ),
                );
              },
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text('Accounts'),
              onTap: () {
                Navigator.pushNamed(context, '/account-list');
              },
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text('About SparkPay'),
              onTap: () {
                Navigator.pushNamed(context, '/about-us');
              },
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text('Contact us'),
              onTap: () {
                Navigator.pushNamed(context, '/contact-us');
              },
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
              onTap: () async {
                Provider.of<UserProvider>(context, listen: false)
                    .cancelprovider();
                await AuthService().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
