import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class ApiService {
  // For iOS simulator, we use localhost
  static const String baseUrl = 'https://enabling-asp-vigorously.ngrok-free.app';

  static Future<Map<String, dynamic>> getPlayer(String tag) async {
    try {
      final encodedTag = Uri.encodeComponent(tag);
      final response = await http.get(Uri.parse('$baseUrl/api/player/$encodedTag'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to fetch player data: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      throw Exception('Network error: $e');
    }
  }
}
