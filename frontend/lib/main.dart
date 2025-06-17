import 'package:flutter/material.dart';
import 'screens/player_search_screen.dart';
import 'screens/player_details_screen.dart';

void main() {
  runApp(ClashProgressApp());
}

class ClashProgressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clash Tracker',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => PlayerSearchScreen(),
        '/player-details': (context) => PlayerDetailsScreen(),
      },
    );
  }
}
