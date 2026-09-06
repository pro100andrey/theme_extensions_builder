/// Classes the generator refuses, with the error it reports for each.
///
/// This file is excluded from `generate_for` in `build.yaml`, so the failing
/// generation is only exercised by the test. None of the classes mix
/// in the generated mixin for the same reason; the mixin check runs last, so
/// every other class is stopped by its own error first.
library;

import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'flutter_stubs.dart';

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

/// `@ignore` takes the field out of the generated constructor call, so its
/// parameter has to be optional.
@ShouldThrow(
  'The constructor `IgnoredRequiredParameterTheme` requires `label`, which '
  'is not among the fields the generated code passes to it.',
  todo:
      'Make `label` optional, or make it a field the generated code passes: '
      'declare it as `this.label`, without `@ignore` on the field.',
)
@themeGen
final class IgnoredRequiredParameterTheme {
  const IgnoredRequiredParameterTheme({
    required this.color,
    required this.label,
  });

  final Color color;

  @ignore
  final String label;
}

/// A required parameter that is not a field cannot be filled in either;
/// positional ones never are.
@ShouldThrow(
  'The constructor `ExtraParameterTheme` requires `scale`, `label`, which '
  'are not among the fields the generated code passes to it.',
  todo:
      'Make `scale` and the others optional, or make them fields the '
      'generated code passes: declare them as `this.scale`, without '
      '`@ignore` on the field.',
)
@themeGen
final class ExtraParameterTheme {
  ExtraParameterTheme(
    double scale, {
    required this.color,
    required String label,
  }) : assert(scale >= 0, 'scale must not be negative'),
       assert(label.isNotEmpty, 'label must not be empty');

  final Color color;
}

/// The generated mixin names the class without type arguments.
@ShouldThrow(
  '`GenericTheme<T>` is generic, and the generated mixin cannot be: it '
  'instantiates `GenericTheme` without type arguments.',
  todo:
      'Remove the type parameters from `GenericTheme`, or write its theme '
      'methods by hand.',
)
@themeGen
final class GenericTheme<T> {
  const GenericTheme({required this.value});

  final T value;
}

/// A field is a getter, and the mixin's `merge` is a method of the same name.
@ShouldThrow(
  r'The generated mixin `_$ReservedFieldTheme` declares `merge`, so '
  '`ReservedFieldTheme` cannot have a field of that name.',
  todo: 'Rename the field `merge`.',
)
@themeGen
final class ReservedFieldTheme {
  const ReservedFieldTheme({required this.merge});

  final int merge;
}

/// Everything else is in order, so the missing `with` clause is what stops
/// this one.
@ShouldThrow(
  '`MissingMixinTheme` does not apply the generated mixin '
  r'`_$MissingMixinTheme`, which holds the generated methods.',
  todo:
      r'Add `with _$MissingMixinTheme` to the declaration of '
      '`MissingMixinTheme`.',
)
@themeGen
final class MissingMixinTheme {
  const MissingMixinTheme({required this.color});

  final Color color;
}
