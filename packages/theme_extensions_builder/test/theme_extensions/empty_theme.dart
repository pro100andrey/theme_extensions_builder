import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'empty_theme.g.theme.dart';

@themeGen
final class EmptyTheme with _$EmptyTheme {
  const EmptyTheme();

  @override
  bool get canMerge => true;

  static EmptyTheme? lerp(EmptyTheme? a, EmptyTheme? b, double t) =>
      _$EmptyTheme.lerp(a, b, t);
}

@themeGen
final class EmptyThemeWithoutConstConstructor
    with _$EmptyThemeWithoutConstConstructor {
  EmptyThemeWithoutConstConstructor();

  @override
  bool get canMerge => true;

  static EmptyThemeWithoutConstConstructor? lerp(
    EmptyThemeWithoutConstConstructor? a,
    EmptyThemeWithoutConstConstructor? b,
    double t,
  ) => _$EmptyThemeWithoutConstConstructor.lerp(a, b, t);
}
