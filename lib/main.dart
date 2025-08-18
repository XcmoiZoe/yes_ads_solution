import 'package:flutter/material.dart';
import 'splash_page.dart'; // Ensure this file exists
import 'main_page.dart';

void main() {
  runApp(const YesAdsSolutionApp());
}

class YesAdsSolutionApp extends StatelessWidget {
  const YesAdsSolutionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yes Ads Solution',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}
