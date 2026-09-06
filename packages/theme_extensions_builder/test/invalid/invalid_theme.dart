/// Classes the generator refuses, with the error it reports for each.
///
/// This directory is not part of `generate_for` in `build.yaml`, so the
/// failing generation is only exercised by the test. None of the classes mix
/// in the generated mixin for the same reason.
library;

import 'package:flutter_stubs/flutter_stubs.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

/// `WidgetStateProperty.lerp` needs a lerp function with nullable parameters,
/// so the generic of a `WidgetStateProperty` field has to be nullable.
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

/// The `constructor` option names a constructor that does not exist.
@ShouldThrow(
  '`MissingNamedConstructorTheme` has no constructor named `_internal`.',
  todo:
      'Declare `MissingNamedConstructorTheme._internal({...})`, or point '
      '`constructor:` at an existing constructor.',
)
@ThemeGen(constructor: '_internal')
final class MissingNamedConstructorTheme {
  const MissingNamedConstructorTheme({required this.color});

  final Color color;
}

/// Without a `constructor` option the unnamed constructor is called, and this
/// class only has a named one.
@ShouldThrow(
  '`MissingUnnamedConstructorTheme` has no unnamed constructor, which the '
  'generated code calls.',
  todo:
      'Declare `MissingUnnamedConstructorTheme({...})`, or point '
      '`constructor:` at the constructor to use.',
)
@themeGen
final class MissingUnnamedConstructorTheme {
  const MissingUnnamedConstructorTheme.named({required this.color});

  final Color color;
}

/// Every field is passed to the constructor by name, so a field the
/// constructor does not take cannot be generated for.
@ShouldThrow(
  'The constructor `MissingParameterTheme` has no named parameters for the '
  'fields `width`, `height`, which the generated code passes to it.',
  todo:
      'Add `this.width` and the others to `MissingParameterTheme`, or mark '
      'the fields with `@ignore`.',
)
@themeGen
final class MissingParameterTheme {
  MissingParameterTheme({required this.color}) : width = 0, height = 0;

  final Color color;
  final double width;
  final double height;
}

/// A positional parameter is not a named one.
@ShouldThrow(
  'The constructor `PositionalParameterTheme` has no named parameter for the '
  'field `color`, which the generated code passes to it.',
  todo:
      'Add `this.color` to `PositionalParameterTheme`, or mark the field '
      'with `@ignore`.',
)
@themeGen
final class PositionalParameterTheme {
  const PositionalParameterTheme(this.color);

  final Color color;
}
