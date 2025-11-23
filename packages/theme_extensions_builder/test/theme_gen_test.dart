import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  final baseTypesReader = await initializeLibraryReaderForDirectory(
    'test/src/theme_gen',
    'base_types.dart',
  );

  final emptyThemeReader = await initializeLibraryReaderForDirectory(
    'test/src/theme_gen',
    'empty_theme.dart',
  );

  group('ThemeGenGenerator', () {
    group('Base types', () {
      testAnnotatedElements<ThemeGen>(
        baseTypesReader,
        ThemeGenGenerator(),
      );
    });

    group('Empty theme', () {
      testAnnotatedElements<ThemeGen>(
        emptyThemeReader,
        ThemeGenGenerator(),
      );
    });
  });
}
