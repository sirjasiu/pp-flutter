import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const watchedDirectoryProperty = 'watchedDirectory';
  static const workingOnStartProperty = 'workingOnStart';

  Future<void> setWatchedDir(String? watchedDirectory) async {
    if (watchedDirectory != null) {
      await sharedPreferences.setString(
          watchedDirectoryProperty, watchedDirectory);
    } else {
      await sharedPreferences.remove(watchedDirectoryProperty);
    }
  }

  String? get watchedDirectory =>
      sharedPreferences.getString(watchedDirectoryProperty);

  Future<void> setWorkingOnStart(bool workingOnStart) async {
      await sharedPreferences.setBool(
          workingOnStartProperty, workingOnStart);
  }

  bool get workingOnStart =>
      sharedPreferences.getBool(workingOnStartProperty) ?? false;
}
