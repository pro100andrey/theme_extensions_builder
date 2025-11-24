import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'card_theme.g.theme.dart';

@themeExtensions
class CardThemeExtension extends ThemeExtension<CardThemeExtension>
    with _$CardThemeExtension {
   CardThemeExtension({
    required this.borderRadius,
    required this.backgroundColor,
    required this.boxShadow,
    this.titleTextStyle = const .new(fontSize: 18, fontWeight: .bold),
    this.subtitleTextStyle = const .new(fontSize: 14),
    this.border = const .new(),
    this.padding = const .all(16),
    this.elevation,
    this.e = 1.0,
  });

  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final Border border;
  final EdgeInsetsGeometry padding;
  final double? elevation;
  double e;
}
