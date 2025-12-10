import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';
  static const String _searchHistoryKey = 'search_history';

  static const String _tempUnitKey = 'temperature_unit';
  static const String _windUnitKey = 'wind_unit';
  static const String _hourFormatKey = 'hour_format';
  static const String _languageKey = 'language';

  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString(_weatherKey);
    if (weatherJson != null) {
      return WeatherModel.fromJson(json.decode(weatherJson));
    }
    return null;
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return false;
    final difference = DateTime.now().millisecondsSinceEpoch - lastUpdate;
    return difference < 30 * 60 * 1000;
  }

  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<void> saveSearchHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> saveTemperatureUnit(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tempUnitKey, value);
  }

  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tempUnitKey) ?? 'C';
  }

  Future<void> saveWindUnit(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_windUnitKey, value);
  }

  Future<String> getWindUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_windUnitKey) ?? 'm/s';
  }

  Future<void> saveHourFormat(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_hourFormatKey, value);
  }

  Future<String> getHourFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_hourFormatKey) ?? '24h';
  }

  Future<void> saveLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_languageKey, value);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }
}
