import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as path;
import 'package:riverpod/riverpod.dart';
import 'package:yaml/yaml.dart';

import '../../common/helper.dart';
import '../models/arb_configuration.dart';
import '../models/placeholder.dart';
import '../models/translated.dart';
import '../models/translation_item.dart';
import '../states/editor_state.dart';
import '../../common/option.dart';
import '../translations_encoder.dart';

class EditorController extends StateNotifier<EditorState> {
  EditorController() : super(const EditorState.empty());

  void clear() {
    state = const EditorState.empty();
  }

  void replaceTranslationItem(TranslationItem newItem) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
        hasUnsavedChanges: true,
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems
            .map((i) => i.key == newItem.key ? newItem : i)
            .toList(),
      ),
    );
  }

  void createNewTranslationItem(String name) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
      ),
    );
  }

  void addLanguage(String language) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
      ),
    );
  }

  void addPlaceholder(int translationIndex, String placeholderName) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
                          type: const PlaceholderType.string(),
                        ),
                      ],
                    )
                  : t,
            )
            .toList(),
      ),
    );
  }

  void removePlaceholder(int translationIndex, int placeholderIndex) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
      ),
    );
  }

  void updateTranslation(
    int translationIndex,
    int languageIndex,
    String translation,
  ) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
      ),
    );
  }

  void setTranslationDescription(int translationIndex, String description) {
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
      ),
    );
  }

  void setPlaceholderName(
    int translationIndex,
    int placeholderIndex,
    String name,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        name: Option.some(name),
      );

  void setPlaceholderType(
    int translationIndex,
    int placeholderIndex,
    PlaceholderType type,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        type: Option.some(type),
      );

  void setPlaceholderNumberFormat(
    int translationIndex,
    int placeholderIndex,
    PlaceholderNumberFormat? numberFormat,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        numberFormat: Option.some(numberFormat),
      );

  void setPlaceholderDateTimeFormat(
    int translationIndex,
    int placeholderIndex,
    PlaceholderDateTimeFormat? dateTimeFormat,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        dateTimeFormat: Option.some(dateTimeFormat),
      );

  void setPlaceholderDecimalDigits(
    int translationIndex,
    int placeholderIndex,
    String decimalDigits,
  ) =>
      _updatePlaceholder(
        translationIndex: translationIndex,
        placeholderIndex: placeholderIndex,
        decimalDigits: Option.some(
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
        symbol: Option.some(
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
        dateTimeFormat: Option.some(
          PlaceholderDateTimeFormat.custom(customDateTimeFormat),
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
    state = state.map(
      empty: (value) => value,
      configLoading: (value) => value,
      failure: (value) => value,
      translationsLoading: (value) => value,
      templateLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
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
                                    name: name.when(
                                      none: () => p.name,
                                      some: (value) => value,
                                    ),
                                    type: type.when(
                                      none: () => p.type,
                                      some: (value) => value,
                                    ),
                                    customPattern: customPattern.when(
                                      none: () => p.customPattern,
                                      some: (value) => value,
                                    ),
                                    decimalDigits: decimalDigits.when(
                                      none: () => p.decimalDigits,
                                      some: (value) => value,
                                    ),
                                    numberFormat: numberFormat.when(
                                      none: () => p.numberFormat,
                                      some: (value) => value,
                                    ),
                                    dateTimeFormat: dateTimeFormat.when(
                                      none: () => p.dateTimeFormat,
                                      some: (value) => value,
                                    ),
                                    symbol: symbol.when(
                                      none: () => p.symbol,
                                      some: (value) => value,
                                    ),
                                  )
                                : p,
                          )
                          .toList(),
                    )
                  : t,
            )
            .toList(),
      ),
    );
  }

  Future<void> loadFiles(String configPath) async {
    final arbConfig = await _loadConfiguration(configPath);

    if (arbConfig == null) return;

    await _parseTemplate(arbConfig);
    if (state is EditorFailure) return;

    await _parseArbFiles(arbConfig);
    if (state is EditorFailure) return;

    state = EditorState.loaded(
      arbConfiguration: arbConfig,
      translationItems: state.maybeWhen(
        orElse: () => [],
        loaded: (_, translationItems, __) => translationItems,
        templateLoading: (_, translationItems) => translationItems,
        translationsLoading: (_, translationItems, __) => translationItems,
      ),
    );
  }

  Future<ArbConfiguration?> _loadConfiguration(String configPath) async {
    try {
      state = const EditorState.configLoading(
        message: 'Loading configuration file',
      );

      final configFile = File(configPath);
      final config = await configFile.readAsString();

      final parsedConfig = loadYaml(config);

      final templateFilePath = parsedConfig['template-arb-file'] as String?;
      final arbDirPath = parsedConfig['arb-dir'] as String?;

      if (templateFilePath == null || arbDirPath == null) {
        state = const EditorState.failure(
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
      state = EditorState.failure(
        message: 'Failed to load configuration',
        error: e,
      );

      return null;
    }
  }

  Future<void> _parseTemplate(ArbConfiguration arbConfig) async {
    state = EditorState.templateLoading(
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

        state = state.map(
          empty: (value) => value,
          configLoading: (value) => value,
          failure: (value) => value,
          loaded: (value) => EditorState.templateLoading(
            arbConfiguration: value.arbConfiguration,
            translationItems: [...value.translationItems, translationItem],
          ),
          translationsLoading: (value) => EditorState.templateLoading(
            arbConfiguration: value.arbConfiguration,
            translationItems: [...value.translationItems, translationItem],
          ),
          templateLoading: (value) => EditorState.templateLoading(
            arbConfiguration: value.arbConfiguration,
            translationItems: [...value.translationItems, translationItem],
          ),
        );
      }
    } catch (e) {
      state = EditorState.failure(
        message: 'Failed to parse template',
        error: e,
      );
    }
  }

  Future<void> _parseArbFiles(ArbConfiguration arbConfig) async {
    try {
      if (!state.maybeWhen(
        orElse: () => false,
        templateLoading: (_, translationItems) => translationItems.isNotEmpty,
      )) {
        if (state is! EditorFailure) {
          state = const EditorState.failure(
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

        state = EditorState.translationsLoading(
          message: 'Loading file ${path.basename(item.path)}',
          arbConfiguration: arbConfig,
          translationItems: state.maybeWhen(
            orElse: () => [],
            loaded: (_, translationItems, __) => translationItems,
            templateLoading: (_, translationItems) => translationItems,
            translationsLoading: (_, translationItems, __) => translationItems,
          ),
        );

        final content = await item.readAsString();
        final parsedContent =
            await compute<String, dynamic>(jsonDecode, content)
                as Map<String, dynamic>;

        final language = Helper.getLanguageFromPath(item.path);

        for (final entry in parsedContent.entries) {
          if (entry.key.startsWith('@')) continue;

          state = state.map(
            empty: (value) => value,
            failure: (value) => value,
            configLoading: (value) => value,
            loaded: (value) => value,
            templateLoading: (value) => value,
            translationsLoading: (value) => EditorState.translationsLoading(
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
            ),
          );
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      state = EditorState.failure(
        message: 'Failed to parse arb files',
        error: e,
      );
    }
  }

  Future<void> saveFile() async {
    if (!state.maybeWhen(
      orElse: () => false,
      loaded: (_, __, hasUnsavedChanges) => hasListeners,
    )) {
      return;
    }

    final files = state.maybeWhen(
      orElse: () => {},
      loaded: (arbConfiguration, translationItems, _) =>
          TranslationsEncoder.buildFiles(
        arbConfiguration,
        translationItems,
      ),
    );

    for (final entry in files.entries) {
      var file = File(entry.key);
      if (!await file.exists()) {
        file = await file.create();
      }

      await file.writeAsString(
        await compute<Map<String, dynamic>, String>(jsonEncode, entry.value),
      );
    }

    state = state.map(
      empty: (value) => value,
      failure: (value) => value,
      configLoading: (value) => value,
      templateLoading: (value) => value,
      translationsLoading: (value) => value,
      loaded: (value) => EditorState.loaded(
        arbConfiguration: value.arbConfiguration,
        translationItems: value.translationItems,
        hasUnsavedChanges: false,
      ),
    );
  }
}
