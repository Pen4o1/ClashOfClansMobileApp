import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class StorageService {
  // Save Clash of Clans player stats
  static Future<void> saveCocStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.cocStatsKey, json.encode(stats));
  }

  // Get Clash of Clans player stats
  static Future<Map<String, dynamic>?> getCocStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsString = prefs.getString(AppConfig.cocStatsKey);
    if (statsString != null) {
      return json.decode(statsString) as Map<String, dynamic>;
    }
    return null;
  }

  // Save Brawl Stars player stats
  static Future<void> saveBrawStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.brawStatsKey, json.encode(stats));
  }

  // Get Brawl Stars player stats
  static Future<Map<String, dynamic>?> getBrawStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsString = prefs.getString(AppConfig.brawStatsKey);
    if (statsString != null) {
      return json.decode(statsString) as Map<String, dynamic>;
    }
    return null;
  }

  // Clear all saved stats
  static Future<void> clearAllStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.cocStatsKey);
    await prefs.remove(AppConfig.brawStatsKey);
  }
} 