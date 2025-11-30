import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'empty_theme.g.theme.dart';

@themeGen
final class EmptyThemeWithConstConstructor
    with _$EmptyThemeWithConstConstructor {
  const EmptyThemeWithConstConstructor();

  @override
  bool get canMerge => true;

  static EmptyThemeWithConstConstructor? lerp(
    EmptyThemeWithConstConstructor? a,
    EmptyThemeWithConstConstructor? b,
    double t,
  ) => _$EmptyThemeWithConstConstructor.lerp(a, b, t);
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
