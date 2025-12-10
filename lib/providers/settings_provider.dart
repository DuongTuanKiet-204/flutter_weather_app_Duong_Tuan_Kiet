import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;

  String temperatureUnit = 'C';
  String windUnit = 'm/s';
  String hourFormat = '24h';
  String language = 'en';

  SettingsProvider(this._storage) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    temperatureUnit = await _storage.getTemperatureUnit();
    windUnit = await _storage.getWindUnit();
    hourFormat = await _storage.getHourFormat();
    language = await _storage.getLanguage();
    notifyListeners();
  }

  void setTemperatureUnit(String value) {
    temperatureUnit = value;
    _storage.saveTemperatureUnit(value);
    notifyListeners();
  }

  void setWindUnit(String value) {
    windUnit = value;
    _storage.saveWindUnit(value);
    notifyListeners();
  }

  void setHourFormat(String value) {
    hourFormat = value;
    _storage.saveHourFormat(value);
    notifyListeners();
  }

  void setLanguage(String value) {
    language = value;
    _storage.saveLanguage(value);
    notifyListeners();
  }
}
