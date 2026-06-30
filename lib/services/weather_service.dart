import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  WeatherService._();

  static final WeatherService instance = WeatherService._();

  double? currentTemperature;

  Future<void> loadTemperature({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'temperature_2m',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather.');
    }

    final json = jsonDecode(response.body);

    currentTemperature =
        (json['current']['temperature_2m'] as num).toDouble();
  }
}