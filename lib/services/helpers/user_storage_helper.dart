import 'package:aqua_pet/data/models/user.dart';
import 'package:aqua_pet/data/storage_keys.dart';
import 'package:aqua_pet/services/storage_service.dart';

class UserStorageHelper {
  static Future<void> save(User user) async {
    await StorageService.setJson(
      StorageKeys.user,
      user.toJson(),
    );
  }

  static User load() {
    final json = StorageService.getJson(StorageKeys.user);

    if (json.isEmpty) {
      return const User(
        username: '',
        gender: 'Male',
        activityLevel: 'moderate',
        weight: 0,
      );
    }

    return User.fromJson(json);
  }

  static bool hasUser() {
    return StorageService.getJson(StorageKeys.user).isNotEmpty;
  }
}