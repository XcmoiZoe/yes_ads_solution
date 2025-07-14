import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_page.dart';
import 'auth_page.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

Future<void> _checkAuthStatus() async {
  await Future.delayed(Duration(seconds: 2)); // simulate loading

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? seen = prefs.getBool('seen');
  String? username = prefs.getString('user');
  String? email = prefs.getString('email'); // ✅ retrieve email

  if (username != null && username.isNotEmpty && email != null && email.isNotEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          username: username,
          email: email, // ✅ pass email
        ),
      ),
    );
  } else if (seen == null || !seen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WelcomePage()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AuthPage()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 180,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Logo not found',
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }
}
