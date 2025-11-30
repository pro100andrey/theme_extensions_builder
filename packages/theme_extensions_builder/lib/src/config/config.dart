import '../common/symbols/symbols.dart';

sealed class BaseConfig {
  const BaseConfig({
    required this.fields,
    required this.className,
    required this.constructor,
    required this.constConstructor,
  });

  /// The fields to be included in the generated theme extension.
  final List<FieldSymbol> fields;

  /// The fields that are supported for generation (non-static fields).
  Iterable<FieldSymbol> get filteredFields =>
      fields.where((field) => !field.isStatic);

  /// The name of the class to be generated.
  final String className;

  /// The name of the constructor to be used. If `null`, the default
  /// constructor will be used.
  final String? constructor;

  /// Whether to generate a const constructor.
  final bool constConstructor;
}

// Configuration for the theme extensions generator.
class ThemeGenConfig extends BaseConfig {
  const ThemeGenConfig({
    required super.fields,
    required super.className,
    required super.constructor,
    required super.constConstructor,
  });
}

// Configuration for the theme extensions generator.
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

  /// The name of the context getter to be generated. By default, it will be
  /// the same as [className].
  final String? contextAccessorName;

  /// Whether to generate the BuildContext extension.
  final bool buildContextExtension;

  final String themeExtensionMixinName;
}
