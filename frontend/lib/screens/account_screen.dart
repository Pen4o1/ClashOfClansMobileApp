import 'package:flutter/material.dart';
import 'brawl_stars_screen.dart';
import 'clash_of_clans_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BrawlStarsScreen(),
    const ClashOfClansScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Brawl Stars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.castle),
            label: 'Clash of Clans',
          ),
        ],
      ),
    );
  }
} 