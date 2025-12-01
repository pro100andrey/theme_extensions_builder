import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'spacing_theme.g.theme.dart';

@themeExtensions
class SpacingThemeExtension extends ThemeExtension<SpacingThemeExtension>
    with _$SpacingThemeExtension {
  const SpacingThemeExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.pageHorizontal,
    required this.pageVertical,
    required this.sectionSpacing,
    required this.cardSpacing,
  });

  /// Extra small spacing (4.0)
  final double xs;

  /// Small spacing (8.0)
  final double sm;

  /// Medium spacing (16.0)
  final double md;

  /// Large spacing (24.0)
  final double lg;

  /// Extra large spacing (32.0)
  final double xl;

  /// Extra extra large spacing (48.0)
  final double xxl;

  /// Horizontal page padding
  final double pageHorizontal;

  /// Vertical page padding
  final double pageVertical;

  /// Section spacing
  final double sectionSpacing;

  /// Card spacing
  final double cardSpacing;
}
