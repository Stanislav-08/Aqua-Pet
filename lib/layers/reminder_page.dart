import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder')),
      body: const Padding(
        padding: EdgeInsets.only(bottom: 90),
        child: Center(child: Text('Reminder page')),
      ),
    );
  }
}