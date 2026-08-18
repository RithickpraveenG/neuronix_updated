class ApiConfig {
  static const String backendBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://neuronix-backend.onrender.com',
  );
}
