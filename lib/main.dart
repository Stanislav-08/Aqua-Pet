import 'package:aqua_pet/elements/bottom_navigation.dart';
import 'package:aqua_pet/layers/background.dart';
import 'package:aqua_pet/services/location_service.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:aqua_pet/services/storage_service.dart';
import 'package:aqua_pet/services/weather_service.dart';
import 'package:aqua_pet/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await NotificationService.init();

  Workmanager().initialize(
    callbackDispatcher,
  );

  await Workmanager().registerPeriodicTask(
    "waterReminder",
    "checkReminders",
    frequency: const Duration(minutes: 15),
  );

  final position = await LocationService().getCurrentLocation();

  await WeatherService.instance.loadTemperature(
    latitude: position.latitude,
    longitude: position.longitude,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: const BottomNavigation(),
    );
  }
}