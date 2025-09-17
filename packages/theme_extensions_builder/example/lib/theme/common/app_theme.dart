import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

enum LayoutMode { compact, expanded }

@ThemeExtensions(contextAccessorName: 'baseAppTheme')
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
class AppColors extends ThemeExtension<AppColors> with _$AppColorsMixin {
  const AppColors({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.color5,
    required this.color6,
    required this.color7,
    required this.color8,
    required this.color9,
    required this.color10,
    required this.color11,
    required this.color12,
    required this.color13,
    required this.color14,
    required this.color15,
    required this.color16,
    required this.color17,
    required this.color18,
    required this.color19,
    required this.color20,
  });

  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
  final Color color5;
  final Color color6;
  final Color color7;
  final Color color8;
  final Color color9;
  final Color color10;
  final Color color11;
  final Color color12;
  final Color color13;
  final Color color14;
  final Color color15;
  final Color color16;
  final Color color17;
  final Color color18;
  final Color color19;
  final Color color20;
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
