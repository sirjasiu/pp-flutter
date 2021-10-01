import 'package:file_picker/file_picker.dart';
import 'package:pp/core/services/wartched_dir_viewmodel.dart';
import 'package:pp/core/viewmodels/base_viewmodel.dart';

class ConfigurationViewModel extends BaseViewModel {
  ConfigurationViewModel(this.watchedDirViewModel);

  final WatchedDirViewModel watchedDirViewModel;

  Future<void> removeDir() async {
    await watchedDirViewModel.setWatchedDir(null);
    notifyListeners();
  }

  Future<void> selectDir() async {
    setBusy();
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle: "Choose watched directory");
      if (selectedDirectory != null) {
        await watchedDirViewModel.setWatchedDir(selectedDirectory);
      }
    } finally {
      setFree();
    }
  }

  String? get watchedDirectory => watchedDirViewModel.watchedDirectory;
}
