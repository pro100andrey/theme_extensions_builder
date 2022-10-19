import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions_builder_generator.dart';

/// Function used by the build runner
Builder themeExtensionsBuilder(BuilderOptions options) {
  return PartBuilder(
    [
      ThemeExtensionsGenerator(builderOptions: options),
    ],
    '.g.dart',
    header: '''
    // coverage:ignore-file
    // GENERATED CODE - DO NOT MODIFY BY HAND
    // ignore_for_file: type=lint, unused_element
    ''',
    options: options,
  );
}
