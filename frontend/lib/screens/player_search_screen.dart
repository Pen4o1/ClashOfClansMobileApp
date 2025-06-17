import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PlayerSearchScreen extends StatefulWidget {
  @override
  _PlayerSearchScreenState createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends State<PlayerSearchScreen> {
  final TextEditingController _tagController = TextEditingController();
  Map<String, dynamic>? playerData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _searchPlayer() async {
    if (_tagController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a player tag';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      playerData = null;
    });

    try {
      // Remove # if user included it
      String tag = _tagController.text.replaceAll('#', '');
      final data = await ApiService.getPlayer(tag);
      setState(() {
        playerData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
        playerData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Player'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: 'Player Tag',
                hintText: 'Enter player tag (e.g., 2RR28G9J)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _searchPlayer,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Search'),
            ),
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (playerData != null) ...[
              SizedBox(height: 24),
              _buildPlayerInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfo() {
    if (playerData == null) return SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playerData!['name'] ?? 'Unknown Player',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text('Tag: #${playerData!['tag'] ?? 'N/A'}'),
            Text('Town Hall Level: ${playerData!['townHallLevel'] ?? 'N/A'}'),
            Text('Experience Level: ${playerData!['expLevel'] ?? 'N/A'}'),
            Text('Trophies: ${playerData!['trophies'] ?? 'N/A'}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/player-details',
                  arguments: playerData,
                );
              },
              child: Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
} 