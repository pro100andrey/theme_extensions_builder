// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'background_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$ThemeExtensionMixin on ThemeExtension<BackgroundThemeExtension> {
  @override
  ThemeExtension<BackgroundThemeExtension> copyWith({
    Color? color,
    double? radius,
  }) {
    final object = this as BackgroundThemeExtension;

    return BackgroundThemeExtension(
      color: color ?? object.color,
      radius: radius ?? object.radius,
    );
  }

  @override
  ThemeExtension<BackgroundThemeExtension> lerp(
    ThemeExtension<BackgroundThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;

    if (otherValue is! BackgroundThemeExtension) {
      return this;
    }

    final value = this as BackgroundThemeExtension;

    return BackgroundThemeExtension(
      color: Color.lerp(
        value.color,
        otherValue.color,
        t,
      )!,
      radius: otherValue.radius,
    );
  }

  @override
  bool operator ==(Object other) {
    final value = this as BackgroundThemeExtension;

    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BackgroundThemeExtension &&
            identical(value.color, other.color) &&
            identical(value.radius, other.radius));
  }

  @override
  int get hashCode {
    final value = this as BackgroundThemeExtension;

    return Object.hash(
      runtimeType,
      value.color,
      value.radius,
    );
  }
}

extension BackgroundThemeExtensionBuildContext on BuildContext {
  BackgroundThemeExtension get backgroundTheme =>
      Theme.of(this).extension<BackgroundThemeExtension>()!;
}
