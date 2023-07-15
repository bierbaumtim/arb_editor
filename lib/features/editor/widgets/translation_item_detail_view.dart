import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider.dart';
import 'new_placeholder_dialog.dart';
import 'placeholder_listview.dart';
import 'translations_view.dart';

class TranslationItemDetailView extends ConsumerWidget {
  const TranslationItemDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemIndex = ref.watch(selectedTranslationItemIndexProvider);

    if (selectedItemIndex < 0) {
      return const SizedBox.expand();
    }

    final theme = Theme.of(context);
    final items = ref.watch(translationItemsProvider);

    final selectedItem = items[selectedItemIndex];

    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Text(
              selectedItem.key,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const ListTile(
                        title: Text('Description'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: ref.watch(
                            selectedTranslationItemDescriptionTextControllerProvider,
                          ),
                          focusNode: ref.watch(
                            selectedTranslationItemDescriptionFocusNodeProvider,
                          ),
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Placeholder'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_rounded),
                          onPressed: () async => showDialog(
                            context: context,
                            builder: (context) => const NewPlaceholderDialog(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FocusTraversalOrder(
                          order: const NumericFocusOrder(2),
                          child: PlaceholderListView(
                            selectedItem: selectedItem,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TranslationsView(
                    selectedItem: selectedItem,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
