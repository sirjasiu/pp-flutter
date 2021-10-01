import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pp/app/common_widgets/input_wrapper.dart';
import 'package:pp/core/services/wartched_dir_viewmodel.dart';
import 'package:pp/core/viewmodels/configuration/configuration_viewmodel.dart';

final _configurationViewModel = ChangeNotifierProvider<ConfigurationViewModel>(
  (ref) => ConfigurationViewModel(ref.watch(watchedDirViewModel.notifier)),
);

class ConfigurationPage extends HookConsumerWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(_configurationViewModel);
    final watchedDirController =
        useTextEditingController();
    useEffect(() {
       watchedDirController.text = viewModel.watchedDirectory ?? '';
    });
    return Center(
        child: Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 64, left: 12, right: 12),
            child: Card(
                elevation: 0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InputWrapper(
                          width: 450,
                          label: "Watched dir",
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (viewModel.watchedDirectory != null)
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: viewModel.removeDir,
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.folder_open),
                                    onPressed: viewModel.selectDir,
                                  ),
                                ],
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            controller: watchedDirController,
                          ),
                        ),
                      ),
                    ]))));
  }
}
