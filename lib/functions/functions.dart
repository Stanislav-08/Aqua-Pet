import 'package:aqua_pet/data/models/reminder.dart';
import 'package:flutter/material.dart';

//streak modal
void showStreakModal(
    BuildContext context, {
      required int currentStreak,
      required int bestStreak,
    }) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Streak',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _streakTile(
                  icon: Icons.local_fire_department,
                  label: 'Current',
                  value: currentStreak,
                ),
                _streakTile(
                  icon: Icons.emoji_events,
                  label: 'Best',
                  value: bestStreak,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}

Widget _streakTile({
  required IconData icon,
  required String label,
  required int value,
}) {
  return Column(
    children: [
      Icon(icon, size: 32),
      const SizedBox(height: 6),
      Text(
        '$value',
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}

// custom intake modal
void showCustomIntakeModal(
    BuildContext context,
    void Function(int value) onAdd,
    ) {
  final controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      return SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Milliliters',
                  ),
                ),

                const SizedBox(height: 16),

                FloatingActionButton(
                  onPressed: () {
                    final value = int.tryParse(controller.text);

                    if (value == null || value <= 0) return;

                    Navigator.pop(context);
                    onAdd(value);
                  },
                  child: const Text('Add water'),
                ),

                SizedBox(height: keyboardHeight),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// reminder modal
void showReminderModal(
    BuildContext context,
    Function(Reminder) onSave,
    ) {
  bool isBedTimeEnabled = true;

  int repeatHours = 2;
  int repeatMinutes = 0;

  int selectedStartHour = 22;
  int selectedEndHour = 7;

  final nameController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Reminder name',
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Text(
                          'Repeat every',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),

                        DropdownButton<int>(
                          value: repeatHours,
                          items: List.generate(
                            24,
                                (i) => DropdownMenuItem(
                              value: i,
                              child: Text("${i} h"),
                            ),
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              repeatHours = value!;
                            });
                          },
                        ),

                        const SizedBox(width: 16),

                        DropdownButton<int>(
                          value: repeatMinutes,
                          items: List.generate(
                            12,
                                (i) => DropdownMenuItem(
                              value: i * 5,
                              child: Text("${i * 5} m"),
                            ),
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              repeatMinutes = value!;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Text("Disable during bedtime"),
                        const Spacer(),
                        Switch(
                          value: isBedTimeEnabled,
                          onChanged: (value) {
                            setModalState(() {
                              isBedTimeEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),

                    if (isBedTimeEnabled)
                      Row(
                        children: [
                          const Text("From"),

                          const SizedBox(width: 12),

                          DropdownButton<int>(
                            value: selectedStartHour,
                            items: List.generate(
                              24,
                                  (i) => DropdownMenuItem(
                                value: i,
                                child: Text("${i.toString().padLeft(2, '0')}:00"),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                selectedStartHour = value!;
                              });
                            },
                          ),

                          const SizedBox(width: 20),

                          const Text("To"),

                          const SizedBox(width: 12),

                          DropdownButton<int>(
                            value: selectedEndHour,
                            items: List.generate(
                              24,
                                  (i) => DropdownMenuItem(
                                value: i,
                                child: Text("${i.toString().padLeft(2, '0')}:00"),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                selectedEndHour = value!;
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final reminder = Reminder(
                            name: nameController.text,
                            repeatEvery: Duration(
                              hours: repeatHours,
                              minutes: repeatMinutes,
                            ),
                            bedTime: isBedTimeEnabled,
                            startHour: selectedStartHour,
                            endHour: selectedEndHour,
                            nextNotification: DateTime.now().add(
                              Duration(
                                hours: repeatHours,
                                minutes: repeatMinutes,
                              ),
                            ),
                          );

                          onSave(reminder);

                          Navigator.pop(context);
                        },
                        child: const Text("Save"),
                      ),
                    ),

                    SizedBox(height: keyboardHeight),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}