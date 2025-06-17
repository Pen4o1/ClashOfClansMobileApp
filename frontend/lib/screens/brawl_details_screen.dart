import 'package:flutter/material.dart';
import '../services/brawl_api_service.dart';

class BrawlDetailsScreen extends StatefulWidget {
  @override
  _BrawlDetailsScreenState createState() => _BrawlDetailsScreenState();
}

class _BrawlDetailsScreenState extends State<BrawlDetailsScreen> {
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
      final data = await BrawlApiService.getPlayer(accountData['tag']);
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
                _buildInfoRow('Trophies', '${playerData!['trophies'] ?? 'N/A'} 🏆'),
                _buildInfoRow('Highest Trophies', '${playerData!['highestTrophies'] ?? 'N/A'} 🏆'),
                _buildInfoRow('Power Play Points', '${playerData!['powerPlayPoints'] ?? 'N/A'}'),
                _buildInfoRow('Experience Level', '${playerData!['expLevel'] ?? 'N/A'}'),
                _buildInfoRow('3v3 Victories', '${playerData!['3vs3Victories'] ?? 'N/A'}'),
                _buildInfoRow('Solo Victories', '${playerData!['soloVictories'] ?? 'N/A'}'),
                _buildInfoRow('Duo Victories', '${playerData!['duoVictories'] ?? 'N/A'}'),
              ]),
              SizedBox(height: 16),
              if (playerData!['club'] != null)
                _buildInfoCard('Club Info', [
                  _buildInfoRow('Name', playerData!['club']['name'] ?? 'N/A'),
                  _buildInfoRow('Tag', '#${playerData!['club']['tag'] ?? 'N/A'}'),
                  _buildInfoRow('Role', playerData!['club']['role'] ?? 'N/A'),
                ]),
              SizedBox(height: 16),
              if (playerData!['brawlers'] != null)
                _buildInfoCard('Brawlers', [
                  ...(playerData!['brawlers'] as List).map<Widget>((brawler) =>
                      _buildInfoRow(
                        brawler['name'] ?? 'Unknown',
                        'Power ${brawler['power'] ?? 0} | Trophies ${brawler['trophies'] ?? 0}',
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