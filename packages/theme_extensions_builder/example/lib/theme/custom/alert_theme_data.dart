import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'alert_theme_data.g.theme.dart';

@ThemeGen()
class AlertThemeData with _$AlertThemeData {
  const AlertThemeData({
    this.canMerge = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.iconPadding,
    this.titleTextStyle,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.border = const Border(),
    this.borderSide = const BorderSide(),
    this.curve,
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
  final BorderSide borderSide;
  final Curve? curve;
  final Border border;
  final Duration? animationDuration;

  static AlertThemeData lerp(AlertThemeData? a, AlertThemeData? b, double t) =>
      _$AlertThemeData.lerp(a, b, t);
}

@ThemeGen()
class BaseTheme with _$BaseTheme {
  const BaseTheme({
    this.backgroundColor,
  });

  final Color? backgroundColor;

  static BaseTheme lerp(BaseTheme? a, BaseTheme? b, double t) =>
      _$BaseTheme.lerp(a, b, t);
}
