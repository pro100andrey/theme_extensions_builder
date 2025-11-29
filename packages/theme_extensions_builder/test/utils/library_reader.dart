import 'package:source_gen/source_gen.dart';
import 'package:source_gen_test/source_gen_test.dart';

/// Initializes a [LibraryReader] for the given [targetLibraryFileName]
/// located in the [sourceDirectory].
///
/// Note: mock.dart should be available in the sourceDirectory
/// (can be a symlink to test/lib/mock.dart)
Future<LibraryReader> libraryReader(
  String sourceDirectory,
  String targetLibraryFileName,
) async {
  final reader = await initializeLibraryReaderForDirectory(
    sourceDirectory,
    targetLibraryFileName,
  );

  return reader;
}
