import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    Map<String, List<ForecastModel>> grouped = {};

    for (var f in forecasts) {
      String day = DateFormat('yyyy-MM-dd').format(f.dateTime);
      grouped.putIfAbsent(day, () => []).add(f);
    }

    return Column(
      children: grouped.entries.map((entry) {
        final dayList = entry.value;

        double minTemp = dayList.map((e) => e.tempMin).reduce((a, b) => a < b ? a : b);
        double maxTemp = dayList.map((e) => e.tempMax).reduce((a, b) => a > b ? a : b);

        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: "https://openweathermap.org/img/wn/${dayList.first.icon}.png",
            width: 40,
          ),
          title: Text(DateFormat('EEE, MMM d').format(dayList.first.dateTime)),
          subtitle: Text(dayList.first.description),
          trailing: Text("${minTemp.round()}° / ${maxTemp.round()}°"),
        );
      }).toList(),
    );
  }
}
