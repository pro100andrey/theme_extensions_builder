// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'background.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$ThemeExtensionMixin on ThemeExtension<BackgroundThemeExtension> {
  @override
  ThemeExtension<BackgroundThemeExtension> copyWith({
    Color? color,
    double? radius,
    MySubTextTheme? subTextTheme,
  }) {
    final object = (this as BackgroundThemeExtension);

    return BackgroundThemeExtension(
      color: color ?? object.color,
      radius: radius ?? object.radius,
      subTextTheme: subTextTheme ?? object.subTextTheme,
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

    final value = (this as BackgroundThemeExtension);

    return BackgroundThemeExtension(
      color: Color.lerp(value.color, otherValue.color, t)!,
      radius: otherValue.radius,
      subTextTheme: otherValue.subTextTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    final value = (this as BackgroundThemeExtension);
    return other.runtimeType == runtimeType &&
        other is BackgroundThemeExtension &&
        identical(value.color, other.color) &&
        identical(value.radius, other.radius) &&
        identical(value.subTextTheme, other.subTextTheme);
  }

  @override
  int get hashCode {
    final value = (this as BackgroundThemeExtension);

    return Object.hash(
      runtimeType,
      value.color,
      value.radius,
      value.subTextTheme,
    );
  }
}

extension BackgroundThemeExtensionBuildContext on BuildContext {
  BackgroundThemeExtension get backgroundTheme =>
      Theme.of(this).extension<BackgroundThemeExtension>()!;
}
