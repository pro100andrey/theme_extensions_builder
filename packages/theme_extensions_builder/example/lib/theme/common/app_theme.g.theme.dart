// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppThemeExtensionMixin on ThemeExtension<AppThemeExtension> {
  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primaryColor,
    LayoutMode? layoutMode,
    EdgeInsets? insets,
    MySubTextTheme? subTextTheme,
  }) {
    final object = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: primaryColor ?? object.primaryColor,
      layoutMode: layoutMode ?? object.layoutMode,
      insets: insets ?? object.insets,
      subTextTheme: subTextTheme ?? object.subTextTheme,
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
      subTextTheme:
          (value.subTextTheme.lerp(otherValue.subTextTheme, t)
              as MySubTextTheme),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    final value = (this as AppThemeExtension);
    return other.runtimeType == runtimeType &&
        other is AppThemeExtension &&
        identical(value.primaryColor, other.primaryColor) &&
        identical(value.layoutMode, other.layoutMode) &&
        identical(value.insets, other.insets) &&
        identical(value.subTextTheme, other.subTextTheme);
  }

  @override
  int get hashCode {
    final value = (this as AppThemeExtension);

    return Object.hash(
      runtimeType,
      value.primaryColor,
      value.layoutMode,
      value.insets,
      value.subTextTheme,
    );
  }
}

extension AppThemeExtensionBuildContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
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

    final value = (this as CardThemeExtension);
    return other.runtimeType == runtimeType &&
        other is CardThemeExtension &&
        identical(value.primaryColor, other.primaryColor) &&
        identical(value.layoutMode, other.layoutMode) &&
        identical(value.insets, other.insets);
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
