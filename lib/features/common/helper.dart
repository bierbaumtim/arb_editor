import 'package:flutter/widgets.dart';

import 'package:path/path.dart' as path;

class Helper {
  static String getLanguageFromPath(String itemPath) => path
      .basenameWithoutExtension(itemPath)
      .characters
      .skipWhile((c) => c != '_')
      .skip(1)
      .join();
}
