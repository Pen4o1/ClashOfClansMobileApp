import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/storage_service.dart';
import '../config/app_config.dart';

// API configuration
const String apiBaseUrl = 'https://enabling-asp-vigorously.ngrok-free.app'; // Replace with your computer's IP address

class BrawlStarsScreen extends StatefulWidget {
  const BrawlStarsScreen({super.key});

  @override
  State<BrawlStarsScreen> createState() => _BrawlStarsScreenState();
}

class _BrawlStarsScreenState extends State<BrawlStarsScreen> {
  final TextEditingController _tagController = TextEditingController();
  String? _playerTag;
  bool _isLoading = false;
  Map<String, dynamic>? _playerStats;
  bool _sortDescending = true;

  @override
  void initState() {
    super.initState();
    _loadSavedStats();
  }

  Future<void> _loadSavedStats() async {
    final savedStats = await StorageService.getBrawStats();
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
        Uri.parse('${AppConfig.brawPlayerEndpoint}/$cleanTag'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _playerStats = data;
        });
        // Save the stats
        await StorageService.saveBrawStats(data);
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

  List<dynamic> _getSortedBrawlers() {
    if (_playerStats == null || _playerStats!['brawlers'] == null) {
      return [];
    }
    
    final brawlers = List<dynamic>.from(_playerStats!['brawlers']);
    brawlers.sort((a, b) {
      final aTrophies = a['trophies'] ?? 0;
      final bTrophies = b['trophies'] ?? 0;
      return _sortDescending 
          ? bTrophies.compareTo(aTrophies)
          : aTrophies.compareTo(bTrophies);
    });
    return brawlers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brawl Stars Stats'),
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
                  hintText: 'Enter your Brawl Stars player tag (e.g., YQLPGGYRJ)',
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
                  _buildInfoRow('Trophies', '${_playerStats!['trophies'] ?? 'N/A'} 🏆'),
                  _buildInfoRow('Highest Trophies', '${_playerStats!['highestTrophies'] ?? 'N/A'} 🏆'),
                  _buildInfoRow('Power Level', '${_playerStats!['powerLevel'] ?? 'N/A'} ⚡'),
                ]),
                const SizedBox(height: 16),
                if (_playerStats!['brawlers'] != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Brawlers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _sortDescending ? Icons.arrow_downward : Icons.arrow_upward,
                        ),
                        onPressed: () {
                          setState(() {
                            _sortDescending = !_sortDescending;
                          });
                        },
                        tooltip: _sortDescending ? 'Sort ascending' : 'Sort descending',
                      ),
                    ],
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: _getSortedBrawlers().map<Widget>((brawler) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        brawler['name'] ?? 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Power: ${brawler['power'] ?? 0}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${brawler['trophies'] ?? 0} 🏆',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
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