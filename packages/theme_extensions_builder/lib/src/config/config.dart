/// @docImport '../generator/theme_extensions/generator.dart';
/// @docImport '../generator/theme_gen/generator.dart';

library;

import '../common/symbols/field_info.dart';

/// Base configuration class for theme code generators.
///
/// This sealed class provides common configuration properties used by both
/// [ThemeGenConfig] and [ThemeExtensionsConfig].
sealed class BaseConfig {
  const BaseConfig({
    required this.fields,
    required this.className,
    required this.constructor,
    required this.constConstructor,
  });

  /// The fields to be included in the generated theme extension.
  final List<FieldInfo> fields;

  /// The fields that are supported for generation (non-static fields).
  Iterable<FieldInfo> get filteredFields =>
      fields.where((field) => !field.isStatic);

  /// The name of the class to be generated.
  final String className;

  /// The name of the constructor to be used. If `null`, the default
  /// constructor will be used.
  final String? constructor;

  /// Whether to generate a const constructor.
  final bool constConstructor;
}

/// Configuration for the [ThemeGenGenerator].
///
/// This config is used when generating mixins for classes annotated with
/// [@ThemeGen]. It includes fields for generating `copyWith`, `merge`,
/// `lerp`, equality operators, and `hashCode` methods.
class ThemeGenConfig extends BaseConfig {
  const ThemeGenConfig({
    required super.fields,
    required super.className,
    required super.constructor,
    required super.constConstructor,
  });
}

/// Configuration for the [ThemeExtensionsGenerator].
///
/// This config is used when generating code for classes annotated with
/// `@ThemeExtensions` that extend Flutter's `ThemeExtension`. It includes
/// additional options for generating BuildContext extensions.
class ThemeExtensionsConfig extends BaseConfig {
  const ThemeExtensionsConfig({
    required super.fields,
    required super.className,
    required super.constructor,
    required this.buildContextExtension,
    required this.contextAccessorName,
    required this.themeExtensionMixinName,
    required super.constConstructor,
  });

  /// The name of the context getter to be generated.
  ///
  /// If `null`, defaults to the [className]. Used in the generated
  /// BuildContext extension for accessing the theme.
  final String? contextAccessorName;

  /// Whether to generate a BuildContext extension.
  ///
  /// When `true`, generates an extension on BuildContext that provides
  /// convenient access to the theme extension.
  final bool buildContextExtension;

  /// The name of the generated mixin.
  ///
  /// Typically follows the pattern `_$ClassName` and is applied to the
  /// theme extension class.
  final String themeExtensionMixinName;
}
