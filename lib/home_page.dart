import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/translation_item.dart';
import 'provider.dart';
import 'widgets/new_translation_item_dialog.dart';
import 'widgets/open_dialog.dart';
import 'widgets/translation_item_detail_view.dart';
import 'widgets/translation_item_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorControllerProvider);
    final selectedItemIndex = ref.watch(selectedTranslationItemIndexProvider);

    final items = editorState.maybeWhen<List<TranslationItem>>(
      orElse: () => [],
      loaded: (_, translationItems, __) => translationItems,
      templateLoading: (_, translationItems) => translationItems,
      translationsLoading: (_, translationItems, __) => translationItems,
    );

    final showConfigSelection = editorState.maybeWhen<bool>(
      orElse: () => true,
      loaded: (_, __, ___) => false,
    );

    final mustSave = editorState.maybeWhen<bool>(
      orElse: () => false,
      loaded: (_, __, hasUnsavedChanges) => hasUnsavedChanges,
    );

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(96),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
                    child: Text(
                      'Arb Editor',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.file_open_rounded),
                    onPressed: mustSave
                        ? null
                        : () {
                            ref.read(editorControllerProvider.notifier).clear();
                            ref
                                .read(selectedTranslationItemIndexProvider
                                    .notifier)
                                .state = -1;
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.save_rounded),
                    onPressed: mustSave
                        ? () async => ref
                            .read(editorControllerProvider.notifier)
                            .saveFile()
                        : null,
                  ),
                ],
              ),
            ),
          ),
          body: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: const Text('Add Item'),
                          trailing: const Icon(Icons.add_rounded),
                          onTap: () async => showDialog(
                            context: context,
                            builder: (context) =>
                                const NewTranslationItemDialog(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: ref
                              .watch(translationItemsScrollControllerProvider),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          itemBuilder: (context, index) => TransactionItemTile(
                            item: items[index],
                            isSelected: selectedItemIndex == index,
                            onTap: () => ref
                                .read(selectedTranslationItemIndexProvider
                                    .notifier)
                                .state = index,
                          ),
                          itemCount: items.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 3,
                child: Card(
                  margin: EdgeInsets.only(left: 4, top: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  elevation: 4,
                  child: TranslationItemDetailView(),
                ),
              ),
            ],
          ),
        ),
        if (showConfigSelection)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const ColoredBox(
              color: Color(0x50000000),
              child: SizedBox.expand(
                child: Center(
                  child: OpenDialog(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
