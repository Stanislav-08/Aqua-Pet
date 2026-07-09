import 'package:aqua_pet/data/models/reminder.dart';
import 'package:aqua_pet/services/helpers/reminder_storage_helper.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:aqua_pet/functions/functions.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {

  List<Reminder> reminders = [];

  @override
  void initState() {
    super.initState();

    reminders = ReminderStorage.load();

    setState(() {});
  }

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

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    r.repeatEvery.inMinutes.remainder(60) == 0
                                        ? 'Every ${r.repeatEvery.inHours}h'
                                        : 'Every ${r.repeatEvery.inHours}h ${r.repeatEvery.inMinutes.remainder(60)}m',
                                  ),

                                  if (r.bedTime)
                                    Text(
                                      'Disabled ${r.startHour!.toString().padLeft(2, '0')}:00'
                                          ' - '
                                          '${r.endHour!.toString().padLeft(2, '0')}:00',
                                    ),
                                ],
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await NotificationService.cancelReminder(r.hashCode);

                                setState(() {
                                  reminders.removeAt(index);
                                });

                                await ReminderStorage.save(reminders);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    showReminderModal(
                      context,
                          (reminder) async {
                        setState(() {
                          reminders.add(reminder);
                        });

                        await ReminderStorage.save(reminders);
                      },
                    );
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