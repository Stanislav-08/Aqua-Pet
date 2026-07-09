import 'package:flutter/material.dart';
import 'package:aqua_pet/elements/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(screenPadding),
          child: Center(
            child: Column(
              children: [
                Calendar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}