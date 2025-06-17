import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PlayerDetailsScreen extends StatefulWidget {
  @override
  _PlayerDetailsScreenState createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  Map<String, dynamic>? playerData;
  bool isLoading = true;
  String? errorMessage;
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _loadPlayerData();
    }
  }

  Future<void> _loadPlayerData() async {
    final Map<String, dynamic>? accountData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (accountData == null) {
      setState(() {
        errorMessage = 'No account data available';
        isLoading = false;
      });
      return;
    }

    try {
      final data = await ApiService.getPlayer(accountData['tag']);
      if (mounted) {
        setState(() {
          playerData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPlayerData,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (playerData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Player Details'),
        ),
        body: Center(
          child: Text('No player data available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(playerData!['name'] ?? 'Unknown Player'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPlayerData,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('Basic Info', [
                _buildInfoRow('Tag', '#${playerData!['tag'] ?? 'N/A'}'),
                _buildInfoRow('Town Hall', 'Level ${playerData!['townHallLevel'] ?? 'N/A'}'),
                _buildInfoRow('Experience', 'Level ${playerData!['expLevel'] ?? 'N/A'}'),
                _buildInfoRow('Trophies', '${playerData!['trophies'] ?? 'N/A'} 🏆'),
                _buildInfoRow('Best Trophies', '${playerData!['bestTrophies'] ?? 'N/A'} 🏆'),
                _buildInfoRow('War Stars', '${playerData!['warStars'] ?? 'N/A'} ⭐'),
                _buildInfoRow('Attack Wins', '${playerData!['attackWins'] ?? 'N/A'}'),
                _buildInfoRow('Defense Wins', '${playerData!['defenseWins'] ?? 'N/A'}'),
              ]),
              SizedBox(height: 16),
              if (playerData!['clan'] != null)
                _buildInfoCard('Clan Info', [
                  _buildInfoRow('Name', playerData!['clan']['name'] ?? 'N/A'),
                  _buildInfoRow('Tag', '#${playerData!['clan']['tag'] ?? 'N/A'}'),
                  _buildInfoRow('Role', playerData!['clan']['role'] ?? 'N/A'),
                ]),
              SizedBox(height: 16),
              if (playerData!['achievements'] != null)
                _buildInfoCard('Achievements', [
                  ...(playerData!['achievements'] as List).map<Widget>((achievement) =>
                      _buildInfoRow(
                        achievement['name'] ?? 'Unknown',
                        '${achievement['value'] ?? 0}/${achievement['target'] ?? 0}',
                      )),
                ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 