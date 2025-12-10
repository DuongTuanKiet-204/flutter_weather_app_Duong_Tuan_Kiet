import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final StorageService _storage = StorageService();

  List<String> _searchHistory = [];
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _searchHistory = await _storage.getSearchHistory();
    _favorites = await _storage.getFavoriteCities();
    setState(() {});
  }

  bool _containsInvalidChars(String city) {
    final special = RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]');
    return special.hasMatch(city);
  }

  Future<void> _search(String city) async {
    city = city.trim();

    if (city.isEmpty) {
      _showError("City name cannot be empty");
      return;
    }

    if (_containsInvalidChars(city)) {
      _showError("City name cannot contain numbers or special characters");
      return;
    }

    final provider = context.read<WeatherProvider>();
    await provider.fetchWeatherByCity(city);

    if (provider.state == WeatherState.error ||
        provider.errorMessage.toLowerCase().contains("not found")) {
      _showError("City not found. Please try another city.");
      return;
    }

    _searchHistory.remove(city);
    _searchHistory.insert(0, city);

    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await _storage.saveSearchHistory(_searchHistory);

    Navigator.pop(context);
  }

  Future<void> _addFavorite(String city) async {
    city = city.trim();

    if (city.isEmpty) {
      _showError("Cannot add empty city");
      return;
    }

    if (!_favorites.contains(city)) {
      _favorites.insert(0, city);
      if (_favorites.length > 5) {
        _favorites = _favorites.sublist(0, 5);
      }
      await _storage.saveFavoriteCities(_favorites);
      setState(() {});
    }
  }

  Future<void> _removeHistory(String city) async {
    _searchHistory.remove(city);
    await _storage.saveSearchHistory(_searchHistory);
    setState(() {});
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search City')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _search(_controller.text),
              child: Text('Search'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _addFavorite(_controller.text),
              child: Text('Add to Favorites'),
            ),
            SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Searches",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  ..._searchHistory.map((city) {
                    return ListTile(
                      title: Text(city),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _removeHistory(city),
                      ),
                      onTap: () => _search(city),
                    );
                  }),

                  SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Favorite Cities",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ..._favorites.map((city) {
                    return ListTile(
                      leading: Icon(Icons.star, color: Colors.orange),
                      title: Text(city),
                      onTap: () => _search(city),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
