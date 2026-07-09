import 'package:aqua_pet/data/models/reminder.dart';
import 'package:aqua_pet/services/storage_service.dart';
import 'package:aqua_pet/data/storage_keys.dart';

class ReminderStorage {
  static Future<void> save(List<Reminder> reminders) async {
    await StorageService.setJsonList(
      StorageKeys.reminders,
      reminders.map((e) => e.toJson()).toList(),
    );
  }

  static List<Reminder> load() {
    return StorageService.getJsonList(
      StorageKeys.reminders,
    ).map(Reminder.fromJson).toList();
  }
}