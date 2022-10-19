import 'field.dart';

class ThemeMixinConfig {
  const ThemeMixinConfig({
    required this.fields,
    required this.className,
  });

  final Map<String, Field> fields;
  final String className;
}
