import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/arb_configuration.dart';
import '../models/translation_item.dart';

part 'editor_state.freezed.dart';

@freezed
class EditorState with _$EditorState {
  const factory EditorState.empty() = EditorEmpty;

  const factory EditorState.configLoading({
    required String message,
  }) = EditorConfigLoading;

  const factory EditorState.templateLoading({
    required ArbConfiguration arbConfiguration,
    required List<TranslationItem> translationItems,
  }) = EditorTemplateLoading;

  const factory EditorState.translationsLoading({
    required ArbConfiguration arbConfiguration,
    required List<TranslationItem> translationItems,
    required String message,
  }) = EditorTranslationsLoading;

  const factory EditorState.loaded({
    required ArbConfiguration arbConfiguration,
    required List<TranslationItem> translationItems,
    @Default(false) bool hasUnsavedChanges,
  }) = EditorLoaded;

  const factory EditorState.failure({
    required String message,
    Object? error,
  }) = EditorFailure;
}
