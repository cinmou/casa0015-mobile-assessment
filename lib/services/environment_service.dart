import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class EnvironmentService {
  String get _weatherApiKey => dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getWeather(double lat, double lon) async {
    final apiKey = _weatherApiKey;
    if (apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      print("Warning: OpenWeatherMap API key is not set. Skipping weather fetch.");
      return {'temperature': 20.0, 'condition': 'Sunny'}; // Placeholder
    }

    try {
      final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'temperature': data['main']['temp'],
          'condition': data['weather'][0]['main'],
        };
      } else {
        print("Failed to load weather data. Status Code: ${response.statusCode}");
        return {'temperature': 20.0, 'condition': 'Sunny'}; // Placeholder
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return {'temperature': 20.0, 'condition': 'Sunny'}; // Placeholder
    }
  }

  Future<Map<String, dynamic>> getEnvironmentData() async {
    final position = await _getCurrentLocation();
    
    // Use placeholder if location is not available
    final lat = position?.latitude ?? 34.0522; // Default to Los Angeles
    final lon = position?.longitude ?? -118.2437;

    final weatherData = await _getWeather(lat, lon);

    return {
      'latitude': lat,
      'longitude': lon,
      'temperature': weatherData?['temperature'],
      'weatherCondition': weatherData?['condition'],
      'locationName': position != null ? null : "A beautiful place", // Placeholder name
    };
  }
}
