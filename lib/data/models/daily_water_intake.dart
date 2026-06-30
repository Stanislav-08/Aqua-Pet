import 'package:aqua_pet/services/weather_service.dart';

class DailyWaterIntake {
  /// Returns the recommended daily water intake in milliliters.
  ///
  /// weightKg: Body weight in kilograms.
  /// activityMinutes: Minutes of moderate/intense exercise.
  /// temperatureC: Average outdoor temperature.
  static int calculate({
    required double weightKg,
    required String activityLevel,
  }) {

    double baseIntakePerKilogram = 35;
    double temperatureC=WeatherService.instance.currentTemperature ?? 20;
    double activityAdditionPercent = 0;
    double temperatureAdditionPercent = 0;

    switch (activityLevel) {
      case 'light':
        activityAdditionPercent=0.05;
        break;
      case 'moderate':
        activityAdditionPercent=0.20;
        break;
      case 'high':
        activityAdditionPercent=0.35;
        break;
    }

    if (temperatureC <= 20) {
      temperatureAdditionPercent = 0;
    } else if (temperatureC <= 28) {
      temperatureAdditionPercent = 0.10;
    } else {
      temperatureAdditionPercent = 0.20;
    }

    // Base: 35 mL per kg
    double intake = weightKg * baseIntakePerKilogram;

    // Activity addition
    intake += intake*activityAdditionPercent;

    // Temperature addition
    intake += intake*temperatureAdditionPercent;

    // Reasonable limits
    intake = intake.clamp(2000.0, 4500.0);

    return intake.round();
  }
}