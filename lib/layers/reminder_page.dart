import 'package:aqua_pet/data/data_structures.dart';
import 'package:flutter/material.dart';
import 'package:aqua_pet/functions/functions.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(screenPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                reminders.isEmpty
                    ? const Center(child: Text('No reminders'))
                    : Column(
                  children: List.generate(
                    reminders.length,
                        (index) {
                      final r = reminders[index];
                      return ListTile(
                        title: Text(r.name),
                        subtitle: Text('Every ${r.repeatEvery}h'),
                      );
                    },
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    showReminderModal(context, (reminder) {
                      setState(() {
                        reminders.add(reminder);
                      });
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}