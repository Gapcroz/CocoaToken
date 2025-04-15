class ApiConfig {
  static const String baseUrl =
      'http://192.168.100.35:3000/api'; // <----- Enter your IP here.
  static const String couponsEndpoint = '$baseUrl/coupons';

  static Future<Map<String, String>> getHeaders(String token) async {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
