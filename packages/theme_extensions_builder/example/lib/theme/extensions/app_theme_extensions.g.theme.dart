// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_theme_extensions.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppThemeExtensionMixin on ThemeExtension<AppThemeExtension> {
  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primaryColor,
    LayoutMode? layoutMode,
    EdgeInsets? insets,
    Duration? animation,
    double? radius,
    MySubTextTheme? subTextTheme,
    EdgeInsetsGeometry? padding,
  }) {
    final object = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: primaryColor ?? object.primaryColor,
      layoutMode: layoutMode ?? object.layoutMode,
      insets: insets ?? object.insets,
      animation: animation ?? object.animation,
      radius: radius ?? object.radius,
      subTextTheme: subTextTheme ?? object.subTextTheme,
      padding: padding ?? object.padding,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;
    if (otherValue is! AppThemeExtension) {
      return this;
    }

    final value = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: Color.lerp(value.primaryColor, otherValue.primaryColor, t)!,
      layoutMode: t < 0.5 ? value.layoutMode : otherValue.layoutMode,
      insets: EdgeInsets.lerp(value.insets, otherValue.insets, t)!,
      animation: lerpDuration$(value.animation, otherValue.animation, t),
      radius: lerpDouble$(value.radius, otherValue.radius, t)!,
      subTextTheme:
          (value.subTextTheme.lerp(otherValue.subTextTheme, t)
              as MySubTextTheme),
      padding: EdgeInsetsGeometry.lerp(value.padding, otherValue.padding, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! AppThemeExtension) {
      return false;
    }

    final value = (this as AppThemeExtension);

    return other.primaryColor == value.primaryColor &&
        other.layoutMode == value.layoutMode &&
        other.insets == value.insets &&
        other.animation == value.animation &&
        other.radius == value.radius &&
        other.subTextTheme == value.subTextTheme &&
        other.padding == value.padding;
  }

  @override
  int get hashCode {
    final value = (this as AppThemeExtension);

    return Object.hash(
      runtimeType,
      value.primaryColor,
      value.layoutMode,
      value.insets,
      value.animation,
      value.radius,
      value.subTextTheme,
      value.padding,
    );
  }
}

extension AppThemeExtensionBuildContext on BuildContext {
  AppThemeExtension get baseAppTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}

mixin _$AppColorsMixin on ThemeExtension<AppColors> {
  @override
  ThemeExtension<AppColors> copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
    Color? color4,
    Color? color5,
    Color? color6,
    Color? color7,
    Color? color8,
    Color? color9,
    Color? color10,
    Color? color11,
    Color? color12,
    Color? color13,
    Color? color14,
    Color? color15,
    Color? color16,
    Color? color17,
    Color? color18,
    Color? color19,
    Color? color20,
  }) {
    final object = (this as AppColors);

    return AppColors(
      color1: color1 ?? object.color1,
      color2: color2 ?? object.color2,
      color3: color3 ?? object.color3,
      color4: color4 ?? object.color4,
      color5: color5 ?? object.color5,
      color6: color6 ?? object.color6,
      color7: color7 ?? object.color7,
      color8: color8 ?? object.color8,
      color9: color9 ?? object.color9,
      color10: color10 ?? object.color10,
      color11: color11 ?? object.color11,
      color12: color12 ?? object.color12,
      color13: color13 ?? object.color13,
      color14: color14 ?? object.color14,
      color15: color15 ?? object.color15,
      color16: color16 ?? object.color16,
      color17: color17 ?? object.color17,
      color18: color18 ?? object.color18,
      color19: color19 ?? object.color19,
      color20: color20 ?? object.color20,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    final otherValue = other;
    if (otherValue is! AppColors) {
      return this;
    }

    final value = (this as AppColors);

    return AppColors(
      color1: Color.lerp(value.color1, otherValue.color1, t)!,
      color2: Color.lerp(value.color2, otherValue.color2, t)!,
      color3: Color.lerp(value.color3, otherValue.color3, t)!,
      color4: Color.lerp(value.color4, otherValue.color4, t)!,
      color5: Color.lerp(value.color5, otherValue.color5, t)!,
      color6: Color.lerp(value.color6, otherValue.color6, t)!,
      color7: Color.lerp(value.color7, otherValue.color7, t)!,
      color8: Color.lerp(value.color8, otherValue.color8, t)!,
      color9: Color.lerp(value.color9, otherValue.color9, t)!,
      color10: Color.lerp(value.color10, otherValue.color10, t)!,
      color11: Color.lerp(value.color11, otherValue.color11, t)!,
      color12: Color.lerp(value.color12, otherValue.color12, t)!,
      color13: Color.lerp(value.color13, otherValue.color13, t)!,
      color14: Color.lerp(value.color14, otherValue.color14, t)!,
      color15: Color.lerp(value.color15, otherValue.color15, t)!,
      color16: Color.lerp(value.color16, otherValue.color16, t)!,
      color17: Color.lerp(value.color17, otherValue.color17, t)!,
      color18: Color.lerp(value.color18, otherValue.color18, t)!,
      color19: Color.lerp(value.color19, otherValue.color19, t)!,
      color20: Color.lerp(value.color20, otherValue.color20, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! AppColors) {
      return false;
    }

    final value = (this as AppColors);

    return other.color1 == value.color1 &&
        other.color2 == value.color2 &&
        other.color3 == value.color3 &&
        other.color4 == value.color4 &&
        other.color5 == value.color5 &&
        other.color6 == value.color6 &&
        other.color7 == value.color7 &&
        other.color8 == value.color8 &&
        other.color9 == value.color9 &&
        other.color10 == value.color10 &&
        other.color11 == value.color11 &&
        other.color12 == value.color12 &&
        other.color13 == value.color13 &&
        other.color14 == value.color14 &&
        other.color15 == value.color15 &&
        other.color16 == value.color16 &&
        other.color17 == value.color17 &&
        other.color18 == value.color18 &&
        other.color19 == value.color19 &&
        other.color20 == value.color20;
  }

  @override
  int get hashCode {
    final value = (this as AppColors);

    return Object.hashAll([
      runtimeType,
      value.color1,
      value.color2,
      value.color3,
      value.color4,
      value.color5,
      value.color6,
      value.color7,
      value.color8,
      value.color9,
      value.color10,
      value.color11,
      value.color12,
      value.color13,
      value.color14,
      value.color15,
      value.color16,
      value.color17,
      value.color18,
      value.color19,
      value.color20,
    ]);
  }
}

extension AppColorsBuildContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

mixin _$CardThemeExtensionMixin on ThemeExtension<CardThemeExtension> {
  @override
  ThemeExtension<CardThemeExtension> copyWith({
    Color? primaryColor,
    LayoutMode? layoutMode,
    EdgeInsets? insets,
  }) {
    final object = (this as CardThemeExtension);

    return CardThemeExtension(
      primaryColor: primaryColor ?? object.primaryColor,
      layoutMode: layoutMode ?? object.layoutMode,
      insets: insets ?? object.insets,
    );
  }

  @override
  ThemeExtension<CardThemeExtension> lerp(
    ThemeExtension<CardThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;
    if (otherValue is! CardThemeExtension) {
      return this;
    }

    final value = (this as CardThemeExtension);

    return CardThemeExtension(
      primaryColor: Color.lerp(value.primaryColor, otherValue.primaryColor, t)!,
      layoutMode: t < 0.5 ? value.layoutMode : otherValue.layoutMode,
      insets: EdgeInsets.lerp(value.insets, otherValue.insets, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! CardThemeExtension) {
      return false;
    }

    final value = (this as CardThemeExtension);

    return other.primaryColor == value.primaryColor &&
        other.layoutMode == value.layoutMode &&
        other.insets == value.insets;
  }

  @override
  int get hashCode {
    final value = (this as CardThemeExtension);

    return Object.hash(
      runtimeType,
      value.primaryColor,
      value.layoutMode,
      value.insets,
    );
  }
}

extension CardThemeExtensionBuildContext on BuildContext {
  CardThemeExtension get cardTheme =>
      Theme.of(this).extension<CardThemeExtension>()!;
}
