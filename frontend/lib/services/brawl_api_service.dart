import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class BrawlApiService {
  static Future<Map<String, dynamic>> getPlayer(String tag) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/brawl/players/$tag'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to fetch player data: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Failed to fetch player data: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getClubs(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/brawl/clubs?name=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch clubs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch clubs: $e');
    }
  }

  static Future<Map<String, dynamic>> getClubDetails(String tag) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/brawl/clubs/$tag'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch club details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch club details: $e');
    }
  }
} 