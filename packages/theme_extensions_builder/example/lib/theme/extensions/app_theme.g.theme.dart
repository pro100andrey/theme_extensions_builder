// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'app_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AppThemeExtension on ThemeExtension<AppThemeExtension> {
  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    LayoutMode? layoutMode,
    BorderSide? borderSide,
    BorderSide? optionalBorderSide,
  }) {
    final _this = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: primaryColor ?? _this.primaryColor,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      layoutMode: layoutMode ?? _this.layoutMode,
      borderSide: borderSide ?? _this.borderSide,
      optionalBorderSide: optionalBorderSide ?? _this.optionalBorderSide,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    final _this = (this as AppThemeExtension);

    return AppThemeExtension(
      primaryColor: Color.lerp(_this.primaryColor, other.primaryColor, t)!,
      backgroundColor: Color.lerp(
        _this.backgroundColor,
        other.backgroundColor,
        t,
      )!,
      layoutMode: t < 0.5 ? _this.layoutMode : other.layoutMode,
      borderSide: BorderSide.lerp(_this.borderSide, other.borderSide, t),
      optionalBorderSide: _this.optionalBorderSide == null
          ? other.optionalBorderSide
          : other.optionalBorderSide == null
          ? _this.optionalBorderSide
          : BorderSide.lerp(
              _this.optionalBorderSide!,
              other.optionalBorderSide!,
              t,
            ),
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

    final _this = (this as AppThemeExtension);
    final _other = (other as AppThemeExtension);

    return _other.primaryColor == _this.primaryColor &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.layoutMode == _this.layoutMode &&
        _other.borderSide == _this.borderSide &&
        _other.optionalBorderSide == _this.optionalBorderSide;
  }

  @override
  int get hashCode {
    final _this = (this as AppThemeExtension);

    return Object.hash(
      runtimeType,
      _this.primaryColor,
      _this.backgroundColor,
      _this.layoutMode,
      _this.borderSide,
      _this.optionalBorderSide,
    );
  }
}

extension AppThemeExtensionBuildContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}
