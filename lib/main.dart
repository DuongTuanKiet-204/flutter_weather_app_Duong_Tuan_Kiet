import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';

import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';

import 'screens/home_screen.dart';
import 'config/api_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  print("============== DEBUG CHECK ==============");
  print("API_KEY from .env = ${ApiConfig.apiKey}");
  print("=========================================");

  final storage = StorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storage),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherService(apiKey: ApiConfig.apiKey),
            LocationService(),
            storage,
          ),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App Lab 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: HomeScreen(),
    );
  }
}
