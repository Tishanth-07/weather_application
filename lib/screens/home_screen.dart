import 'package:flutter/material.dart';
import '../utils/index_to_coords.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final indexController = TextEditingController(text: "224199T");
  double? latitude;
  double? longitude;
  String? requestUrl;
  WeatherModel? weather;
  bool loading = false;
  bool isCached = false;

 void computeCoords() {
    final idx = indexController.text;
    final lat = latitudeFromIndex(idx);
    final lon = longitudeFromIndex(idx);

    setState(() {
      latitude = lat;
      longitude = lon;
    });
  }


  Future<void> fetchWeather() async {
    if (latitude == null || longitude == null) computeCoords();

    setState(() => loading = true);

    try {
      final service = WeatherService();
      final result = await service.fetchWeather(latitude!, longitude!);
      setState(() {
        weather = result;
        isCached = false;
      });
    } catch (e) {
      setState(() => isCached = true);
    }

    setState(() => loading = false);
  }

  @override
  void initState() {
    computeCoords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: indexController,
              decoration: InputDecoration(labelText: "Student Index"),
              onChanged: (_) => computeCoords(),
            ),

            SizedBox(height: 10),
            Text("Latitude: $latitude"),
            Text("Longitude: $longitude"),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWeather,
              child: Text("Fetch Weather"),
            ),

            if (loading) ...[
              SizedBox(height: 20),
              Center(child: CircularProgressIndicator()),
            ],

            if (weather != null && !loading) ...[
              SizedBox(height: 20),
              Text("Temperature: ${weather!.temperature}°C"),
              Text("Wind Speed: ${weather!.windSpeed} km/h"),
              Text("Weather Code: ${weather!.weatherCode}"),
              SizedBox(height: 10),
              Text("Last Updated: ${DateTime.now()}"),
              if (isCached)
                Text("(cached)", style: TextStyle(color: Colors.orange)),
            ],

            Spacer(),
            Text(
              requestUrl ?? "",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
