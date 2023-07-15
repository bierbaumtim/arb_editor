sealed class PlaceholderType {
  const PlaceholderType();

  static PlaceholderType fromJson(String json) => switch (json) {
        'int' => const IntPlaceholder(),
        'double' => const DoublePlaceholder(),
        'num' => const NumberPlaceholder(),
        'DateTime' => const DateTimePlaceholder(),
        'String' => const StringPlaceholder(),
        _ => UnknownPlaceholder(json),
      };
}

class IntPlaceholder extends PlaceholderType {
  const IntPlaceholder();
}

class DoublePlaceholder extends PlaceholderType {
  const DoublePlaceholder();
}

class NumberPlaceholder extends PlaceholderType {
  const NumberPlaceholder();
}

class DateTimePlaceholder extends PlaceholderType {
  const DateTimePlaceholder();
}

class StringPlaceholder extends PlaceholderType {
  const StringPlaceholder();
}

class UnknownPlaceholder extends PlaceholderType {
  final String value;

  const UnknownPlaceholder(this.value);
}
