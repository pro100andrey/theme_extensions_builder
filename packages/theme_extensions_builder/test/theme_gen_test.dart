import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/generator.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'utils/library_reader.dart';

Future<void> main() async {
  initializeBuildLogTracking();

  final emptyThemeReader = await libraryReader(
    'test/lib',
    'empty_theme.dart',
  );

  final mergeCaseThemeReader = await libraryReader(
    'test/lib',
    'merge_case_theme.dart',
  );

  group('ThemeGenGenerator', () {
    testAnnotatedElements<ThemeGen>(
      emptyThemeReader,
      ThemeGenGenerator(),
    );

    testAnnotatedElements<ThemeGen>(
      mergeCaseThemeReader,
      ThemeGenGenerator(),
    );
  });
}
