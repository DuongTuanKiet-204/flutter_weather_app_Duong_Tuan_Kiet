import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/weather_alert_model.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  List<WeatherAlertModel> _alerts = [];

  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  bool _isCached = false;
  bool _isOutdated = false;

  WeatherProvider(
      this._weatherService,
      this._locationService,
      this._storageService,
      );

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  List<WeatherAlertModel> get alerts => _alerts;

  WeatherState get state => _state;
  String get errorMessage => _errorMessage;

  bool get isCached => _isCached;
  bool get isOutdated => _isOutdated;

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _isCached = false;
      _isOutdated = false;

      _currentWeather =
      await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);

      try {
        _alerts = await _weatherService.getWeatherAlerts(
          _currentWeather!.lat,
          _currentWeather!.lon,
        );
      } catch (_) {
        _alerts = [];
      }

      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();

      await loadCachedWeather();
    }

    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      _currentWeather =
      await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      _forecast =
      await _weatherService.getForecast(_currentWeather!.cityName);

      try {
        _alerts = await _weatherService.getWeatherAlerts(
          position.latitude,
          position.longitude,
        );
      } catch (_) {
        _alerts = [];
      }

      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();

      await loadCachedWeather();
    }

    notifyListeners();
  }

  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    final valid = await _storageService.isCacheValid();

    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _isCached = true;
      _isOutdated = !valid;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
}
