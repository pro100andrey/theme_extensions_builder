import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'card_theme.g.theme.dart';

@themeExtensions
class CardThemeExtension extends ThemeExtension<CardThemeExtension>
    with _$CardThemeExtension {
  const CardThemeExtension({
    required this.borderRadius,
    required this.backgroundColor,
    required this.boxShadow,
    this.titleTextStyle = const .new(fontSize: 18, fontWeight: .bold),
    this.subtitleTextStyle = const .new(fontSize: 14),
    this.border = const .new(),
    this.padding = const .all(16),
  });

  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final Border border;
  final EdgeInsetsGeometry padding;
}

@themeExtensions
class BaseTheme extends ThemeExtension<BaseTheme> with _$BaseTheme {
  const BaseTheme({
    required this.cardTheme,
    required this.cardTheme1,
    required this.value,
    required this.value1,
    required this.duration,
    required this.duration1,
  });

  final CardThemeExtension cardTheme;
  final CardThemeExtension? cardTheme1;
  final double? value;
  final double value1;
  final Duration duration;
  final Duration? duration1;
}

@ThemeGen()
class SimpleThemeGen with _$SimpleThemeGen {
  const SimpleThemeGen({
    required this.size,
    required this.baseTheme,
    this.name,
    this.theme,
    this.baseThemeOptional,
    this.decoration,
  });

  final double size;
  final String? name;
  final SimpleThemeGen? theme;
  final BaseTheme baseTheme;
  final BaseTheme? baseThemeOptional;
  final BoxDecoration? decoration;

  static SimpleThemeGen? lerp(
    SimpleThemeGen? a,
    SimpleThemeGen? b,
    double t,
  ) => _$SimpleThemeGen.lerp(a, b, t);
}
