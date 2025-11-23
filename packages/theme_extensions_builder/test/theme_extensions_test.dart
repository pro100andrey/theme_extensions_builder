import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  clearBuildLog();

  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'theme_extensions.dart',
  );

  group('ThemeExtensionsGenerator', () {
    testAnnotatedElements<ThemeExtensions>(
      reader,
      ThemeExtensionsGenerator(),
    );
  });
}
