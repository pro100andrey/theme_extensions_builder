import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  const generator = ThemeGenGenerator();

  final emptyReader = await initializeLibraryReaderForDirectory(
    'test/fixtures',
    'empty_theme.dart',
  );

  group('Empty', () {
    testAnnotatedElements<ThemeGen>(emptyReader, generator);
  });

  final complexReader = await initializeLibraryReaderForDirectory(
    'test/fixtures',
    'complex_theme.dart',
  );

  group('Complex', () {
    testAnnotatedElements<ThemeGen>(complexReader, generator);
  });

  final wspReader = await initializeLibraryReaderForDirectory(
    'test/fixtures',
    'widget_state_property_theme.dart',
  );

  group('WidgetStateProperty', () {
    testAnnotatedElements<ThemeGen>(wspReader, generator);
  });

  final lookupReader = await initializeLibraryReaderForDirectory(
    'test/fixtures',
    'lookup_theme.dart',
  );

  group('MethodLookup', () {
    testAnnotatedElements<ThemeGen>(lookupReader, generator);
  });

  final inheritedReader = await initializeLibraryReaderForDirectory(
    'test/fixtures',
    'inherited_theme.dart',
  );

  group('Inheritance', () {
    testAnnotatedElements<ThemeGen>(inheritedReader, generator);
  });
}
