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
  final indexController = TextEditingController(text: "224068R");
  double? latitude;
  double? longitude;
  String? requestUrl;
  WeatherModel? weather;
  bool loading = false;
  bool isCached = false;
  String? errorMessage;

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

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final service = WeatherService();
      final result = await service.fetchWeather(latitude!, longitude!);
      setState(() {
        weather = result;
        isCached = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        weather = null;
        isCached = false;
        errorMessage = e.toString();
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    computeCoords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Weather Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFFAFBFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667eea).withOpacity(0.15),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.school, color: Colors.white, size: 24),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Student Information",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: indexController,
                        decoration: InputDecoration(
                          labelText: "Student Index",
                          labelStyle: TextStyle(color: Color(0xFF667eea)),
                          prefixIcon: Icon(Icons.person, color: Color(0xFF667eea)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFFE2E8F0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Color(0xFF667eea), width: 2.5),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7FAFC),
                        ),
                        onChanged: (_) => computeCoords(),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEBF4FF), Color(0xFFF0E7FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFF667eea).withOpacity(0.3), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667eea).withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.location_on, color: Color(0xFF667eea), size: 28),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Latitude: ${latitude?.toStringAsFixed(4) ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Longitude: ${longitude?.toStringAsFixed(4) ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Fetch Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667eea).withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: fetchWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_download, size: 26),
                      SizedBox(width: 10),
                      Text(
                        "Fetch Weather",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (errorMessage != null && errorMessage!.isNotEmpty) ...[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF5F5), Color(0xFFFED7D7)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFFFC8181), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Color(0xFFC53030), size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Color(0xFFC53030),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (loading) ...[
                SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF667eea).withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                          strokeWidth: 4,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Loading weather data...",
                        style: TextStyle(
                          color: Color(0xFF667eea),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (weather != null && !loading) ...[
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFFAFBFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF667eea).withOpacity(0.15),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF48BB78), Color(0xFF38A169)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.wb_cloudy, color: Colors.white, size: 24),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Weather Information",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            if (isCached)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFFFF5E6), Color(0xFFFFE6CC)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xFFED8936), width: 1.5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.cached, color: Color(0xFFDD6B20), size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      "Cached",
                                      style: TextStyle(
                                        color: Color(0xFFDD6B20),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildWeatherItem(
                          icon: Icons.thermostat,
                          label: "Temperature",
                          value: "${weather!.temperature}°C",
                          gradientColors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                          iconBg: Color(0xFFFFF5F5),
                        ),
                        SizedBox(height: 14),
                        _buildWeatherItem(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: "${weather!.windSpeed} km/h",
                          gradientColors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                          iconBg: Color(0xFFE6FFFA),
                        ),
                        SizedBox(height: 14),
                        _buildWeatherItem(
                          icon: Icons.wb_sunny,
                          label: "Weather Code",
                          value: "${weather!.weatherCode}",
                          gradientColors: [Color(0xFFFFC837), Color(0xFFFF8008)],
                          iconBg: Color(0xFFFFFAF0),
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Color(0xFFCBD5E0), width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, size: 20, color: Color(0xFF667eea)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Last Updated: ${DateTime.now().toString().split('.')[0]}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4A5568),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: 20),

              if (requestUrl != null && requestUrl!.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    requestUrl!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718096),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherItem({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradientColors,
    required Color iconBg,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientColors[0].withOpacity(0.1), gradientColors[1].withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradientColors[0].withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: gradientColors[0], size: 28),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    letterSpacing: 0.5,
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