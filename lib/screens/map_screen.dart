import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../config/api_config.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedLayer = "clouds_new";

  @override
  Widget build(BuildContext context) {
    final apiKey = ApiConfig.apiKey;

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Map"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: selectedLayer,
              items: const [
                DropdownMenuItem(value: "clouds_new", child: Text("Radar / Clouds")),
                DropdownMenuItem(value: "temp_new", child: Text("Temperature")),
                DropdownMenuItem(value: "precipitation_new", child: Text("Precipitation")),
                DropdownMenuItem(value: "wind_new", child: Text("Wind Map")),
              ],
              onChanged: (value) => setState(() => selectedLayer = value!),
            ),
          ),

          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(10.762622, 106.660172),
                initialZoom: 6,
              ),
              children: [
                /// Layer Nền OpenStreetMap
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "com.example.weather_app_lab4",
                ),

                /// Layer thời tiết — BỌC bằng Opacity()
                Opacity(
                  opacity: 0.55, // độ trong suốt
                  child: TileLayer(
                    urlTemplate:
                    "https://tile.openweathermap.org/map/$selectedLayer/{z}/{x}/{y}.png?appid=$apiKey",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
