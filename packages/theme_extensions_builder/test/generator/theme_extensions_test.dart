import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  const generator = ThemeExtensionsGenerator();

  final emptyReader = await initializeLibraryReaderForDirectory(
    'test/theme_extensions',
    'empty_theme_extension.dart',
  );

  group('Empty', () {
    testAnnotatedElements<ThemeExtensions>(emptyReader, generator);
  });

  final complexReader = await initializeLibraryReaderForDirectory(
    'test/theme_extensions',
    'complex_theme_extension.dart',
  );
  group('Complex', () {
    testAnnotatedElements<ThemeExtensions>(complexReader, generator);
  });
}
