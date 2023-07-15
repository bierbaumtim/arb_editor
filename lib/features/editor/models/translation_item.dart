import 'placeholder/placeholder.dart';
import 'translated.dart';

class TranslationItem {
  final String key;
  final String description;
  final List<Translated> translations;
  final List<Placeholder> placeholders;

  const TranslationItem({
    required this.key,
    required this.description,
    required this.translations,
    required this.placeholders,
  });

  TranslationItem addTranslation(Translated translation) => TranslationItem(
        key: key,
        description: description,
        translations: [...translations, translation],
        placeholders: placeholders,
      );

  TranslationItem addPlaceholder(Placeholder placeholder) => TranslationItem(
        key: key,
        description: description,
        translations: translations,
        placeholders: [...placeholders, placeholder],
      );
}
