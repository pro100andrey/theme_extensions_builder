import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  final baseTypesReader = await initializeLibraryReaderForDirectory(
    'test/src/theme_extensions',
    'base_types.dart',
  );

  final nullableTypesReader = await initializeLibraryReaderForDirectory(
    'test/src/theme_extensions',
    'nullable_types.dart',
  );

  final customMixinNamesReader = await initializeLibraryReaderForDirectory(
    'test/src/theme_extensions',
    'custom_mixin_name.dart',
  );

  group('ThemeExtensionsGenerator', () {
    group('Base types', () {
      testAnnotatedElements<ThemeExtensions>(
        baseTypesReader,
        ThemeExtensionsGenerator(),
      );
    });

    group('Nullable types', () {
      testAnnotatedElements<ThemeExtensions>(
        nullableTypesReader,
        ThemeExtensionsGenerator(),
      );
    });

    group('Custom mixin names', () {
      testAnnotatedElements<ThemeExtensions>(
        customMixinNamesReader,
        ThemeExtensionsGenerator(),
      );
    });
  });
}
