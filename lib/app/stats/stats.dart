import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/services/events.dart';
import 'package:pp/core/viewmodels/stats/configuration_viewmodel.dart';

final _statsViewModel = ChangeNotifierProvider<StatsViewModel>((ref) {
  var logsViewModel = StatsViewModel();
  ref.watch(events.stream).listen(logsViewModel.add);
  return logsViewModel;
});


class StatsPage extends HookConsumerWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(_statsViewModel);
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: charts.TimeSeriesChart(
                stats.series,
                behaviors: [ charts.SeriesLegend()],),
            )));
  }
}
