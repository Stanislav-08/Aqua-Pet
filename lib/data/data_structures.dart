import 'package:flutter/material.dart';
import 'package:aqua_pet/layers/calendar_page.dart';
import 'package:aqua_pet/layers/home_page.dart';
import 'package:aqua_pet/layers/profile_page.dart';
import 'package:aqua_pet/layers/reminder_page.dart';

List<Widget> pages = const [
  HomePage(),
  ReminderPage(),
  CalendarPage(),
  ProfilePage(),
];

List<IconData> icons = const [
  Icons.home_rounded,
  Icons.notifications_rounded,
  Icons.calendar_month_rounded,
  Icons.person_rounded,
];

Map<String, int> intakes = const{
  '100ml': 100,
  '250ml': 250,
  '500ml': 500,
  '1L': 1000,
};

