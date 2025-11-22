// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'card_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$CardThemeExtensionMixin on ThemeExtension<CardThemeExtension> {
  @override
  ThemeExtension<CardThemeExtension> copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Border? border,
    EdgeInsetsGeometry? padding,
  }) {
    final object = (this as CardThemeExtension);

    return CardThemeExtension(
      borderRadius: borderRadius ?? object.borderRadius,
      backgroundColor: backgroundColor ?? object.backgroundColor,
      boxShadow: boxShadow ?? object.boxShadow,
      titleTextStyle: titleTextStyle ?? object.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? object.subtitleTextStyle,
      border: border ?? object.border,
      padding: padding ?? object.padding,
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
      borderRadius: t < 0.5 ? value.borderRadius : otherValue.borderRadius,
      backgroundColor: t < 0.5
          ? value.backgroundColor
          : otherValue.backgroundColor,
      boxShadow: t < 0.5 ? value.boxShadow : otherValue.boxShadow,
      titleTextStyle: t < 0.5
          ? value.titleTextStyle
          : otherValue.titleTextStyle,
      subtitleTextStyle: t < 0.5
          ? value.subtitleTextStyle
          : otherValue.subtitleTextStyle,
      border: t < 0.5 ? value.border : otherValue.border,
      padding: t < 0.5 ? value.padding : otherValue.padding,
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

    return other.borderRadius == value.borderRadius &&
        other.backgroundColor == value.backgroundColor &&
        other.boxShadow == value.boxShadow &&
        other.titleTextStyle == value.titleTextStyle &&
        other.subtitleTextStyle == value.subtitleTextStyle &&
        other.border == value.border &&
        other.padding == value.padding;
  }

  @override
  int get hashCode {
    final value = (this as CardThemeExtension);

    return Object.hash(
      runtimeType,
      value.borderRadius,
      value.backgroundColor,
      value.boxShadow,
      value.titleTextStyle,
      value.subtitleTextStyle,
      value.border,
      value.padding,
    );
  }
}

extension CardThemeExtensionBuildContext on BuildContext {
  CardThemeExtension get cardTheme =>
      Theme.of(this).extension<CardThemeExtension>()!;
}
