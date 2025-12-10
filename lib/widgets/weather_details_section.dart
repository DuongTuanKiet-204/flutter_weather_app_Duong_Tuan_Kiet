import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/weather_model.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    double wind = weather.windSpeed;

    if (settings.windUnit == "km/h") {
      wind = wind * 3.6;
    } else if (settings.windUnit == "mph") {
      wind = wind * 2.23694;
    }

    return Column(
      children: [
        Text('Humidity: ${weather.humidity}%'),
        Text('Wind: ${wind.toStringAsFixed(1)} ${settings.windUnit}'),
        Text('Pressure: ${weather.pressure} hPa'),
        Text('Visibility: ${weather.visibility ?? 0} m'),
        Text('Cloudiness: ${weather.cloudiness ?? 0}%'),
      ],
    );
  }
}
