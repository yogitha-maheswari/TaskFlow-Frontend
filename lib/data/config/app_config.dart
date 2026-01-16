class AppConfig {
  static const String baseUrl =
      String.fromEnvironment(
        'API_URL',
        defaultValue: 'https://taskflow-backend-g86v.onrender.com',
      );
}
