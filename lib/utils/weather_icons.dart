import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String? iconCode) {
    if (iconCode == null) return Icons.help_outline;

    // Day / Night detection
    bool isNight = iconCode.contains('n');

    switch (iconCode.substring(0, 2)) {
      case '01': // Clear sky
        return isNight ? Icons.nights_stay : Icons.wb_sunny;

      case '02': // Few clouds
        return isNight ? Icons.cloud : Icons.cloud_queue;

      case '03': // Scattered clouds
      case '04': // Broken clouds
        return Icons.cloud;

      case '09': // Shower rain
        return Icons.grain; // drizzle look

      case '10': // Rain
        return Icons.beach_access;

      case '11': // Thunderstorm
        return Icons.flash_on;

      case '13': // Snow
        return Icons.ac_unit;

      case '50': // Mist / Fog
        return Icons.blur_on;

      default:
        return Icons.help_outline;
    }
  }
}
