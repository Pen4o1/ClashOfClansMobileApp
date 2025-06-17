import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(ClashProgressApp());
}

class ClashProgressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clash Tracker',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';
  final String playerTag = '#2RR28G9J'; // Change to your test tag

  @override
  void initState() {
    super.initState();
    fetchPlayerData();
  }

  Future<void> fetchPlayerData() async {
    try {
      final data = await ApiService.getPlayer(playerTag);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clash Progress'),
      ),
      drawer: Drawer(
        child: userData != null
            ? ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userData!['name'], style: TextStyle(fontSize: 24)),
                        SizedBox(height: 10),
                        Text('Tag: ${userData!['tag']}'),
                        Text('Trophies: ${userData!['trophies']}'),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.shield),
                    title: Text('Troops'),
                    onTap: () {}, // To be implemented
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Achievements'),
                    onTap: () {},
                  ),
                ],
              )
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildStatCard('Town Hall Level',
                        userData!['townHallLevel'].toString(), Icons.location_city),
                    _buildStatCard(
                        'Experience Level', userData!['expLevel'].toString(), Icons.bar_chart),
                    _buildStatCard('Trophies', '${userData!['trophies']} 🏆', Icons.star),
                  ],
                ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(value, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
