import 'package:flutter/widgets.dart';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../editor/models/translation_item.dart';
import '../editor/provider.dart';
import '../common/option.dart';
import 'search_result.dart';

final showSearchProvider = StateProvider<bool>(
  (ref) => false,
);

final searchTextControllerProvider =
    ChangeNotifierProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

final searchResultsProvider = Provider.autoDispose<Option<List<SearchResult>>>(
  (ref) {
    final query = ref.watch(searchTextControllerProvider.select((t) => t.text));

    if (query.isEmpty) return const None();

    final items = ref
        .watch(editorControllerProvider)
        .maybeWhen<List<TranslationItem>>(
          orElse: () => <TranslationItem>[],
          loaded: (_, translationItems, __) => translationItems,
          templateLoading: (_, translationItems) => translationItems,
          translationsLoading: (_, translationItems, __) => translationItems,
        )
        .mapIndexed<Option<SearchResult>>(
          (index, item) =>
              item.key.contains(query) || item.description.contains(query)
                  ? Some(
                      SearchResult(index, item.key),
                    )
                  : const None(),
        )
        .whereType<Some<SearchResult>>()
        .map((item) => item.value)
        .toList();

    return items.isEmpty ? const None() : Some(items);
  },
);
