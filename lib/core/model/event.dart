
enum EventType {
  watchAdd,
  watchModified,
  sendSuccess,
  sendRetry,
  sendFailure
}

class Event {
  final String path;
  final EventType type;
  final DateTime timestamp;

  Event(this.path, this.type, this.timestamp);

}

String describeEventType(EventType type) {
  switch (type) {
    case EventType.watchAdd:
      return "File added";
    case EventType.watchModified:
      return "File modified";
    case EventType.sendSuccess:
      return "Send successful";
    case EventType.sendRetry:
      return "Send retried";
    case EventType.sendFailure:
      return "Send failure";
  }
}