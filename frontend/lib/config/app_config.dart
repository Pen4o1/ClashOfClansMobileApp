class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://enabling-asp-vigorously.ngrok-free.app'; // ngrok tunnel URL
  
  // API Endpoints
  static String get cocPlayerEndpoint => '$apiBaseUrl/api/coc/player';
  static String get brawPlayerEndpoint => '$apiBaseUrl/api/braw/player';
  
  // Storage Keys
  static const String cocStatsKey = 'coc_player_stats';
  static const String brawStatsKey = 'braw_player_stats';
} 