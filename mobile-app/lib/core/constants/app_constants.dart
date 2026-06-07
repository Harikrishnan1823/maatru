class AppConstants {
  // App Info
  static const String appName = 'Maatru';
  static const String appTagline = 'Speak yours. They hear theirs.';

  // Colors
  static const int primaryColor = 0xFFFF6B00;
  static const int navyColor = 0xFF1A3A5C;
  static const int tealColor = 0xFF0D7377;

  // Supported Languages
  static const List<Map<String, String>> languages = [
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்', 'flag': '🇮🇳'},
    {'code': 'en', 'name': 'English', 'native': 'English', 'flag': '🇬🇧'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'ml', 'name': 'Malayalam', 'native': 'മലയാളം', 'flag': '🇮🇳'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు', 'flag': '🇮🇳'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
  ];

  // Scenarios
  static const List<Map<String, dynamic>> scenarios = [
    {'id': 'hospital', 'name': 'Hospital', 'icon': '🏥', 'color': 0xFFD946EF}, // Pink/Purple
    {'id': 'travel', 'name': 'Travel', 'icon': '✈️', 'color': 0xFF3B82F6}, // Blue
    {'id': 'medicine', 'name': 'Medicine', 'icon': '💊', 'color': 0xFF10B981}, // Green
    {'id': 'emergency', 'name': 'Emergency', 'icon': '🚨', 'color': 0xFFEF4444}, // Red
    {'id': 'shopping', 'name': 'Shopping', 'icon': '🛒', 'color': 0xFFF59E0B}, // Orange
    {'id': 'daily', 'name': 'Daily', 'icon': '💬', 'color': 0xFF8B5CF6}, // Indigo
  ];

  // Quick Emergency Phrases
  static const List<Map<String, String>> emergencyPhrases = [
    {'id': 'help', 'text': 'Help me!'},
    {'id': 'doctor', 'text': 'Call a doctor'},
    {'id': 'chest', 'text': 'I have chest pain'},
    {'id': 'water', 'text': 'I need water'},
    {'id': 'ambulance', 'text': 'Call ambulance'},
    {'id': 'police', 'text': 'Call police'},
  ];

  // Hive Box Names
  static const String favouritesBox = 'favourites';
  static const String settingsBox = 'settings';
}