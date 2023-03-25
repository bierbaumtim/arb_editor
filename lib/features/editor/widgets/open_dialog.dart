import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';

class OpenDialog extends ConsumerWidget {
  const OpenDialog({super.key});

  static const _kConstraints = BoxConstraints.tightFor(
    width: 800,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPath = ref.watch(selectedConfigurationFilePathProvider);
    final editorState = ref.watch(editorControllerProvider);

    final editorIsLoading = editorState.maybeWhen<bool>(
      orElse: () => false,
      configLoading: (_) => true,
      templateLoading: (_, __) => true,
      translationsLoading: (_, __, ___) => true,
    );

    return ConstrainedBox(
      constraints: _kConstraints,
      child: SimpleDialog(
        title: const Text('Configuration Selection'),
        children: [
          ConstrainedBox(constraints: _kConstraints),
          ListTile(
            title: const Text('Configuration File'),
            subtitle: selectedPath != null ? Text(selectedPath) : null,
            trailing: FilledButton.tonal(
              onPressed: () async =>
                  ref.read(openDialogController).openFilePicker(),
              child: const Text('Select'),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  editorState.maybeWhen(
                    configLoading: (message) => message,
                    templateLoading: (_, __) => 'Loading template',
                    translationsLoading: (_, __, message) => message,
                    loaded: (_, __, ___) => 'Completed',
                    failure: (message, _) => message,
                    orElse: () => '',
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: selectedPath != null && !editorIsLoading
                      ? () async => ref
                          .read(editorControllerProvider.notifier)
                          .loadFiles(selectedPath)
                      : null,
                  child: editorIsLoading
                      ? const Text('Loading...')
                      : const Text('Load'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
