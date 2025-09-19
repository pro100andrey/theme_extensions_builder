import '../../common/symbols.dart';

// Configuration for the theme extensions generator.
class ThemeGenConfig {
  const ThemeGenConfig({
    required this.fields,
    required this.className,
  });

  /// The fields to be included in the generated theme extension.
  final Map<String, FieldSymbol> fields;

  /// The name of the class to be generated.
  final String className;
}
