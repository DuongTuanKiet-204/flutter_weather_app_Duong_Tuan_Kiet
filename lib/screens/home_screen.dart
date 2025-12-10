import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import '../widgets/weather_details_section.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget_custom.dart';
import 'search_screen.dart';
import 'map_screen.dart';  // <-- ĐÚNG

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (provider.state == WeatherState.loading) {
              return LoadingShimmer();
            }

            if (provider.state == WeatherState.error &&
                provider.currentWeather == null) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () => provider.fetchWeatherByLocation(),
              );
            }

            if (provider.currentWeather == null) {
              return Center(child: Text('No weather data'));
            }

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  CurrentWeatherCard(weather: provider.currentWeather!),
                  if (provider.forecast.isNotEmpty)
                    HourlyForecastList(forecasts: provider.forecast),
                  if (provider.forecast.isNotEmpty)
                    DailyForecastSection(forecasts: provider.forecast),
                  WeatherDetailsSection(weather: provider.currentWeather!),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "mapBtn",
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MapScreen()), // <-- FIXED
              );
            },
            child: Icon(Icons.map),
          ),

          SizedBox(height: 12),

          FloatingActionButton(
            heroTag: "searchBtn",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen()),
              );
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
