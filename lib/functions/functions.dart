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
  bool isFirstOption = true;
  int? selectedStartHour = 22;
  int? selectedEndHour = 7;

  final nameController = TextEditingController();
  final repeatController = TextEditingController();

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
                    TextField(
                      controller: repeatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Repeat every',
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bed time'),
                        Switch(
                          value: isFirstOption,
                          onChanged: (value) {
                            setModalState(() {
                              isFirstOption = value;
                            });
                          },
                        ),
                        if (isFirstOption) ...[
                          const Text('From '),
                          DropdownButton<int>(
                            value: selectedStartHour,
                            items: List.generate(
                              24,
                                  (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                selectedStartHour = value!;
                              });
                            },
                          ),
                          const Text('to'),
                          DropdownButton<int>(
                            value: selectedEndHour,
                            items: List.generate(
                              24,
                                  (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                selectedEndHour = value!;
                              });
                            },
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        final reminder = Reminder(
                          name: nameController.text,
                          repeatEvery: int.parse(repeatController.text),
                          bedTime: isFirstOption,
                          startHour: selectedStartHour,
                          endHour: selectedEndHour,
                        );

                        onSave(reminder);
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
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