import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator/theme_extensions_builder_generator.dart';

/// Function used by the build runner
Builder themeExtensionsBuilder(BuilderOptions options) => PartBuilder(
  [
    ThemeExtensionsGenerator(builderOptions: options),
  ],
  '.g.theme.dart',
  header: '''
    // coverage:ignore-file
    // GENERATED CODE - DO NOT MODIFY BY HAND
    // ignore_for_file: type=lint, unused_element
    ''',
  options: options,
);
