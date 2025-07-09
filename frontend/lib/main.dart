import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/brawl_stars_screen.dart';
import 'screens/clash_of_clans_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

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
      routes: {
        '/': (context) => const LoginScreen(), // <-- Added default route
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/brawl-stars': (context) => const BrawlStarsScreen(),
        '/clash-of-clans': (context) => const ClashOfClansScreen(),
      },
    );
  }
}
