import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/storage_service.dart';
import '../config/app_config.dart';

// API configuration
const String apiBaseUrl = 'https://enabling-asp-vigorously.ngrok-free.app'; // Replace with your computer's IP address

class ClashOfClansScreen extends StatefulWidget {
  const ClashOfClansScreen({super.key});

  @override
  State<ClashOfClansScreen> createState() => _ClashOfClansScreenState();
}

class _ClashOfClansScreenState extends State<ClashOfClansScreen> {
  final TextEditingController _tagController = TextEditingController();
  String? _playerTag;
  bool _isLoading = false;
  Map<String, dynamic>? _playerStats;

  @override
  void initState() {
    super.initState();
    _loadSavedStats();
  }

  Future<void> _loadSavedStats() async {
    final savedStats = await StorageService.getCocStats();
    if (savedStats != null) {
      setState(() {
        _playerStats = savedStats;
        _tagController.text = savedStats['tag'] ?? '';
      });
    }
  }

  Future<void> _fetchPlayerStats() async {
    if (_tagController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _playerTag = _tagController.text;
    });

    try {
      final cleanTag = _tagController.text.replaceAll('#', '');
      
      final response = await http.get(
        Uri.parse('${AppConfig.cocPlayerEndpoint}/$cleanTag'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _playerStats = data;
        });
        // Save the stats
        await StorageService.saveCocStats(data);
      } else if (response.statusCode == 404) {
        throw Exception('Player not found. Please check the tag and try again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clash of Clans Stats'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: 'Player Tag',
                  hintText: 'Enter your Clash of Clans player tag (e.g., #ABC123)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchPlayerStats,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text(_isLoading ? 'Loading...' : 'Fetch Stats'),
              ),
              const SizedBox(height: 24),
              if (_playerStats != null) ...[
                _buildInfoCard('Basic Info', [
                  _buildInfoRow('Tag', '#${_playerStats!['tag'] ?? 'N/A'}'),
                  _buildInfoRow('Town Hall', 'Level ${_playerStats!['townHallLevel'] ?? 'N/A'}'),
                  _buildInfoRow('Experience', 'Level ${_playerStats!['expLevel'] ?? 'N/A'}'),
                  _buildInfoRow('Trophies', '${_playerStats!['trophies'] ?? 'N/A'} 🏆'),
                  _buildInfoRow('Best Trophies', '${_playerStats!['bestTrophies'] ?? 'N/A'} 🏆'),
                  _buildInfoRow('War Stars', '${_playerStats!['warStars'] ?? 'N/A'} ⭐'),
                ]),
                const SizedBox(height: 16),
                if (_playerStats!['clan'] != null)
                  _buildInfoCard('Clan Info', [
                    _buildInfoRow('Name', _playerStats!['clan']['name'] ?? 'N/A'),
                    _buildInfoRow('Tag', '#${_playerStats!['clan']['tag'] ?? 'N/A'}'),
                    _buildInfoRow('Role', _playerStats!['clan']['role'] ?? 'Member'),
                  ]),
                const SizedBox(height: 16),
                if (_playerStats!['heroes'] != null)
                  _buildInfoCard('Heroes', [
                    ...(_playerStats!['heroes'] as List).map<Widget>((hero) =>
                      _buildInfoRow(
                        hero['name'] ?? 'Unknown',
                        'Level ${hero['level'] ?? 0}',
                      ),
                    ),
                  ]),
              ],
            ],
          ),
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