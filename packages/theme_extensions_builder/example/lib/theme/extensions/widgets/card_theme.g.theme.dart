// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'card_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$CardThemeExtension on ThemeExtension<CardThemeExtension> {
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
    final _this = (this as CardThemeExtension);

    return CardThemeExtension(
      borderRadius: borderRadius ?? _this.borderRadius,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      boxShadow: boxShadow ?? _this.boxShadow,
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _this.subtitleTextStyle,
      border: border ?? _this.border,
      padding: padding ?? _this.padding,
    );
  }

  @override
  ThemeExtension<CardThemeExtension> lerp(
    ThemeExtension<CardThemeExtension>? other,
    double t,
  ) {
    if (other is! CardThemeExtension) {
      return this;
    }

    final _this = (this as CardThemeExtension);

    return CardThemeExtension(
      borderRadius: BorderRadius.lerp(
        _this.borderRadius,
        other.borderRadius,
        t,
      )!,
      backgroundColor: Color.lerp(
        _this.backgroundColor,
        other.backgroundColor,
        t,
      )!,
      boxShadow: t < 0.5 ? _this.boxShadow : other.boxShadow,
      titleTextStyle: TextStyle.lerp(
        _this.titleTextStyle,
        other.titleTextStyle,
        t,
      )!,
      subtitleTextStyle: TextStyle.lerp(
        _this.subtitleTextStyle,
        other.subtitleTextStyle,
        t,
      )!,
      border: Border.lerp(_this.border, other.border, t)!,
      padding: EdgeInsetsGeometry.lerp(_this.padding, other.padding, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as CardThemeExtension);
    final _other = (other as CardThemeExtension);

    return _other.borderRadius == _this.borderRadius &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.boxShadow == _this.boxShadow &&
        _other.titleTextStyle == _this.titleTextStyle &&
        _other.subtitleTextStyle == _this.subtitleTextStyle &&
        _other.border == _this.border &&
        _other.padding == _this.padding;
  }

  @override
  int get hashCode {
    final _this = (this as CardThemeExtension);

    return Object.hash(
      runtimeType,
      _this.borderRadius,
      _this.backgroundColor,
      _this.boxShadow,
      _this.titleTextStyle,
      _this.subtitleTextStyle,
      _this.border,
      _this.padding,
    );
  }
}

extension CardThemeExtensionBuildContext on BuildContext {
  CardThemeExtension get cardTheme =>
      Theme.of(this).extension<CardThemeExtension>()!;
}
