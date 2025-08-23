import 'field_symbol.dart';

/// A class that contains the configuration for the `ThemeMixinTemplate` class
class ThemeMixinConfig {
  const ThemeMixinConfig({
    required this.fields,
    required this.className,
  });

  final Map<String, FieldSymbol> fields;
  final String className;
}
