import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp/core/model/event.dart';
import 'package:pp/core/services/content_sender_service.dart';
import 'package:pp/core/services/shared_preferences_service.dart';
import 'package:pp/core/services/wartched_dir_viewmodel.dart';
import 'package:watcher/watcher.dart';

final fileWatcherService = ChangeNotifierProvider<FileWatcherService>((ref) {

  var fileWatcherService = FileWatcherService(
      ref.read);
  ref.listen<String?>(watchedDirViewModel, (value) {
    fileWatcherService._watchedDir = value;
  });
  return fileWatcherService;
});

final watchEvents = StreamProvider<Event>(
    (ref) => ref.watch(fileWatcherService)._watchEvents.stream);

class FileWatcherService extends ChangeNotifier {
  FileWatcherService(this._read) {
    __watchedDir = _read(sharedPreferencesServiceProvider).watchedDirectory;
    working = _read(sharedPreferencesServiceProvider).workingOnStart;
  }

  late bool working;
  late String? __watchedDir;
  StreamSubscription<WatchEvent>? _subscription;
  final Reader _read;
  final StreamController<Event> _watchEvents = StreamController.broadcast();

  set _watchedDir(String? _watchedDir) {
    __watchedDir = _watchedDir;
    working = false;
    notifyListeners();
  }

  Future<void> start() async {
    if (!FileSystemEntity.isWatchSupported) {
      throw PlatformException(
          code: "no_watch", message: "Filesystem watch is not supported");
    }
    if (__watchedDir == null) {
      throw PlatformException(code: "no_dir", message: "Now directory defined");
    }
    var directoryWatcher = DirectoryWatcher(__watchedDir!);
    _subscription = directoryWatcher.events.listen(_newEvent);
    try {
      await directoryWatcher.ready;
    } catch (e) {
      throw PlatformException(
          code: "not_watching", message: "Cannot start watching");
    }
    working = true;
    notifyListeners();
  }

  void _newEvent(WatchEvent event) {
    if (event.type != ChangeType.REMOVE) {
      _watchEvents.add(Event(
          event.path,
          event.type == ChangeType.ADD
              ? EventType.watchAdd
              : EventType.watchModified,
          DateTime.now()));
      _read(contentSenderService).send(event.path);
    }
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    working = false;
    notifyListeners();
  }
}
