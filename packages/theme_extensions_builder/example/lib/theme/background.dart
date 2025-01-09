import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'background.g.theme.dart';

@ThemeExtensions()
class BackgroundThemeExtension extends ThemeExtension<BackgroundThemeExtension>
    with _$ThemeExtensionMixin {

  const BackgroundThemeExtension({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;
}
