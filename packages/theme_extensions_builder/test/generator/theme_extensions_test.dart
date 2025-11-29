import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  final emptyThemeReader = await initializeLibraryReaderForDirectory(
    'test/theme_extensions',
    'empty_theme_extension.dart',
  );

  final allOptionalParametersReader = await initializeLibraryReaderForDirectory(
    'test/theme_extensions',
    'all_optional_parameters.dart',
  );

  group('ThemeExtensionsGenerator', () {
    testAnnotatedElements<ThemeExtensions>(
      emptyThemeReader,
      ThemeExtensionsGenerator(),
    );

    testAnnotatedElements<ThemeExtensions>(
      allOptionalParametersReader,
      ThemeExtensionsGenerator(),
    );
  });
}
