import 'package:flutter/material.dart';

class PlayerDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? playerData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
        title: Text(playerData['name'] ?? 'Unknown Player'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Basic Info', [
              _buildInfoRow('Tag', '#${playerData['tag'] ?? 'N/A'}'),
              _buildInfoRow('Town Hall', 'Level ${playerData['townHallLevel'] ?? 'N/A'}'),
              _buildInfoRow('Experience', 'Level ${playerData['expLevel'] ?? 'N/A'}'),
              _buildInfoRow('Trophies', '${playerData['trophies'] ?? 'N/A'} 🏆'),
            ]),
            SizedBox(height: 16),
            if (playerData['clan'] != null)
              _buildInfoCard('Clan Info', [
                _buildInfoRow('Name', playerData['clan']['name'] ?? 'N/A'),
                _buildInfoRow('Tag', '#${playerData['clan']['tag'] ?? 'N/A'}'),
                _buildInfoRow('Role', playerData['clan']['role'] ?? 'N/A'),
              ]),
            SizedBox(height: 16),
            if (playerData['achievements'] != null)
              _buildInfoCard('Achievements', [
                ...(playerData['achievements'] as List).map<Widget>((achievement) =>
                    _buildInfoRow(
                      achievement['name'] ?? 'Unknown',
                      '${achievement['value'] ?? 0}/${achievement['target'] ?? 0}',
                    )),
              ]),
          ],
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