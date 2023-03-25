import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;

class ArbConfiguration {
  final String templateFile;
  final String arbDir;
  final String configPath;

  String get fullArbDirPath => path.join(path.dirname(configPath), arbDir);
  String get filePrefix => path
      .basenameWithoutExtension(templateFile)
      .characters
      .takeWhile((c) => c != '_')
      .join();

  const ArbConfiguration({
    required this.templateFile,
    required this.arbDir,
    required this.configPath,
  });
}
