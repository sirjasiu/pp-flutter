import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/model/event.dart';
import 'package:pp/core/services/events.dart';
import 'package:pp/core/viewmodels/logs/configuration_viewmodel.dart';

final _logsViewModel = ChangeNotifierProvider<LogsViewModel>((ref) {
  var logsViewModel = LogsViewModel();
  ref.watch(events.stream).listen(logsViewModel.add);
  return logsViewModel;
});

class LogsPage extends HookConsumerWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(_logsViewModel);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListView.separated(
            separatorBuilder: (ctx, idx) => const Divider(),
            itemBuilder: (ctx, idx) => ListTile(
              leading: Text(logs.events[idx].timestamp.toString()),
              title: Text(
                logs.events[idx].path,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(_getIconForEvent(logs.events[idx])),
            ),
            itemCount: logs.events.length,
          ),
        ),
      ),
    );
  }
}

IconData _getIconForEvent(Event e) {
  switch (e.type) {
    case EventType.watchAdd:
      return Icons.add_circle_outlined;
    case EventType.watchModified:
      return Icons.change_circle_outlined;
    case EventType.sendSuccess:
      return Icons.send_outlined;
    case EventType.sendRetry:
      return Icons.schedule_send_outlined;
    case EventType.sendFailure:
      return Icons.cancel_schedule_send_outlined;
    default:
      return Icons.error_outline;
  }
}
