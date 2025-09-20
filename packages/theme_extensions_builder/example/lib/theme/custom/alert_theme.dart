import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'alert_theme.g.theme.dart';

@ThemeGen()
class AlertTheme with _$AlertTheme {
  const AlertTheme({
    this.canMerge = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.iconPadding,
    this.titleTextStyle,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.baseTheme,
    this.borderRadius,
    this.animationDuration,
  });

  @override
  final bool canMerge;
  final Duration transitionDuration;
  final EdgeInsetsGeometry? iconPadding;
  final TextStyle? titleTextStyle;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final BaseTheme? baseTheme;
  final double? borderRadius;
  final Duration? animationDuration;

  static AlertTheme? lerp(AlertTheme a, AlertTheme b, double t) =>
      _$AlertTheme.lerp(a, b, t);
}

@ThemeGen()
class BaseTheme with _$BaseTheme {
  const BaseTheme({
    this.backgroundColor,
  });

  final Color? backgroundColor;

  static BaseTheme? lerp(BaseTheme? a, BaseTheme? b, double t) =>
      _$BaseTheme.lerp(a, b, t);
}
