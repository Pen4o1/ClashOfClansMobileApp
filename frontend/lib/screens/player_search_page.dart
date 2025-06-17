import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/player_card.dart';

class PlayerSearchPage extends StatefulWidget {
  @override
  _PlayerSearchPageState createState() => _PlayerSearchPageState();
}

class _PlayerSearchPageState extends State<PlayerSearchPage> {
  final _tagController = TextEditingController();
  Map<String, dynamic>? _playerData;
  bool _isLoading = false;
  String? _error;

  void _searchPlayer() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _playerData = null;
    });

    try {
      final data = await ApiService.getPlayer(_tagController.text.trim());
      setState(() {
        _playerData = data;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clash Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: 'Enter Player Tag',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPlayer,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red))
            else if (_playerData != null)
              PlayerCard(playerData: _playerData!),
          ],
        ),
      ),
    );
  }
}
