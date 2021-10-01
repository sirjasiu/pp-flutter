import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pp/core/model/event.dart';
import 'package:pp/core/viewmodels/base_viewmodel.dart';

class StatsViewModel extends BaseViewModel {
  StatsViewModel();

  final Map<EventType, charts.Series<TimeSeriesEvents, DateTime>> _series = {
    for (var e in [
      EventType.watchAdd,
      EventType.watchModified,
      EventType.sendSuccess
    ]) e: charts.Series<TimeSeriesEvents, DateTime>(
        id: describeEventType(e),
        domainFn: (events, _) => events.time,
        measureFn: (events, _) => events.event,
        data: [])
  };

  void add(Event e) {
    var serie = _series[e.type];
    if(serie != null) {
      var roundDownTimestamp = e.timestamp.roundDown();
      var event = serie.data.lastIfNotEmpty;
      if (event == null || event.time.isBefore(roundDownTimestamp)) {
        event = TimeSeriesEvents(roundDownTimestamp, 0);
        serie.data.add(event);
      }
      event.event++;

      notifyListeners();
    }
  }

  List<charts.Series<TimeSeriesEvents, DateTime>> get series => _series.values.toList()..sort((a, b) => a.id.compareTo(b.id));

}

extension on DateTime{

  DateTime roundDown({Duration delta = const Duration(seconds: 15)}){
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch -
            millisecondsSinceEpoch % delta.inMilliseconds
    );
  }
}

extension MyList<T> on List<T> {
  T? get lastIfNotEmpty => isEmpty ? null : last;
}

/// Sample time series data type.
class TimeSeriesEvents {
  final DateTime time;
  int event;

  TimeSeriesEvents(this.time, this.event);
}

