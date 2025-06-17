import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final Map<String, dynamic> playerData;

  PlayerCard({required this.playerData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.shield),
        title: Text(playerData['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tag: ${playerData['tag']}'),
            Text('Town Hall Level: ${playerData['townHallLevel']}'),
            Text('Exp Level: ${playerData['expLevel']}'),
            Text('Trophies: ${playerData['trophies']}'),
          ],
        ),
      ),
    );
  }
}
