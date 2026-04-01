import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class EnvironmentService {
  // 获取 API Key
  String get _weatherApiKey => dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';

  /// 获取设备的当前 GPS 位置
  /// Gets the device's current GPS location.
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. 检查位置服务是否开启
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    // 2. 检查位置权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // 3. 获取当前位置
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  /// 根据经纬度获取实时天气信息 (返回温度和天气状况)
  /// Gets real-time weather information based on latitude and longitude.
  Future<Map<String, dynamic>?> getWeather(double lat, double lon) async {
    final apiKey = _weatherApiKey;
    if (apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      print("Warning: OpenWeatherMap API key is not set or invalid in .env file. Skipping weather fetch.");
      return null; // 如果没有设置 API Key，直接返回 null
    }

    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        return {
          'temperature': data['main']['temp'], // 摄氏度 (因为用了 units=metric)
          'condition': data['weather'][0]['main'], // 例如: "Clear", "Clouds", "Rain"
        };
      } else {
        print("Failed to load weather data. Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }

  /// 组合方法：一键获取完整的环境数据（位置+天气）
  /// Combined method: Get complete environmental data (location + weather) at once.
  Future<Map<String, dynamic>?> getEnvironmentData() async {
    try {
      final position = await getCurrentLocation();
      if (position == null) return null;

      final weatherData = await getWeather(position.latitude, position.longitude);

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'temperature': weatherData?['temperature'],
        'weatherCondition': weatherData?['condition'],
      };
    } catch (e) {
      print("Error getting environment data: $e");
      return null;
    }
  }
}
