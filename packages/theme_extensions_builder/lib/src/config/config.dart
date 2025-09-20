import '../common/symbols.dart';

sealed class BaseConfig {
  const BaseConfig({
    required this.fields,
    required this.className,
  });

  /// The fields to be included in the generated theme extension.
  final Map<String, FieldSymbol> fields;

  /// The name of the class to be generated.
  final String className;
}

// Configuration for the theme extensions generator.
class ThemeGenConfig extends BaseConfig {
  const ThemeGenConfig({
    required super.fields,
    required super.className,
  });
}

// Configuration for the theme extensions generator.
class ThemeExtensionsConfig extends BaseConfig {
  const ThemeExtensionsConfig({
    required super.fields,
    required super.className,
    required this.buildContextExtension,
    required this.contextAccessorName,
    required this.isDeprecatedMixin,
  });

  /// The name of the context getter to be generated. By default, it will be
  /// the same as [className].
  final String? contextAccessorName;

  /// Whether to generate the BuildContext extension.
  final bool buildContextExtension;

  /// If false, whether to generate a mixin with the same name as the class plus
  /// the suffix `Mixin`. Otherwise, the mixin will generated with a
  ///  `_$ThemeExtensionMixin` name.
  final bool isDeprecatedMixin;
}
