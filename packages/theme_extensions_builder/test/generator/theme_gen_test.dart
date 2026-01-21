import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  final emptyReader = await initializeLibraryReaderForDirectory(
    'test/theme_gen',
    'empty_theme.dart',
  );

  final complexReader = await initializeLibraryReaderForDirectory(
    'test/theme_gen',
    'complex_theme.dart',
  );

  final wspReader = await initializeLibraryReaderForDirectory(
    'test/theme_gen',
    'widget_state_property_theme.dart',
  );

  group('ThemeGenGenerator', () {
    group('Empty', () {
      testAnnotatedElements<ThemeGen>(emptyReader, ThemeGenGenerator());
    });

    group('Complex', () {
      testAnnotatedElements<ThemeGen>(complexReader, ThemeGenGenerator());
    });

    group('WidgetStatePropertyTheme', () {
      testAnnotatedElements<ThemeGen>(wspReader, ThemeGenGenerator());
    });
  });
}
