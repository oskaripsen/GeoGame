class Config {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://energy-game-api-6a18fc829f3d.herokuapp.com',
  );
}
