import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'simple_theme.g.theme.dart';

@ThemeExtensions(contextAccessorName: 'bgTheme')
class SimpleThemeExtension extends ThemeExtension<SimpleThemeExtension>
    with _$ThemeExtensionMixin {
  const SimpleThemeExtension({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;
}
