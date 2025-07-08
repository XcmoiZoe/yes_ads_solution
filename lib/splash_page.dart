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
    Timer(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? seen = prefs.getBool('seen');
      String? username = prefs.getString('user');

      if (username != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(username: username)));
      } else if (seen == null || !seen) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WelcomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Yes Ads Solution",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
