import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/weather_alert_model.dart';

class WeatherService {
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<WeatherModel> getCurrentWeatherByCoordinates(
      double lat, double lon) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
      },
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {'q': cityName},
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("City not found");
    }
  }

  Future<List<ForecastModel>> getForecast(String cityName) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {'q': cityName},
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      return list.map((i) => ForecastModel.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<List<WeatherAlertModel>> getWeatherAlerts(
      double lat, double lon) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.oneCall,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'exclude': 'current,minutely,hourly,daily',
      },
    );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['alerts'] == null) return [];
      return (data['alerts'] as List)
          .map((i) => WeatherAlertModel.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to load alerts');
    }
  }
}
