class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://uneffectuated-immovably-jair.ngrok-free.dev/api',
  );
}