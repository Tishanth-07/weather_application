class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    return WeatherModel(
      temperature: current['temperature'],
      windSpeed: current['windspeed'],
      weatherCode: current['weathercode'],
    );
  }
}
