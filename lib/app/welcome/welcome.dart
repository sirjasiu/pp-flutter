import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/model/event.dart';
import 'package:pp/core/services/events.dart';
import 'package:pp/core/services/file_watcher_service.dart';
import 'package:pp/core/services/wartched_dir_viewmodel.dart';
import 'package:vrouter/vrouter.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final working =
        ref.watch(fileWatcherService.select((value) => value.working));
    var watchedDir = ref.watch(watchedDirViewModel);
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 40, bottom: 12, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              child: Column(
                children: [
                  if (working)
                    const ClipRRect(
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        color: Colors.green,
                        backgroundColor: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          topLeft: Radius.circular(4)),
                    )
                  else
                    SizedBox(
                      height: 6,
                      child: Container(),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // added line
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          working ? 'Running' : 'Stopped',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        IconButton(
                          iconSize: 40,
                          icon: working
                              ? const Icon(
                                  Icons.stop_circle,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.play_circle,
                                  color: Colors.green,
                                ),
                          onPressed: watchedDir != null ? () async {
                            var fileWatcher = ref.read(fileWatcherService);
                            if (working) {
                              await fileWatcher.stop();
                            } else {
                              await fileWatcher.start();
                            }
                          } : null,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // added line
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Card(
                            elevation: 0,
                            child: InkWell(
                              onTap: () => context.vRouter.to("/stats"),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ...buildBackground('assets/img/chart.jpg'),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.insert_chart,
                                              size: 40, color: Colors.orange),
                                          Text(
                                            'Stats',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Card(
                            elevation: 0,
                            child: InkWell(
                              onTap: () => context.vRouter.to("/logs"),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ...buildBackground('assets/img/logs.jpg'),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.list_alt,
                                              size: 40, color: Colors.blueGrey),
                                          Text(
                                            'Logs',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              child: HookConsumer(builder: (ctx, ref, _) {
                var event = ref.watch(events);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // added line
                    children: [
                      const Text("Log: "),
                      const SizedBox(width: 30),
                      Expanded(
                        child: event.when(
                          data: (event) => Text(
                            "${describeEventType(event.type)} ${event.path}",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                          error: (e, _) {
                            return const Text("error",
                                textAlign: TextAlign.end);
                          },
                          loading: () => const Text("noting yet",
                              textAlign: TextAlign.end),
                        ),
                      )
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildBackground(String img) {
    return [
      Positioned.fill(
        child: Image.asset(
          img,
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white.withAlpha(150)],
              stops: const [0.2, 0.9],
            ),
          ),
        ),
      )
    ];
  }
}
