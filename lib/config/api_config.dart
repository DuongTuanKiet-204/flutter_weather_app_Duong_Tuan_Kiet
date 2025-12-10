import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // API_KEY lấy từ .env
  static String get apiKey => dotenv.env['API_KEY'] ?? "";

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static String get currentWeather => '$baseUrl/weather';
  static String get forecast => '$baseUrl/forecast';
  static String get oneCall => '$baseUrl/onecall';

  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final query = {
      ...params,
      'appid': apiKey,
      'units': 'metric',
    };

    return Uri.parse(endpoint).replace(queryParameters: query).toString();
  }
}
