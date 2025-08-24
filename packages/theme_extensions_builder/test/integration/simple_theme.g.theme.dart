// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'simple_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$ThemeExtensionMixin on ThemeExtension<SimpleThemeExtension> {
  @override
  ThemeExtension<SimpleThemeExtension> copyWith({
    Color? color,
    double? radius,
  }) {
    final object = (this as SimpleThemeExtension);

    return SimpleThemeExtension(
      color: color ?? object.color,
      radius: radius ?? object.radius,
    );
  }

  @override
  ThemeExtension<SimpleThemeExtension> lerp(
    ThemeExtension<SimpleThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;
    if (otherValue is! SimpleThemeExtension) {
      return this;
    }

    final value = (this as SimpleThemeExtension);

    return SimpleThemeExtension(
      color: Color.lerp(value.color, otherValue.color, t)!,
      radius: otherValue.radius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    final value = (this as SimpleThemeExtension);
    return other.runtimeType == runtimeType &&
        other is SimpleThemeExtension &&
        identical(value.color, other.color) &&
        identical(value.radius, other.radius);
  }

  @override
  int get hashCode {
    final value = (this as SimpleThemeExtension);

    return Object.hash(runtimeType, value.color, value.radius);
  }
}

extension SimpleThemeExtensionBuildContext on BuildContext {
  SimpleThemeExtension get bgTheme =>
      Theme.of(this).extension<SimpleThemeExtension>()!;
}
