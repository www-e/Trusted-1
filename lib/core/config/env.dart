// Environment Configuration - Single source of truth for all app configuration
// All environment-specific values are centralized here

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // API Configuration
  static String get baseUrl =>
      dotenv.get('API_BASE_URL', fallback: 'https://trusted-gamma.vercel.app/');

  static int get timeoutSeconds =>
      int.tryParse(dotenv.get('API_TIMEOUT_SECONDS', fallback: '10')) ?? 10;

  static int get maxRetries =>
      int.tryParse(dotenv.get('API_MAX_RETRIES', fallback: '2')) ?? 2;

  // Environment
  static String get environment =>
      dotenv.get('ENVIRONMENT', fallback: 'development');

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  // Security
  static bool get useCertificatePinning =>
      dotenv.get('USE_CERTIFICATE_PINNING', fallback: 'false') == 'true';

  // Token expiration margin (in seconds) - refresh token if expires within this time
  static const int tokenExpirationMargin = 300; // 5 minutes

  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyTokenExpiry = 'auth_token_expiry';
  static const String storageKeyUser = 'auth_user';
  static const String storageKeyDeviceId = 'device_id';

  // Validate configuration
  static void validate() {
    if (isProduction && baseUrl.startsWith('http://')) {
      throw Exception(
        'WARNING: Using HTTP in production is insecure. Please use HTTPS.',
      );
    }
  }
}
