import 'dart:ui';

import 'package:arb_editor/features/editor/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/option.dart';
import 'provider.dart';

class SearchDialog extends ConsumerWidget {
  const SearchDialog({super.key});

  static const _kConstraints = BoxConstraints(
    minWidth: 800,
    maxWidth: 800,
    maxHeight: 600,
  );

  double _paddingScaleFactor(double textScaleFactor) {
    final clampedTextScaleFactor = clampDouble(textScaleFactor, 1, 2);
    // The final padding scale factor is clamped between 1/3 and 1. For example,
    // a non-scaled padding of 24 will produce a padding between 24 and 8.
    return lerpDouble(1, 1 / 3, clampedTextScaleFactor - 1)!;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    // The paddingScaleFactor is used to adjust the padding of Dialog
    // children.
    final paddingScaleFactor = _paddingScaleFactor(mediaQuery.textScaleFactor);

    var constraints = _kConstraints;

    if (mediaQuery.size.width * 0.7 < _kConstraints.maxWidth) {
      constraints = constraints.copyWith(
        minWidth: mediaQuery.size.width * 0.7,
        maxWidth: mediaQuery.size.width * 0.7,
      );
    }

    if (mediaQuery.size.height * 0.7 < _kConstraints.maxHeight) {
      constraints = constraints.copyWith(
        maxHeight: mediaQuery.size.height * 0.7,
      );
    }

    return Dialog(
      elevation: 4,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 24,
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: constraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _TitleView(
              paddingScaleFactor: paddingScaleFactor,
            ),
            Expanded(
              child: _ContentView(
                paddingScaleFactor: paddingScaleFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleView extends ConsumerWidget {
  const _TitleView({
    // ignore: unused_element
    super.key,
    required this.paddingScaleFactor,
  });

  final double paddingScaleFactor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textDirection = Directionality.maybeOf(context);
    final effectiveTitlePadding =
        const EdgeInsets.fromLTRB(24, 24, 24, 0).resolve(textDirection);

    return Padding(
      padding: EdgeInsets.only(
        left: effectiveTitlePadding.left * paddingScaleFactor,
        right: effectiveTitlePadding.right * paddingScaleFactor,
        top: effectiveTitlePadding.top * paddingScaleFactor,
        bottom: effectiveTitlePadding.bottom,
      ),
      child: DefaultTextStyle(
        style: DialogTheme.of(context).titleTextStyle ??
            theme.textTheme.titleLarge!,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                controller: ref.read(searchTextControllerProvider),
                decoration: InputDecoration(
                  hintText: 'Search',
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: effectiveTitlePadding.right * paddingScaleFactor,
            ),
            FilledButton.tonal(
              onPressed: () =>
                  ref.read(showSearchProvider.notifier).state = false,
              child: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentView extends ConsumerWidget {
  const _ContentView({
    // ignore: unused_element
    super.key,
    required this.paddingScaleFactor,
  });

  final double paddingScaleFactor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textDirection = Directionality.maybeOf(context);

    final effectiveContentPadding =
        const EdgeInsets.fromLTRB(8, 12, 8, 16).resolve(textDirection);

    final results = ref.watch(searchResultsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: effectiveContentPadding.left * paddingScaleFactor,
        right: effectiveContentPadding.right * paddingScaleFactor,
        top: effectiveContentPadding.top,
        bottom: effectiveContentPadding.bottom * paddingScaleFactor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
            child: Text(
              results.mapOr(
                'Nothing found',
                (value) => 'Results: ${value.length}',
              ),
              style: theme.textTheme.titleMedium,
            ),
          ),
          if (results case Some(:final value))
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context, index) => Card(
                  elevation: 10,
                  shadowColor: Colors.transparent,
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    title: Text(value.elementAt(index).name),
                    onTap: () {
                      ref
                          .read(selectedTranslationItemIndexProvider.notifier)
                          .state = value.elementAt(index).index;
                      ref.read(showSearchProvider.notifier).state = false;
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
