import 'package:aqua_pet/services/weather_service.dart';

class DailyWaterIntake {
  static int calculate({
    required double weightKg,
    required String gender,
    required String activityLevel,
  }) {
    double baseIntakePerKilogram;

    switch (gender.toLowerCase()) {
      case 'female':
        baseIntakePerKilogram = 31;
        break;
      case 'male':
      default:
        baseIntakePerKilogram = 35;
        break;
    }

    final double temperatureC =
        WeatherService.instance.currentTemperature ?? 20;

    double activityAdditionPercent = 0;
    double temperatureAdditionPercent = 0;

    switch (activityLevel.toLowerCase()) {
      case 'light':
        activityAdditionPercent = 0.05;
        break;
      case 'moderate':
        activityAdditionPercent = 0.20;
        break;
      case 'high':
        activityAdditionPercent = 0.35;
        break;
    }

    if (temperatureC <= 20) {
      temperatureAdditionPercent = 0;
    } else if (temperatureC <= 28) {
      temperatureAdditionPercent = 0.10;
    } else {
      temperatureAdditionPercent = 0.20;
    }

    double intake = weightKg * baseIntakePerKilogram;

    intake += intake * activityAdditionPercent;
    intake += intake * temperatureAdditionPercent;

    intake = intake.clamp(2000.0, 4500.0);

    return intake.round();
  }
}