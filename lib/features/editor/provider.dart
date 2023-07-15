import 'package:flutter/widgets.dart';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/editor_controller.dart';
import 'controller/open_dialog_controller.dart';
import 'models/placeholder/placeholder_datetime_format.dart';
import 'models/translation_item.dart';
import 'states/editor_state.dart';

final selectedConfigurationFilePathProvider = StateProvider<String?>(
  (_) => null,
);

final openDialogController = Provider(
  (ref) => OpenDialogController(ref),
);

final translationItemsScrollControllerProvider =
    Provider.autoDispose<ScrollController>(
  (ref) {
    final controller = ScrollController();

    ref.keepAlive();

    ref.onDispose(() => controller.dispose());

    return controller;
  },
);

final editorControllerProvider =
    StateNotifierProvider<EditorController, EditorState>(
  (_) => EditorController(),
);

final translationItemsProvider = Provider<List<TranslationItem>>(
  (ref) => switch (ref.watch(editorControllerProvider)) {
    EditorLoaded(:final translationItems) => translationItems,
    EditorTemplateLoading(:final translationItems) => translationItems,
    EditorTranslationsLoading(:final translationItems) => translationItems,
    _ => [],
  },
);

final selectedTranslationItemIndexProvider = StateProvider<int>(
  (ref) {
    ref.listenSelf((previous, next) {
      final translationScrollController = ref.read(
        translationItemsScrollControllerProvider,
      );

      if (translationScrollController.hasClients) {
        final nextItemOffset = next < 0 ? 0.0 : next * 48.0;

        if (nextItemOffset < translationScrollController.offset ||
            nextItemOffset >
                (translationScrollController.offset +
                    translationScrollController.position.viewportDimension)) {
          translationScrollController.jumpTo(nextItemOffset);
        }
      }
    });

    return -1;
  },
);

final selectedTranslationItemDescriptionFocusNodeProvider =
    Provider.autoDispose<FocusNode>(
  (ref) {
    final focusNode = FocusNode();

    focusNode.addListener(
      () {
        if (!focusNode.hasFocus) {
          ref.read(editorControllerProvider.notifier).setTranslationDescription(
                ref.read(selectedTranslationItemIndexProvider),
                ref
                    .read(
                        selectedTranslationItemDescriptionTextControllerProvider)
                    .text,
              );
        }
      },
    );

    ref.onDispose(() => focusNode.dispose());

    return focusNode;
  },
);

final selectedTranslationItemDescriptionTextControllerProvider =
    Provider.autoDispose<TextEditingController>(
  (ref) {
    final editingController = TextEditingController();

    final selectedItemIndex = ref.watch(selectedTranslationItemIndexProvider);

    if (selectedItemIndex >= 0) {
      final items = ref.watch(translationItemsProvider);

      editingController.text = items[selectedItemIndex].description;
    } else {
      editingController.clear();
    }

    ref.onDispose(() => editingController.dispose());

    return editingController;
  },
);

final selectedTranslationItemTextControllerProvider =
    Provider.autoDispose<List<TranslatedControllerContainer>>(
  (ref) {
    int previousIndex = -99;
    List<TranslatedControllerContainer> editingController = [];

    final selectedItemIndex = ref.watch(selectedTranslationItemIndexProvider);
    final items = ref.watch(translationItemsProvider);

    if (previousIndex != selectedItemIndex) {
      for (final e in editingController) {
        e.dispose();
      }
      editingController.clear();

      previousIndex = selectedItemIndex;
    }

    if (selectedItemIndex >= 0) {
      final selectedItem = items[selectedItemIndex];

      if (editingController.length != selectedItem.translations.length) {
        if (editingController.isNotEmpty) {
          for (final e in editingController) {
            e.dispose();
          }
          editingController.clear();
        }

        editingController.addAll(
          selectedItem.translations.mapIndexed(
            (index, translation) => TranslatedControllerContainer(
              ref,
              index,
              TextEditingController(text: translation.text),
            ),
          ),
        );
      }
    }

    ref.onDispose(() {
      for (final e in editingController) {
        e.dispose();
      }
    });

    return editingController;
  },
);

final selectedTranslationItemPlaceholderEditingControllerProvider =
    Provider.autoDispose<List<PlaceholderEditingControllerContainer>>(
  (ref) {
    int previousIndex = -99;
    List<PlaceholderEditingControllerContainer> editingController = [];

    final selectedItemIndex = ref.watch(selectedTranslationItemIndexProvider);
    final items = ref.watch(translationItemsProvider);

    if (selectedItemIndex != previousIndex) {
      for (final e in editingController) {
        e.dispose();
      }
      editingController.clear();
    }

    if (selectedItemIndex >= 0) {
      final selectedItem = items[selectedItemIndex];

      if (editingController.length != selectedItem.translations.length) {
        if (editingController.isNotEmpty) {
          for (final e in editingController) {
            e.dispose();
          }
          editingController.clear();
        }

        editingController.addAll(
          selectedItem.placeholders.map(
            (placeholder) => PlaceholderEditingControllerContainer(
              nameController: TextEditingController(text: placeholder.name),
              symbolController: TextEditingController(text: placeholder.symbol),
              decimalDigitsController: TextEditingController(
                text: placeholder.decimalDigits?.toString(),
              ),
              customPatternController: TextEditingController(
                text: placeholder.customPattern,
              ),
              customDateTimeFormatController: TextEditingController(
                text: switch (placeholder.dateTimeFormat) {
                  CustomPdtf(:final pattern) => pattern,
                  _ => null,
                },
              ),
            ),
          ),
        );
      }
    }

    ref.onDispose(() {
      for (final e in editingController) {
        e.dispose();
      }
    });

    return editingController;
  },
);

class PlaceholderEditingControllerContainer {
  final TextEditingController nameController;
  final TextEditingController decimalDigitsController;
  final TextEditingController symbolController;
  final TextEditingController customPatternController;
  final TextEditingController customDateTimeFormatController;

  const PlaceholderEditingControllerContainer({
    required this.nameController,
    required this.decimalDigitsController,
    required this.symbolController,
    required this.customPatternController,
    required this.customDateTimeFormatController,
  });

  void dispose() {
    nameController.dispose();
    decimalDigitsController.dispose();
    symbolController.dispose();
    customPatternController.dispose();
    customDateTimeFormatController.dispose();
  }
}

class TranslatedControllerContainer {
  final Ref ref;
  final int index;
  final FocusNode focusNode;
  final TextEditingController controller;

  TranslatedControllerContainer(
    this.ref,
    this.index,
    this.controller,
  ) : focusNode = FocusNode() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        ref.read(editorControllerProvider.notifier).updateTranslation(
              ref.read(selectedTranslationItemIndexProvider),
              index,
              controller.text,
            );
      }
    });
  }

  void dispose() {
    focusNode.dispose();
    controller.dispose();
  }
}
