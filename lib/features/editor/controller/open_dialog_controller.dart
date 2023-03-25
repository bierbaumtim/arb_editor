import 'package:arb_editor/features/editor/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class OpenDialogController {
  final Ref ref;

  const OpenDialogController(this.ref);

  Future<void> openFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      dialogTitle: 'Pick configuration file',
      withData: false,
      withReadStream: false,
      allowedExtensions: [
        'yml',
        'yaml',
      ],
    );

    if (result != null && result.isSinglePick) {
      ref.read(selectedConfigurationFilePathProvider.notifier).state =
          result.paths.first;
      ref.read(editorControllerProvider.notifier).clear();
    }
  }
}
