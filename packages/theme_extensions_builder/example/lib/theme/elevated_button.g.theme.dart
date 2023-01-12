// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'elevated_button.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$ThemeExtensionMixin on ThemeExtension<ElevatedButtonThemeExtension> {
  @override
  ThemeExtension<ElevatedButtonThemeExtension> copyWith({
    BorderRadius? borderRadius,
    MaterialStateProperty<Color>? test,
    double? radius,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final object = this as ElevatedButtonThemeExtension;

    return ElevatedButtonThemeExtension(
      borderRadius: borderRadius ?? object.borderRadius,
      test: test ?? object.test,
      radius: radius ?? object.radius,
      backgroundColor: backgroundColor ?? object.backgroundColor,
      foregroundColor: foregroundColor ?? object.foregroundColor,
    );
  }

  @override
  ThemeExtension<ElevatedButtonThemeExtension> lerp(
    ThemeExtension<ElevatedButtonThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;

    if (otherValue is! ElevatedButtonThemeExtension) {
      return this;
    }

    final value = this as ElevatedButtonThemeExtension;

    return ElevatedButtonThemeExtension(
      borderRadius: BorderRadius.lerp(
        value.borderRadius,
        otherValue.borderRadius,
        t,
      ),
      test: otherValue.test,
      radius: otherValue.radius,
      backgroundColor: Color.lerp(
        value.backgroundColor,
        otherValue.backgroundColor,
        t,
      )!,
      foregroundColor: Color.lerp(
        value.foregroundColor,
        otherValue.foregroundColor,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    final value = this as ElevatedButtonThemeExtension;

    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ElevatedButtonThemeExtension &&
            identical(value.borderRadius, other.borderRadius) &&
            identical(value.test, other.test) &&
            identical(value.radius, other.radius) &&
            identical(value.backgroundColor, other.backgroundColor) &&
            identical(value.foregroundColor, other.foregroundColor));
  }

  @override
  int get hashCode {
    final value = this as ElevatedButtonThemeExtension;

    return Object.hash(
      runtimeType,
      value.borderRadius,
      value.test,
      value.radius,
      value.backgroundColor,
      value.foregroundColor,
    );
  }
}

extension ElevatedButtonThemeExtensionBuildContext on BuildContext {
  ElevatedButtonThemeExtension get elevatedButtonTheme =>
      Theme.of(this).extension<ElevatedButtonThemeExtension>()!;
}
