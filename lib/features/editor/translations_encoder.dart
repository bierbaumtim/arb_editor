import 'package:path/path.dart' as path;

import '../common/helper.dart';
import 'models/arb_configuration.dart';
import 'models/translation_item.dart';

class TranslationsEncoder {
  static Map<String, Map<String, dynamic>> buildFiles(
    ArbConfiguration arbConfiguration,
    List<TranslationItem> translationItems,
  ) {
    final files = <String, Map<String, dynamic>>{};
    final templateLanguage = Helper.getLanguageFromPath(
      arbConfiguration.templateFile,
    );

    for (final item in translationItems) {
      for (final translation in item.translations) {
        files.putIfAbsent(translation.language, () => {});

        if (translation.language == templateLanguage) {
          files[templateLanguage]![item.key] = translation.text;
          files[templateLanguage]!.putIfAbsent('@${item.key}', () => {});

          if (item.description.isNotEmpty) {
            files[templateLanguage]!['@${item.key}']!['description'] =
                item.description;
          }

          if (item.placeholders.isNotEmpty) {
            files[templateLanguage]!['@${item.key}']!.putIfAbsent(
              'placeholders',
              () => {},
            );

            for (final placeholder in item.placeholders) {
              final isNumberType = placeholder.type.maybeWhen(
                orElse: () => false,
                double: () => true,
                int: () => true,
                number: () => true,
              );

              final isDateTimeType = placeholder.type.maybeWhen(
                orElse: () => false,
                datetime: () => true,
              );

              files[templateLanguage]!['@${item.key}']!['placeholders']![
                  placeholder.name] = <String, dynamic>{
                'type': placeholder.type.when(
                  datetime: () => 'DateTime',
                  double: () => 'double',
                  int: () => 'int',
                  number: () => 'num',
                  string: () => 'String',
                  unknown: (value) => '',
                ),
                if (isNumberType && placeholder.numberFormat != null)
                  'format': placeholder.numberFormat!.name
                else if (isDateTimeType && placeholder.dateTimeFormat != null)
                  'format': placeholder.dateTimeFormat!.toJsonValue(),
                if (placeholder.decimalDigits != null)
                  'decimalDigits': placeholder.decimalDigits!,
                if (placeholder.symbol != null) 'symbol': placeholder.symbol!,
                if (placeholder.customPattern != null)
                  'customPattern': placeholder.customPattern!,
              };
            }
          }
        } else {
          files[translation.language]![item.key] = translation.text;
        }
      }
    }

    return files.map<String, Map<String, dynamic>>(
      (key, value) => MapEntry(
        path.join(
          arbConfiguration.fullArbDirPath,
          '${arbConfiguration.filePrefix}_$key.arb',
        ),
        value,
      ),
    );
  }
}
