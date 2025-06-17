import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator local host

  static Future<Map<String, dynamic>> getPlayer(String tag) async {
    final encodedTag = Uri.encodeComponent(tag);
    final response = await http.get(Uri.parse('$baseUrl/player/$encodedTag'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch player data');
    }
  }
}
