import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'mock.dart';

/// `WidgetStateProperty.lerp` needs a lerp function with nullable parameters,
/// so the generic of a `WidgetStateProperty` field has to be nullable.
///
/// This directory is not part of `generate_for` in `build.yaml`, so the
/// failing generation is only exercised by the test.
@ShouldThrow(
  'WidgetStateProperty must have a nullable generic type, because '
  'WidgetStateProperty.lerp requires a lerp function with nullable '
  'parameters. Found: WidgetStateProperty<Color>',
  todo: 'Change the type of color to WidgetStateProperty<Color?>',
)
@themeGen
final class NonNullableWidgetStatePropertyTheme {
  const NonNullableWidgetStatePropertyTheme({required this.color});

  final WidgetStateProperty<Color> color;
}
