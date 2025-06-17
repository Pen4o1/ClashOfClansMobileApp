class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://192.168.100.229:3000'; // Replace with your computer's IP address
  
  // API Endpoints
  static String get cocPlayerEndpoint => '$apiBaseUrl/api/coc/player';
  static String get brawPlayerEndpoint => '$apiBaseUrl/api/braw/player';
  
  // Storage Keys
  static const String cocStatsKey = 'coc_player_stats';
  static const String brawStatsKey = 'braw_player_stats';
} 