import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/forecast_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Container(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (_, index) {
          final hourData = forecasts[index];

          String time = settings.hourFormat == "24h"
              ? DateFormat.Hm().format(hourData.dateTime)
              : DateFormat('h a').format(hourData.dateTime);

          return Container(
            width: 90,
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time, style: TextStyle(fontSize: 14)),
                SizedBox(height: 6),
                CachedNetworkImage(
                  imageUrl: "https://openweathermap.org/img/wn/${hourData.icon}.png",
                  height: 30,
                ),
                SizedBox(height: 6),
                Text("${hourData.temperature.round()}°",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}
