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
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final object = this as ElevatedButtonThemeExtension;

    return ElevatedButtonThemeExtension(
      borderRadius: borderRadius ?? object.borderRadius,
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
            identical(value.backgroundColor, other.backgroundColor) &&
            identical(value.foregroundColor, other.foregroundColor));
  }

  @override
  int get hashCode {
    final value = this as ElevatedButtonThemeExtension;

    return Object.hash(
      runtimeType,
      value.borderRadius,
      value.backgroundColor,
      value.foregroundColor,
    );
  }
}

extension ElevatedButtonThemeExtensionBuildContext on BuildContext {
  ElevatedButtonThemeExtension get elevatedButtonTheme =>
      Theme.of(this).extension<ElevatedButtonThemeExtension>()!;
}
