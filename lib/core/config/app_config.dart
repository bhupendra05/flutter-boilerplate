import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide configuration and initialization.
class AppConfig {
  AppConfig._();

  static late SharedPreferences _prefs;
  static SharedPreferences get prefs => _prefs;

  // Environment (set via --dart-define or .env with envied)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isProduction => appEnv == 'production';
  static bool get isDevelopment => appEnv == 'development';

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      debugPrint('AppConfig initialized — env: $appEnv, api: $apiBaseUrl');
    }
  }
}
