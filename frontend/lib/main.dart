import 'package:flutter/material.dart';
import './screens/home_page.dart';
import './screens/about_page.dart'; // Make sure this file exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(   
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "This is a test for the app",
              style: TextStyle(color: Colors.white),
              ),
            ),
        ),
    );
  }
}
