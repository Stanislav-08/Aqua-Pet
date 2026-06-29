import 'package:aqua_pet/data/models/reminder.dart';
import 'package:flutter/material.dart';

List<IconData> icons = const [
  Icons.home_rounded,
  Icons.water_drop_rounded,
  Icons.calendar_month_rounded,
  Icons.person_rounded,
];

Map<String, int> intakes = const{
  '100ml': 100,
  '250ml': 250,
  '500ml': 500,
  '1L': 1000,
};

List<Reminder> reminders = [];