import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Padding(
        padding: EdgeInsets.only(bottom: 90),
        child: Center(child: Text('Calendar page')),
      ),
    );
  }
}