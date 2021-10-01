import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/model/event.dart';
import 'package:pp/core/services/configuration_service.dart';

final contentSenderService = Provider<ContentSenderService>((ref) =>
    ContentSenderService(ref.watch(configurationService).interpreterPath));

final sendingEvents = StreamProvider<Event>(
        (ref) => ref.watch(contentSenderService)._sendingEvents.stream);

class ContentSenderService {
  late final Dio _client;
  final StreamController<Event> _sendingEvents = StreamController.broadcast();

  ContentSenderService(String interpreterPath) {
    _client = Dio(BaseOptions(baseUrl: interpreterPath),);
  }

  Future<void> send(String path) async {
    var file = File(path);
    if (await file.exists()) {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file":
        await MultipartFile.fromFile(file.path, filename:fileName),
      });
      try {
        await _client.post("", data: formData);
        _sendingEvents.add(Event(path, EventType.sendSuccess, DateTime.now()));
      } catch (e) {
        _sendingEvents.add(Event(path, EventType.sendFailure, DateTime.now()));
      }
    }
  }
}
