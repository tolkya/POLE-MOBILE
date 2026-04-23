// lib/config/environment.dart
class Environment {
  // In this project we simulate production with your current ngrok domain.
  // Build-time override remains available with --dart-define-from-file.
  static const String _defaultBaseUrl =
      'https://uneffectuated-immovably-jair.ngrok-free.dev/api';

  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  static const String _rawBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static String get baseUrl => _normalizeBaseUrl(_rawBaseUrl);

  static bool get isProduction => appEnv == 'production';

  static void validate() {
    final trimmed = _rawBaseUrl.trim();
    if (trimmed.isEmpty) {
      throw StateError('API_BASE_URL is empty. Provide a valid HTTPS URL.');
    }

    final uri = Uri.tryParse(baseUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw StateError('API_BASE_URL is invalid: $trimmed');
    }

    if (uri.scheme != 'https') {
      throw StateError(
        'API_BASE_URL must use HTTPS for production safety. Received: ${uri.scheme}',
      );
    }

    if (!uri.path.endsWith('/api')) {
      throw StateError(
        'API_BASE_URL must end with /api to match backend routes. Current path: ${uri.path}',
      );
    }
  }

  static String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}