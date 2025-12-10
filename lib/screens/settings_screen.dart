import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: settings.temperatureUnit,
              items: ["C", "F"]
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => settings.setTemperatureUnit(v!),
              decoration: InputDecoration(labelText: "Temperature Unit"),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField(
              value: settings.windUnit,
              items: ["m/s", "km/h", "mph"]
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => settings.setWindUnit(v!),
              decoration: InputDecoration(labelText: "Wind Speed Unit"),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField(
              value: settings.hourFormat,
              items: ["12h", "24h"]
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => settings.setHourFormat(v!),
              decoration: InputDecoration(labelText: "Hour Format"),
            ),
            SizedBox(height: 16),

            DropdownButtonFormField(
              value: settings.language,
              items: ["en", "vi"]
                  .map((v) => DropdownMenuItem(value: v, child: Text(v.toUpperCase())))
                  .toList(),
              onChanged: (v) => settings.setLanguage(v!),
              decoration: InputDecoration(labelText: "Language"),
            ),
          ],
        ),
      ),
    );
  }
}
