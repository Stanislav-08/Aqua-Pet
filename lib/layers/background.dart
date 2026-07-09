import 'package:aqua_pet/services/helpers/reminder_storage_helper.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:aqua_pet/services/storage_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await StorageService.init();
    await NotificationService.init();

    final reminders = ReminderStorage.load();
    final now = DateTime.now();

    for (final reminder in reminders) {
      // Step 9 goes HERE

      final hour = now.hour;

      bool sleeping = false;

      if (reminder.bedTime) {
        if (reminder.startHour! > reminder.endHour!) {
          sleeping =
              hour >= reminder.startHour! ||
                  hour < reminder.endHour!;
        } else {
          sleeping =
              hour >= reminder.startHour! &&
                  hour < reminder.endHour!;
        }
      }

      if (sleeping) {
        continue;
      }

      if (now.isAfter(reminder.nextNotification)) {
        await NotificationService.showNotification(
          title: reminder.name,
          body: 'Your plant needs water',
        );

        reminder.nextNotification =
            reminder.nextNotification.add(reminder.repeatEvery);
      }
    }

    await ReminderStorage.save(reminders);

    return Future.value(true);
  });
}