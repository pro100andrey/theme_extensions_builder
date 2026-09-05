// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'input_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$InputThemeExtension on ThemeExtension<InputThemeExtension> {
  @override
  ThemeExtension<InputThemeExtension> copyWith({
    WidgetStateProperty<Color?>? borderColor,
    WidgetStateProperty<Color?>? fillColor,
    WidgetStateProperty<Color?>? labelColor,
    BorderRadius? borderRadius,
    double? borderWidth,
    double? focusedBorderWidth,
    EdgeInsets? contentPadding,
    TextStyle? labelStyle,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
    Duration? focusDuration,
    Color? hintColor,
  }) {
    final _this = (this as InputThemeExtension);

    return InputThemeExtension(
      borderColor: borderColor ?? _this.borderColor,
      fillColor: fillColor ?? _this.fillColor,
      labelColor: labelColor ?? _this.labelColor,
      borderRadius: borderRadius ?? _this.borderRadius,
      borderWidth: borderWidth ?? _this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? _this.focusedBorderWidth,
      contentPadding: contentPadding ?? _this.contentPadding,
      labelStyle: labelStyle ?? _this.labelStyle,
      helperStyle: helperStyle ?? _this.helperStyle,
      errorStyle: errorStyle ?? _this.errorStyle,
      focusDuration: focusDuration ?? _this.focusDuration,
      hintColor: hintColor ?? _this.hintColor,
    );
  }

  @override
  ThemeExtension<InputThemeExtension> lerp(
    ThemeExtension<InputThemeExtension>? other,
    double t,
  ) {
    if (other is! InputThemeExtension) {
      return this;
    }

    final _this = (this as InputThemeExtension);

    return InputThemeExtension(
      borderColor: WidgetStateProperty.lerp<Color?>(
        _this.borderColor,
        other.borderColor,
        t,
        Color.lerp,
      )!,
      fillColor: WidgetStateProperty.lerp<Color?>(
        _this.fillColor,
        other.fillColor,
        t,
        Color.lerp,
      )!,
      labelColor: WidgetStateProperty.lerp<Color?>(
        _this.labelColor,
        other.labelColor,
        t,
        Color.lerp,
      )!,
      borderRadius: BorderRadius.lerp(
        _this.borderRadius,
        other.borderRadius,
        t,
      )!,
      borderWidth: lerpDouble$(_this.borderWidth, other.borderWidth, t)!,
      focusedBorderWidth: lerpDouble$(
        _this.focusedBorderWidth,
        other.focusedBorderWidth,
        t,
      )!,
      contentPadding: EdgeInsets.lerp(
        _this.contentPadding,
        other.contentPadding,
        t,
      )!,
      labelStyle: TextStyle.lerp(_this.labelStyle, other.labelStyle, t)!,
      helperStyle: TextStyle.lerp(_this.helperStyle, other.helperStyle, t)!,
      errorStyle: TextStyle.lerp(_this.errorStyle, other.errorStyle, t)!,
      focusDuration: lerpDuration$(
        _this.focusDuration,
        other.focusDuration,
        t,
      )!,
      hintColor: Color.lerp(_this.hintColor, other.hintColor, t),
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

    final _this = (this as InputThemeExtension);
    final _other = (other as InputThemeExtension);

    return _other.borderColor == _this.borderColor &&
        _other.fillColor == _this.fillColor &&
        _other.labelColor == _this.labelColor &&
        _other.borderRadius == _this.borderRadius &&
        _other.borderWidth == _this.borderWidth &&
        _other.focusedBorderWidth == _this.focusedBorderWidth &&
        _other.contentPadding == _this.contentPadding &&
        _other.labelStyle == _this.labelStyle &&
        _other.helperStyle == _this.helperStyle &&
        _other.errorStyle == _this.errorStyle &&
        _other.focusDuration == _this.focusDuration &&
        _other.hintColor == _this.hintColor;
  }

  @override
  int get hashCode {
    final _this = (this as InputThemeExtension);

    return Object.hash(
      runtimeType,
      _this.borderColor,
      _this.fillColor,
      _this.labelColor,
      _this.borderRadius,
      _this.borderWidth,
      _this.focusedBorderWidth,
      _this.contentPadding,
      _this.labelStyle,
      _this.helperStyle,
      _this.errorStyle,
      _this.focusDuration,
      _this.hintColor,
    );
  }
}

extension InputThemeExtensionBuildContext on BuildContext {
  InputThemeExtension get inputTheme =>
      Theme.of(this).extension<InputThemeExtension>()!;
}
