import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparkpay/controllers/auth_service.dart';
import 'package:sparkpay/firebase_options.dart';
import 'package:sparkpay/providers/user_provider.dart';
import 'package:sparkpay/views/aboutus.dart';
import 'package:sparkpay/views/account_details.dart';
import 'package:sparkpay/views/account_list.dart';
import 'package:sparkpay/views/add_card.dart';
import 'package:sparkpay/views/contact_us.dart';
import 'package:sparkpay/views/home.dart';
import 'package:sparkpay/views/home_nav.dart';
import 'package:sparkpay/views/info.dart';
import 'package:sparkpay/views/login.dart';
import 'package:sparkpay/views/profile.dart';
import 'package:sparkpay/views/request_money.dart';
import 'package:sparkpay/views/splash_screen.dart';
import 'package:sparkpay/views/transaction.dart';
import 'package:sparkpay/views/update_profile.dart';
import 'package:sparkpay/views/verify.dart';
import 'package:sparkpay/views/wallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MaterialApp(
          title: 'Spark pay',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 17, 70, 144)),
            useMaterial3: true,
          ),
          routes: {
            '/': (context) => SplashScreen(),
            '/checkuser': (context) => CheckUser(),
            '/wallet': (context) => Wallet(),
            '/login': (context) => Login(),
            '/verify': (context) => Verify(),
            '/info': (context) => Info(),
            '/home-nav': (context) => HomeNav(),
            '/home': (context) => Home(),
            '/profile': (context) => Profile(),
            '/transaction': (context) => Transaction(),
            '/add-card': (context) => AddCard(),
            '/update-profile': (context) => UpdateProfile(),
            '/about-us': (context) => Aboutus(),
            '/contact-us': (context) => ContactUs(),
            '/account-details': (context) => AccountDetails(),
            '/account-list': (context) => AccountList(),
            '/request': (context) => RequestMoney(),
          },
        ));
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushNamed(context, '/wallet');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
