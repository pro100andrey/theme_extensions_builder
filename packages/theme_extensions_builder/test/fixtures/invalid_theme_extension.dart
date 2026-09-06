/// Theme extensions the generator refuses, with the error it reports for
/// each.
///
/// This file is excluded from `generate_for` in `build.yaml`, so the failing
/// generation is only exercised by the test. None of the classes mix
/// in the generated mixin for the same reason; the mixin check runs last, so
/// every other class is stopped by its own error first.
library;

import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'flutter_stubs.dart';

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

/// A reserved word matches the identifier pattern but cannot name a getter.
@ShouldThrow(
  '`class` is a reserved word, so it cannot be used as `contextAccessorName`.',
  todo: 'Use a name that is not a Dart keyword.',
)
@ThemeExtensions(contextAccessorName: 'class')
final class ReservedWordAccessor extends ThemeExtension<ReservedWordAccessor> {
  const ReservedWordAccessor({required this.color});

  final Color color;
}

/// The mixin is declared `on ThemeExtension<Self>` with no type arguments to
/// pass on.
@ShouldThrow(
  '`GenericExtension<T>` is generic, and the generated mixin cannot be: it '
  'instantiates `GenericExtension` without type arguments.',
  todo:
      'Remove the type parameters from `GenericExtension`, or write its theme '
      'methods by hand.',
)
@themeExtensions
final class GenericExtension<T> extends ThemeExtension<GenericExtension<T>> {
  const GenericExtension({required this.value});

  final T value;
}

/// The mixin's `lerp` is an instance method here, which a field cannot
/// override. `ThemeExtension` declares the same method, so the analyzer
/// objects to the field on its own; the generator still names the mixin so
/// that a `@ThemeGen` field of the same name reads the same.
@ShouldThrow(
  r'The generated mixin `_$ReservedFieldExtension` declares `lerp`, so '
  '`ReservedFieldExtension` cannot have a field of that name.',
  todo: 'Rename the field `lerp`.',
)
@themeExtensions
final class ReservedFieldExtension
    extends ThemeExtension<ReservedFieldExtension> {
  const ReservedFieldExtension({required this.lerp});

  // The conflict is the point of this fixture.
  // ignore: conflicting_field_and_method, annotate_overrides
  final double lerp;
}

/// Everything else is in order, so the missing `with` clause is what stops
/// this one.
@ShouldThrow(
  '`MissingMixinExtension` does not apply the generated mixin '
  r'`_$MissingMixinExtension`, which holds the generated methods.',
  todo:
      r'Add `with _$MissingMixinExtension` to the declaration of '
      '`MissingMixinExtension`.',
)
@themeExtensions
final class MissingMixinExtension
    extends ThemeExtension<MissingMixinExtension> {
  const MissingMixinExtension({required this.color});

  final Color color;
}
