import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp/core/services/shared_preferences_service.dart';
import 'package:state_notifier/state_notifier.dart';

final watchedDirViewModel =
    StateNotifierProvider<WatchedDirViewModel, String?>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return WatchedDirViewModel(sharedPreferencesService);
});

class WatchedDirViewModel extends StateNotifier<String?> {
  WatchedDirViewModel(this.sharedPreferencesService)
      : super(sharedPreferencesService.watchedDirectory);
  final SharedPreferencesService sharedPreferencesService;

  Future<void> setWatchedDir(String? watchedDirectory) async {
    await sharedPreferencesService.setWatchedDir(watchedDirectory);
    state = watchedDirectory;
  }

  String? get watchedDirectory => state;
}
