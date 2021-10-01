import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/model/event.dart';
import 'package:pp/core/services/content_sender_service.dart';
import 'package:pp/core/services/file_watcher_service.dart';
import 'package:rxdart/rxdart.dart';

final events = StreamProvider<Event>(
        (ref) => MergeStream([ref.watch(watchEvents.stream), ref.watch(sendingEvents.stream)]));