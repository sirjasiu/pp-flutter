import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/core/services/file_watcher_service.dart';
import 'package:pp/core/services/wartched_dir_viewmodel.dart';
import 'package:vrouter/vrouter.dart';

class HomePage extends HookConsumerWidget {
  final Widget child;

  const HomePage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SizedBox(
            height: 64,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 128,
                      child: SvgPicture.asset(
                        "assets/img/logo.svg",
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const _Button(Icons.settings)
              ],
            ),
          ),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
        ),
      ),
      body: Column(
        children: [
          SizedBox(
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.blueGrey.withAlpha(50),
                  Colors.transparent
                ], stops: const [
                  0.5,
                  1
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      if (context.vRouter.path != "/")
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          child: const Text("< Back"),
                          onPressed: context.vRouter.pop,
                        ),
                      const Spacer(),
                      HookConsumer(builder: (ctx, ref, _) {
                        var watchedDir = ref.watch(watchedDirViewModel);
                        return RichText(
                          text: TextSpan(
                            text: "Watched directory: ",
                            style: Theme.of(ctx).textTheme.bodyText1,
                            children: [
                              TextSpan(
                                  style: watchedDir == null
                                      ? const TextStyle(
                                          color: Colors.red,
                                          overflow: TextOverflow.ellipsis)
                                      : const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                  text: watchedDir ?? "Finish configuration"),
                            ],
                          ),
                        );
                      }),
                      HookConsumer(builder: (ctx, ref, _) {
                        var fileWatcher = ref.watch(fileWatcherService);

                        return fileWatcher.working ?
                        const Icon(Icons.play_arrow, color: Colors.green, size: 16,) :
                        const Icon(Icons.stop, color: Colors.red, size: 16,)
                        ;
                      })
                    ],
                  ),
                ),
              )),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Button extends HookWidget {
  final IconData icon;

  const _Button(this.icon);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: InkWell(
        onTap: () => context.vRouter.to("/config"),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: [
            CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xfff5f5f5),
                child: Icon(icon, color: Colors.black)),
          ]),
        ),
      ),
    );
  }
}
