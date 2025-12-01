// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'button_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$ButtonThemeExtension on ThemeExtension<ButtonThemeExtension> {
  @override
  ThemeExtension<ButtonThemeExtension> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? outlinedBorderColor,
    Color? textColor,
    Color? disabledColor,
    EdgeInsets? smallPadding,
    EdgeInsets? mediumPadding,
    EdgeInsets? largePadding,
    double? smallHeight,
    double? mediumHeight,
    double? largeHeight,
    BorderRadius? borderRadius,
    double? borderWidth,
    double? elevation,
    double? iconSpacing,
  }) {
    final _this = (this as ButtonThemeExtension);

    return ButtonThemeExtension(
      primaryColor: primaryColor ?? _this.primaryColor,
      secondaryColor: secondaryColor ?? _this.secondaryColor,
      outlinedBorderColor: outlinedBorderColor ?? _this.outlinedBorderColor,
      textColor: textColor ?? _this.textColor,
      disabledColor: disabledColor ?? _this.disabledColor,
      smallPadding: smallPadding ?? _this.smallPadding,
      mediumPadding: mediumPadding ?? _this.mediumPadding,
      largePadding: largePadding ?? _this.largePadding,
      smallHeight: smallHeight ?? _this.smallHeight,
      mediumHeight: mediumHeight ?? _this.mediumHeight,
      largeHeight: largeHeight ?? _this.largeHeight,
      borderRadius: borderRadius ?? _this.borderRadius,
      borderWidth: borderWidth ?? _this.borderWidth,
      elevation: elevation ?? _this.elevation,
      iconSpacing: iconSpacing ?? _this.iconSpacing,
    );
  }

  @override
  ThemeExtension<ButtonThemeExtension> lerp(
    ThemeExtension<ButtonThemeExtension>? other,
    double t,
  ) {
    if (other is! ButtonThemeExtension) {
      return this;
    }

    final _this = (this as ButtonThemeExtension);

    return ButtonThemeExtension(
      primaryColor: Color.lerp(_this.primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(
        _this.secondaryColor,
        other.secondaryColor,
        t,
      )!,
      outlinedBorderColor: Color.lerp(
        _this.outlinedBorderColor,
        other.outlinedBorderColor,
        t,
      )!,
      textColor: Color.lerp(_this.textColor, other.textColor, t)!,
      disabledColor: Color.lerp(_this.disabledColor, other.disabledColor, t)!,
      smallPadding: EdgeInsets.lerp(_this.smallPadding, other.smallPadding, t)!,
      mediumPadding: EdgeInsets.lerp(
        _this.mediumPadding,
        other.mediumPadding,
        t,
      )!,
      largePadding: EdgeInsets.lerp(_this.largePadding, other.largePadding, t)!,
      smallHeight: lerpDouble$(_this.smallHeight, other.smallHeight, t)!,
      mediumHeight: lerpDouble$(_this.mediumHeight, other.mediumHeight, t)!,
      largeHeight: lerpDouble$(_this.largeHeight, other.largeHeight, t)!,
      borderRadius: BorderRadius.lerp(
        _this.borderRadius,
        other.borderRadius,
        t,
      )!,
      borderWidth: lerpDouble$(_this.borderWidth, other.borderWidth, t)!,
      elevation: lerpDouble$(_this.elevation, other.elevation, t)!,
      iconSpacing: lerpDouble$(_this.iconSpacing, other.iconSpacing, t)!,
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

    final _this = (this as ButtonThemeExtension);
    final _other = (other as ButtonThemeExtension);

    return _other.primaryColor == _this.primaryColor &&
        _other.secondaryColor == _this.secondaryColor &&
        _other.outlinedBorderColor == _this.outlinedBorderColor &&
        _other.textColor == _this.textColor &&
        _other.disabledColor == _this.disabledColor &&
        _other.smallPadding == _this.smallPadding &&
        _other.mediumPadding == _this.mediumPadding &&
        _other.largePadding == _this.largePadding &&
        _other.smallHeight == _this.smallHeight &&
        _other.mediumHeight == _this.mediumHeight &&
        _other.largeHeight == _this.largeHeight &&
        _other.borderRadius == _this.borderRadius &&
        _other.borderWidth == _this.borderWidth &&
        _other.elevation == _this.elevation &&
        _other.iconSpacing == _this.iconSpacing;
  }

  @override
  int get hashCode {
    final _this = (this as ButtonThemeExtension);

    return Object.hash(
      runtimeType,
      _this.primaryColor,
      _this.secondaryColor,
      _this.outlinedBorderColor,
      _this.textColor,
      _this.disabledColor,
      _this.smallPadding,
      _this.mediumPadding,
      _this.largePadding,
      _this.smallHeight,
      _this.mediumHeight,
      _this.largeHeight,
      _this.borderRadius,
      _this.borderWidth,
      _this.elevation,
      _this.iconSpacing,
    );
  }
}

extension ButtonThemeExtensionBuildContext on BuildContext {
  ButtonThemeExtension get buttonTheme =>
      Theme.of(this).extension<ButtonThemeExtension>()!;
}
