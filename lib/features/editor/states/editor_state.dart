import '../models/arb_configuration.dart';
import '../models/translation_item.dart';

sealed class EditorState {
  const EditorState();
}

class EditorEmpty extends EditorState {
  const EditorEmpty();
}

class EditorConfigLoading extends EditorState {
  final String message;

  const EditorConfigLoading({
    required this.message,
  });
}

class EditorTemplateLoading extends EditorState {
  final ArbConfiguration arbConfiguration;
  final List<TranslationItem> translationItems;

  const EditorTemplateLoading({
    required this.arbConfiguration,
    required this.translationItems,
  });
}

class EditorTranslationsLoading extends EditorState {
  final ArbConfiguration arbConfiguration;
  final List<TranslationItem> translationItems;
  final String message;

  const EditorTranslationsLoading({
    required this.arbConfiguration,
    required this.translationItems,
    required this.message,
  });
}

class EditorLoaded extends EditorState {
  final ArbConfiguration arbConfiguration;
  final List<TranslationItem> translationItems;
  final bool hasUnsavedChanges;

  const EditorLoaded({
    required this.arbConfiguration,
    required this.translationItems,
    this.hasUnsavedChanges = false,
  });
}

class EditorFailure extends EditorState {
  final String message;
  final Object? error;

  const EditorFailure({
    required this.message,
    this.error,
  });
}
