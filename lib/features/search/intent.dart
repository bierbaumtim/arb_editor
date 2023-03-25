import 'package:flutter/widgets.dart';

class SearchIntent extends Intent {
  final VoidCallback openSearch;

  const SearchIntent(this.openSearch);
}

class SearchAction extends Action<SearchIntent> {
  @override
  Object? invoke(SearchIntent intent) {
    intent.openSearch();

    return null;
  }
}
