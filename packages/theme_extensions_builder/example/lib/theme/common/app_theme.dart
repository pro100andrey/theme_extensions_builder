import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

enum LayoutMode { compact, expanded }

@ThemeExtensions(contextAccessorName: 'baseTheme')
class AppThemeExtension extends ThemeExtension<AppThemeExtension>
    with _$AppThemeExtensionMixin {
  const AppThemeExtension({
    required this.primaryColor,
    required this.layoutMode,
    required this.insets,
    required this.radius,
    required this.subTextTheme,
  });

  final Color primaryColor;
  final LayoutMode layoutMode;
  final EdgeInsets insets;
  final double radius;
  final MySubTextTheme subTextTheme;
}

@ThemeExtensions()
class CardThemeExtension extends ThemeExtension<CardThemeExtension>
    with _$CardThemeExtensionMixin {
  const CardThemeExtension({
    required this.primaryColor,
    required this.layoutMode,
    required this.insets,
  });

  final Color primaryColor;
  final LayoutMode layoutMode;
  final EdgeInsets insets;
}

class MySubTextTheme extends ThemeExtension<MySubTextTheme> {
  const MySubTextTheme({required this.color, required this.fontSize});

  final Color color;
  final double fontSize;

  @override
  ThemeExtension<MySubTextTheme> copyWith({Color? color, double? fontSize}) =>
      MySubTextTheme(
        color: color ?? this.color,
        fontSize: fontSize ?? this.fontSize,
      );

  @override
  ThemeExtension<MySubTextTheme> lerp(
    ThemeExtension<MySubTextTheme>? other,
    double t,
  ) {
    final otherValue = other;

    if (otherValue is! MySubTextTheme) {
      return this;
    }

    final value = this;

    return MySubTextTheme(
      color: Color.lerp(value.color, otherValue.color, t)!,
      fontSize: otherValue.fontSize,
    );
  }

  @override
  bool operator ==(Object other) {
    final value = this;

    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MySubTextTheme &&
            identical(value.color, other.color) &&
            identical(value.fontSize, other.fontSize));
  }

  @override
  int get hashCode {
    final value = this;

    return Object.hash(runtimeType, value.color, value.fontSize);
  }
}
