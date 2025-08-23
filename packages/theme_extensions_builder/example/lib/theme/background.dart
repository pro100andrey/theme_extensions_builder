import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'background.g.theme.dart';

@ThemeExtensions(contextAccessorName: 'bgTheme')
class BackgroundThemeExtension extends ThemeExtension<BackgroundThemeExtension>
    with _$ThemeExtensionMixin {
  const BackgroundThemeExtension({
    required this.color,
    required this.radius,
    required this.subTextTheme,
  });

  final Color color;
  final double radius;
  final MySubTextTheme subTextTheme;
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
    ThemeExtension<MySubTextTheme> other,
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
