class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://vein-pay-api.onrender.com';

  static const String login = '/api/auth/login/';
  static const String refreshToken = '/api/auth/token/refresh/';
  static const String wallet = '/api/wallet/';
  static const String addMoney = '/api/wallet/add/';
  static const String transactions = '/api/wallet/transactions/';

  static Uri buildUri(String endpoint) {
    return Uri.parse('$baseUrl$endpoint');
  }
}
