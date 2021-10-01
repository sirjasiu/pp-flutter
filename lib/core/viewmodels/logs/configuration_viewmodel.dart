import 'package:pp/core/model/event.dart';
import 'package:pp/core/viewmodels/base_viewmodel.dart';

class LogsViewModel extends BaseViewModel {
  LogsViewModel();

  List<Event> events = [];

  void add(Event e) {
    events.add(e);
    notifyListeners();
  }
}

