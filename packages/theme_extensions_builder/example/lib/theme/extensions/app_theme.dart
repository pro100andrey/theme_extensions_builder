import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

enum LayoutMode { compact, expanded }

@themeExtensions
class AppThemeExtension extends ThemeExtension<AppThemeExtension>
    with _$AppThemeExtension {
  const AppThemeExtension({
    required this.primaryColor,
    required this.backgroundColor,
    required this.layoutMode,
  });

  final Color primaryColor;
  final Color backgroundColor;
  final LayoutMode layoutMode;
}