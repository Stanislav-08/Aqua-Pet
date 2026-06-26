import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 20),
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