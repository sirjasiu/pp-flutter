import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/model/event.dart';
import 'package:pp/core/services/events.dart';

final notificationProvider = Provider<NotificationService>((ref) {
  var notificationService = NotificationService();
  ref.watch(events.stream).listen(notificationService.notifyEvent);
  return notificationService;
});

class NotificationService {

  Future<void> notifyEvent(Event event) async {
    //await client.notify("${describeEventType(event.type)}: ${event.path}");
  }
}
