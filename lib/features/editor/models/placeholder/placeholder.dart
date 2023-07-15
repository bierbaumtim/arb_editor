import 'placeholder_datetime_format.dart';
import 'placeholder_number_format.dart';
import 'placeholder_type.dart';

class Placeholder {
  final String name;
  final PlaceholderType type;
  final PlaceholderNumberFormat? numberFormat;
  final PlaceholderDateTimeFormat? dateTimeFormat;
  final int? decimalDigits;
  final String? symbol;
  final String? customPattern;

  const Placeholder({
    required this.name,
    required this.type,
    this.numberFormat,
    this.dateTimeFormat,
    this.decimalDigits,
    this.symbol,
    this.customPattern,
  });

  factory Placeholder.fromMap(String name, Map<String, dynamic> json) {
    final optionalParameters =
        json['optionalParameters'] as Map<String, dynamic>? ??
            <String, dynamic>{};

    final type = PlaceholderType.fromJson(json['type'] as String? ?? '');
    final isDateTimeType = type is DateTimePlaceholder;
    final isNumberType = switch (type) {
      IntPlaceholder() || DoublePlaceholder() || NumberPlaceholder() => true,
      _ => false,
    };

    return Placeholder(
      name: name,
      type: type,
      numberFormat: isNumberType
          ? _placeholderFormatFromJson(json['format'] as String?)
          : null,
      dateTimeFormat: isDateTimeType
          ? PlaceholderDateTimeFormat.fromJson(json['type'] as String? ?? '')
          : null,
      decimalDigits: optionalParameters['decimalDigits'] as int?,
      customPattern: optionalParameters['customPattern'] as String?,
      symbol: optionalParameters['symbol'] as String?,
    );
  }

  static PlaceholderNumberFormat? _placeholderFormatFromJson(String? value) =>
      switch (value) {
        'compact' => PlaceholderNumberFormat.compact,
        'compactCurrency' => PlaceholderNumberFormat.compactCurrency,
        'compactSimpleCurrency' =>
          PlaceholderNumberFormat.compactSimpleCurrency,
        'compactLong' => PlaceholderNumberFormat.compactLong,
        'currency' => PlaceholderNumberFormat.currency,
        'decimalPattern' => PlaceholderNumberFormat.decimalPattern,
        'decimalPercentPattern' =>
          PlaceholderNumberFormat.decimalPercentPattern,
        'percentPattern' => PlaceholderNumberFormat.percentPattern,
        'scientificPattern' => PlaceholderNumberFormat.scientificPattern,
        'simpleCurrency' => PlaceholderNumberFormat.simpleCurrency,
        _ => null,
      };
}
