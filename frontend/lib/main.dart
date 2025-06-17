import 'package:flutter/material.dart';
import 'screens/player_search_screen.dart';
import 'screens/player_details_screen.dart';
import 'screens/accounts_screen.dart';
import 'screens/brawl_details_screen.dart';

void main() {
  runApp(ClashProgressApp());
}

class ClashProgressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tracker',
      theme: ThemeData.dark(),
      initialRoute: '/accounts',
      routes: {
        '/accounts': (context) => AccountsScreen(),
        '/search': (context) => PlayerSearchScreen(),
        '/player-details': (context) => PlayerDetailsScreen(),
        '/brawl-details': (context) => BrawlDetailsScreen(),
      },
    );
  }
}
