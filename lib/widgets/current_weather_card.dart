import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    double temp = weather.temperature;
    double feels = weather.feelsLike;

    if (settings.temperatureUnit == 'F') {
      temp = temp * 9 / 5 + 32;
      feels = feels * 9 / 5 + 32;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${weather.cityName}, ${weather.country}',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 110,
          ),
          Text(
            '${temp.round()}°',
            style: TextStyle(fontSize: 80, fontWeight: FontWeight.w300, color: Colors.white),
          ),
          Text(
            weather.description.toUpperCase(),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            'Feels like ${feels.round()}°',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  LinearGradient _getWeatherGradient(String condition) {
    final c = condition.toLowerCase();

    if (c.contains('clear')) {
      return LinearGradient(
        colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    if (c.contains('rain')) {
      return LinearGradient(
        colors: [Color(0xFF4A5568), Color(0xFF718096)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    if (c.contains('cloud')) {
      return LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    return LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
