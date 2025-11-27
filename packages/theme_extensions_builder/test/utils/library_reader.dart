import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:source_gen_test/source_gen_test.dart';

/// Initializes a [LibraryReader] for the given [targetLibraryFileName]
/// located in the [sourceDirectory].
Future<LibraryReader> libraryReader(
  String sourceDirectory,
  String targetLibraryFileName,
) async {
  final map = Map.fromEntries(
    Directory(sourceDirectory)
        .listSync(recursive: true)
        .where(
          (entity) =>
              entity is File &&
              // Skip for generated files
              !p.basename(entity.path).endsWith('.g.theme.dart'),
        )
        .whereType<File>()
        .map(
          (f) => MapEntry(p.basename(f.path), f.readAsStringSync()),
        ),
  );

  final reader = await initializeLibraryReader(
    map,
    targetLibraryFileName,
  );

  return reader;
}
