import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/brawl_stars_screen.dart';
import 'screens/clash_of_clans_screen.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const ClashProgressApp());
}

class ClashProgressApp extends StatelessWidget {
  const ClashProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Stats Tracker',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/brawl-stars': (context) => const BrawlStarsScreen(),
        '/clash-of-clans': (context) => const ClashOfClansScreen(),
      },
    );
  }
}
