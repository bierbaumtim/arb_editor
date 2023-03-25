import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/translated.dart';
import '../models/translation_item.dart';
import '../provider.dart';
import 'new_translations_language_dialog.dart';

class TranslationsView extends ConsumerWidget {
  const TranslationsView({
    super.key,
    required this.selectedItem,
  });

  final TranslationItem selectedItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final translationsEditingController =
        ref.watch(selectedTranslationItemTextControllerProvider);

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              Center(
                child: Text(
                  'Translations',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: () async => showDialog(
                      context: context,
                      builder: (context) =>
                          const NewTranslationLanguageDialog(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            itemBuilder: (context, index) => _TranslatedCard(
              item: selectedItem.translations[index],
              controller: translationsEditingController[index].controller,
              focusNode: translationsEditingController[index].focusNode,
            ),
            itemCount: selectedItem.translations.length,
          ),
        ),
      ],
    );
  }
}

class _TranslatedCard extends StatelessWidget {
  const _TranslatedCard({
    // ignore: unused_element
    super.key,
    required this.item,
    required this.focusNode,
    required this.controller,
  });

  final Translated item;
  final FocusNode focusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 12,
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          ListTile(
            title: Text(
              item.language,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Add Translation',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.dividerColor,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.dividerColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
