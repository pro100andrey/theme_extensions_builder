import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/generator.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  final themeGenReader = await initializeLibraryReaderForDirectory(
    'test/invalid',
    'invalid_theme.dart',
  );

  group('Invalid ThemeGen', () {
    testAnnotatedElements<ThemeGen>(themeGenReader, const ThemeGenGenerator());
  });

  final themeExtensionsReader = await initializeLibraryReaderForDirectory(
    'test/invalid',
    'invalid_theme_extension.dart',
  );

  group('Invalid ThemeExtensions', () {
    testAnnotatedElements<ThemeExtensions>(
      themeExtensionsReader,
      const ThemeExtensionsGenerator(),
    );
  });
}
