import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as path;
import 'package:riverpod/riverpod.dart';
import 'package:yaml/yaml.dart';

import '../../common/helper.dart';
import '../models/arb_configuration.dart';
import '../models/placeholder/placeholder.dart';
import '../models/placeholder/placeholder_datetime_format.dart';
import '../models/placeholder/placeholder_number_format.dart';
import '../models/placeholder/placeholder_type.dart';
import '../models/translated.dart';
import '../models/translation_item.dart';
import '../states/editor_state.dart';
import '../../common/option.dart';
import '../translations_encoder.dart';

class EditorController extends StateNotifier<EditorState> {
  EditorController() : super(const EditorEmpty());

  void clear() {
    state = const EditorEmpty();
  }

  void replaceTranslationItem(TranslationItem newItem) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .map((i) => i.key == newItem.key ? newItem : i)
            .toList(),
      );
    }
  }

  void createNewTranslationItem(String name) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: [
          ...value.translationItems,
          TranslationItem(
            key: name,
            description: '',
            placeholders: [],
            translations: value.translationItems
                .expand((e) => e.translations.map((t) => t.language))
                .toSet()
                .map((l) => Translated(language: l, text: ''))
                .toList(),
          ),
        ],
      );
    }
  }

  void addLanguage(String language) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .map(
              (item) =>
                  item.translations.where((t) => t.language == language).isEmpty
                      ? item.addTranslation(
                          Translated(language: language, text: ''),
                        )
                      : item,
            )
            .toList(),
      );
    }
  }

  void addPlaceholder(int translationIndex, String placeholderName) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .mapIndexed(
              (i, t) => i == translationIndex
                  ? TranslationItem(
                      key: t.key,
                      description: t.description,
                      translations: t.translations,
                      placeholders: [
                        ...t.placeholders,
                        Placeholder(
                          name: placeholderName,
                          type: const StringPlaceholder(),
                        ),
                      ],
                    )
                  : t,
            )
            .toList(),
      );
    }
  }

  void removePlaceholder(int translationIndex, int placeholderIndex) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .mapIndexed(
              (i, t) => i == translationIndex
                  ? TranslationItem(
                      key: t.key,
                      description: t.description,
                      translations: t.translations,
                      placeholders: t.placeholders
                          .whereIndexed((index, _) => index != placeholderIndex)
                          .toList(),
                    )
                  : t,
            )
            .toList(),
      );
    }
  }

  void updateTranslation(
    int translationIndex,
    int languageIndex,
    String translation,
  ) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .mapIndexed(
              (i, t) => i == translationIndex
                  ? TranslationItem(
                      key: t.key,
                      description: t.description,
                      placeholders: t.placeholders,
                      translations: t.translations
                          .mapIndexed(
                            (index, element) => index == languageIndex
                                ? Translated(
                                    language: element.language,
                                    text: translation,
                                  )
                                : element,
                          )
                          .toList(),
                    )
                  : t,
            )
            .toList(),
      );
    }
  }

  void setTranslationDescription(int translationIndex, String description) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .mapIndexed(
              (i, t) => i == translationIndex
                  ? TranslationItem(
                      key: t.key,
                      description: description,
                      translations: t.translations,
                      placeholders: t.placeholders,
                    )
                  : t,
            )
            .toList(),
      );
    }
  }

  void setPlaceholderName(
    int translationIndex,
    int placeholderIndex,
    String name,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        name: Some(name),
      );

  void setPlaceholderType(
    int translationIndex,
    int placeholderIndex,
    PlaceholderType type,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        type: Some(type),
      );

  void setPlaceholderNumberFormat(
    int translationIndex,
    int placeholderIndex,
    PlaceholderNumberFormat? numberFormat,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        numberFormat: Some(numberFormat),
      );

  void setPlaceholderDateTimeFormat(
    int translationIndex,
    int placeholderIndex,
    PlaceholderDateTimeFormat? dateTimeFormat,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        dateTimeFormat: Some(dateTimeFormat),
      );

  void setPlaceholderDecimalDigits(
    int translationIndex,
    int placeholderIndex,
    String decimalDigits,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        decimalDigits: Some(
          decimalDigits.isEmpty ? null : int.tryParse(decimalDigits),
        ),
      );

  void setPlaceholderSymbol(
    int translationIndex,
    int placeholderIndex,
    String symbol,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        symbol: Some(
          symbol.isEmpty ? null : symbol,
        ),
      );

  void setPlaceholderCustomDateTimeFormat(
    int translationIndex,
    int placeholderIndex,
    String customDateTimeFormat,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        dateTimeFormat: Some(
          CustomPdtf(customDateTimeFormat),
        ),
      );

  void _updatePlaceholder({
    required int translationIndex,
    required int placeholderIndex,
    Option<String> name = const None(),
    Option<PlaceholderType> type = const None(),
    Option<String?> customPattern = const None(),
    Option<PlaceholderNumberFormat?> numberFormat = const None(),
    Option<PlaceholderDateTimeFormat?> dateTimeFormat = const None(),
    Option<String?> symbol = const None(),
    Option<int?> decimalDigits = const None(),
  }) {
    if (state case EditorLoaded value) {
      state = EditorLoaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .mapIndexed(
              (i, t) => i == translationIndex
                  ? TranslationItem(
                      key: t.key,
                      description: t.description,
                      translations: t.translations,
                      placeholders: t.placeholders
                          .mapIndexed(
                            (j, p) => j == placeholderIndex
                                ? Placeholder(
                                    name: name.unwrapOr(p.name),
                                    type: type.unwrapOr(p.type),
                                    customPattern:
                                        customPattern.unwrapOr(p.customPattern),
                                    decimalDigits:
                                        decimalDigits.unwrapOr(p.decimalDigits),
                                    numberFormat:
                                        numberFormat.unwrapOr(p.numberFormat),
                                    dateTimeFormat: dateTimeFormat
                                        .unwrapOr(p.dateTimeFormat),
                                    symbol: symbol.unwrapOr(p.symbol),
                                  )
                                : p,
                          )
                          .toList(),
                    )
                  : t,
            )
            .toList(),
      );
    }
  }

  Future<void> loadFiles(String configPath) async {
    final arbConfig = await _loadConfiguration(configPath);

    if (arbConfig == null) return;

    await _parseTemplate(arbConfig);
    if (state is EditorFailure) return;

    await _parseArbFiles(arbConfig);
    if (state is EditorFailure) return;

    state = EditorLoaded(
      arbConfiguration: arbConfig,
      translationItems: switch (state) {
        EditorLoaded(:final translationItems) => translationItems,
        EditorTemplateLoading(:final translationItems) => translationItems,
        EditorTranslationsLoading(:final translationItems) => translationItems,
        _ => [],
      },
    );
  }

  Future<ArbConfiguration?> _loadConfiguration(String configPath) async {
    try {
      state = const EditorConfigLoading(
        message: 'Loading configuration file',
      );

      final configFile = File(configPath);
      final config = await configFile.readAsString();

      final parsedConfig = loadYaml(config);

      final templateFilePath = parsedConfig['template-arb-file'] as String?;
      final arbDirPath = parsedConfig['arb-dir'] as String?;

      if (templateFilePath == null || arbDirPath == null) {
        state = const EditorFailure(
          message: 'Missing configuration',
        );

        return null;
      }

      return ArbConfiguration(
        arbDir: arbDirPath,
        configPath: configPath,
        templateFile: templateFilePath,
      );
    } catch (e) {
      state = EditorFailure(
        message: 'Failed to load configuration',
        error: e,
      );

      return null;
    }
  }

  Future<void> _parseTemplate(ArbConfiguration arbConfig) async {
    state = EditorTemplateLoading(
      arbConfiguration: arbConfig,
      translationItems: [],
    );

    try {
      final templateFilePath = path.join(
        arbConfig.fullArbDirPath,
        arbConfig.templateFile,
      );
      final templateFile = File(templateFilePath);
      final template = await templateFile.readAsString();

      final parsedTemplate =
          await compute<String, dynamic>(jsonDecode, template)
              as Map<String, dynamic>;

      final language = Helper.getLanguageFromPath(
        arbConfig.templateFile,
      );

      for (final entry in parsedTemplate.entries) {
        if (entry.key.startsWith('@')) {
          continue;
        }

        final options =
            parsedTemplate['@${entry.key}'] as Map<String, dynamic>? ??
                <String, dynamic>{};

        final placeholders = options['placeholders'] as Map<String, dynamic>? ??
            <String, dynamic>{};

        final translationItem = TranslationItem(
          key: entry.key,
          description: options['description'] as String? ?? '',
          translations: [
            Translated(
              language: language,
              text: entry.value,
            ),
          ],
          placeholders: placeholders.entries
              .map<Placeholder>(
                (e) => Placeholder.fromMap(
                  e.key,
                  e.value as Map<String, dynamic>,
                ),
              )
              .toList(),
        );

        state = switch (state) {
          EditorLoaded(:final arbConfiguration, :final translationItems) =>
            EditorTemplateLoading(
              arbConfiguration: arbConfiguration,
              translationItems: [...translationItems, translationItem],
            ),
          EditorTranslationsLoading(
            :final arbConfiguration,
            :final translationItems
          ) =>
            EditorTemplateLoading(
              arbConfiguration: arbConfiguration,
              translationItems: [...translationItems, translationItem],
            ),
          EditorTemplateLoading(
            :final arbConfiguration,
            :final translationItems
          ) =>
            EditorTemplateLoading(
              arbConfiguration: arbConfiguration,
              translationItems: [...translationItems, translationItem],
            ),
          _ => state,
        };
      }
    } catch (e) {
      state = EditorFailure(
        message: 'Failed to parse template',
        error: e,
      );
    }
  }

  Future<void> _parseArbFiles(ArbConfiguration arbConfig) async {
    try {
      final translationsEmpty = switch (state) {
        EditorTemplateLoading(:final translationItems) =>
          translationItems.isEmpty,
        _ => true,
      };

      if (translationsEmpty) {
        if (state is! EditorFailure) {
          state = const EditorFailure(
            message: 'Unable to parse arb files due to previous error',
          );
        }

        return;
      }

      final d = Directory(arbConfig.fullArbDirPath);

      // state = 'Loading arb directory items';
      await for (final item in d.list()) {
        if (item is! File) continue;

        if (path.extension(item.path) != '.arb') continue;

        if (path.basename(item.path) == arbConfig.templateFile) {
          continue;
        }

        state = EditorTranslationsLoading(
          message: 'Loading file ${path.basename(item.path)}',
          arbConfiguration: arbConfig,
          translationItems: switch (state) {
            EditorLoaded(:final translationItems) => translationItems,
            EditorTemplateLoading(:final translationItems) => translationItems,
            EditorTranslationsLoading(:final translationItems) =>
              translationItems,
            _ => [],
          },
        );

        final content = await item.readAsString();
        final parsedContent =
            await compute<String, dynamic>(jsonDecode, content)
                as Map<String, dynamic>;

        final language = Helper.getLanguageFromPath(item.path);

        for (final entry in parsedContent.entries) {
          if (entry.key.startsWith('@')) continue;

          if (state case EditorTranslationsLoading value) {
            state = EditorTranslationsLoading(
              message: value.message,
              arbConfiguration: arbConfig,
              translationItems: value.translationItems
                  .map(
                    (e) => e.key == entry.key
                        ? e.addTranslation(
                            Translated(
                              language: language,
                              text: entry.value,
                            ),
                          )
                        : e,
                  )
                  .toList(),
            );
          }
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      state = EditorFailure(
        message: 'Failed to parse arb files',
        error: e,
      );
    }
  }

  Future<void> saveFile() async {
    final hasUnsavedChanges = switch (state) {
      EditorLoaded(:final hasUnsavedChanges) => hasUnsavedChanges,
      _ => false,
    };

    if (!hasUnsavedChanges) {
      return;
    }

    final files = switch (state) {
      EditorLoaded(:final arbConfiguration, :final translationItems) =>
        TranslationsEncoder.buildFiles(
          arbConfiguration,
          translationItems,
        ),
      _ => {},
    };

    for (final entry in files.entries) {
      var file = File(entry.key);
      if (!await file.exists()) {
        file = await file.create();
      }

      await file.writeAsString(
        await compute<Map<String, dynamic>, String>(
          prettyJsonEncode,
          entry.value,
        ),
      );
    }

    if (state case EditorLoaded value) {
      state = EditorLoaded(
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems,
        hasUnsavedChanges: false,
      );
    }
  }
}

String prettyJsonEncode(Object obj) {
  const encoder = JsonEncoder.withIndent('  ');

  return encoder.convert(obj);
}
