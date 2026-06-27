import 'package:aqua_pet/elements/bottom_navigation.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:aqua_pet/theme/app_themes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
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
      home: BottomNavigation(),
    );
  }
}
