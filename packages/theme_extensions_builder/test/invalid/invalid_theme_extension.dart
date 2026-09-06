/// Theme extensions the generator refuses, with the error it reports for
/// each.
///
/// This directory is not part of `generate_for` in `build.yaml`, so the
/// failing generation is only exercised by the test. None of the classes mix
/// in the generated mixin for the same reason.
library;

import 'package:flutter_stubs/flutter_stubs.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

/// The generated mixin is declared `on ThemeExtension<Self>`.
@ShouldThrow(
  '`NotAThemeExtension` must extend `ThemeExtension<NotAThemeExtension>` to '
  'be annotated with `@ThemeExtensions`.',
  todo:
      'Declare it as `class NotAThemeExtension extends '
      r'ThemeExtension<NotAThemeExtension> with _$NotAThemeExtension`, or '
      'use `@ThemeGen` for a plain class.',
)
@themeExtensions
final class NotAThemeExtension {
  const NotAThemeExtension({required this.color});

  final Color color;
}

/// A valid theme extension that [WrongTypeArgument] borrows its type
/// argument from.
final class OtherExtension extends ThemeExtension<OtherExtension> {
  const OtherExtension();
}

/// Extending `ThemeExtension` of another class is as wrong as not extending
/// it at all.
@ShouldThrow(
  '`WrongTypeArgument` must extend `ThemeExtension<WrongTypeArgument>` to be '
  'annotated with `@ThemeExtensions`.',
  todo:
      'Declare it as `class WrongTypeArgument extends '
      r'ThemeExtension<WrongTypeArgument> with _$WrongTypeArgument`, or use '
      '`@ThemeGen` for a plain class.',
)
@themeExtensions
final class WrongTypeArgument extends ThemeExtension<OtherExtension> {
  const WrongTypeArgument({required this.color});

  final Color color;
}

/// The accessor name is written into the generated extension as is.
@ShouldThrow(
  '`my theme` is not a valid Dart identifier, so it cannot be used as '
  '`contextAccessorName`.',
  todo:
      r'Use letters, digits, `_` and `$` only, and do not start with a '
      'digit.',
)
@ThemeExtensions(contextAccessorName: 'my theme')
final class BadAccessorName extends ThemeExtension<BadAccessorName> {
  const BadAccessorName({required this.color});

  final Color color;
}

/// The named constructor is the one checked against the fields.
@ShouldThrow(
  'The constructor `MissingParameterExtension._internal` has no named '
  'parameter for the field `width`, which the generated code passes to it.',
  todo:
      'Add `this.width` to `MissingParameterExtension._internal`, or mark '
      'the field with `@ignore`.',
)
@ThemeExtensions(constructor: '_internal')
final class MissingParameterExtension
    extends ThemeExtension<MissingParameterExtension> {
  MissingParameterExtension._internal({required this.color}) : width = 0;

  final Color color;
  final double width;
}
