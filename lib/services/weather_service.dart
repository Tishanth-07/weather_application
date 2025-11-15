import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true";

    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        prefs.setString("cached_weather", response.body);
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      final cached = prefs.getString("cached_weather");

      if (cached != null) {
        return WeatherModel.fromJson(jsonDecode(cached));
      } else {
        throw Exception("No internet & no cached data!");
      }
    }
  }
}
