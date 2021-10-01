import 'dart:async';

import 'package:flutter/foundation.dart';

enum _BusyState { busy, free }

class BaseViewModel extends ChangeNotifier {
  var _state = _BusyState.free;
  Timer? _currentTimer;

  bool get free => _state == _BusyState.free;
  bool get busy => _state == _BusyState.busy;

  void _setState(_BusyState state) {
    _currentTimer?.cancel();
    _state = state;
    notifyListeners();
  }

  void setBusy() => _setState(_BusyState.busy);

  void setFree() => _setState(_BusyState.free);

  void _setStateDelayed(_BusyState state, Duration duration) {
    _currentTimer = Timer(duration, () {
      _state = state;
      notifyListeners();
    });
  }

  void setBusyDelayed(Duration duration) =>
      _setStateDelayed(_BusyState.busy, duration);

  void setFreeDelayed(Duration duration) =>
      _setStateDelayed(_BusyState.free, duration);
}
