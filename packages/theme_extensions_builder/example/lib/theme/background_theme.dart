import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'background_theme.g.dart';

@ThemeExtensions()
class BackgroundThemeExtension extends ThemeExtension<BackgroundThemeExtension>
    with _$ThemeExtensionMixin {
  const BackgroundThemeExtension({
    this.color = Colors.grey,
  });

  final Color color;
}
