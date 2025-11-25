import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'empty_theme.g.theme.dart';

// ignore: avoid_classes_with_only_static_members
@themeGen
final class EmptyTheme with _$EmptyTheme {
  const EmptyTheme();

  static EmptyTheme? lerp(
    EmptyTheme? a,
    EmptyTheme? b,
    double t,
  ) => _$EmptyTheme.lerp(a, b, t);
}
