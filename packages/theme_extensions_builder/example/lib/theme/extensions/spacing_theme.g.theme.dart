// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'spacing_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$SpacingThemeExtension on ThemeExtension<SpacingThemeExtension> {
  @override
  ThemeExtension<SpacingThemeExtension> copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? pageHorizontal,
    double? pageVertical,
    double? sectionSpacing,
    double? cardSpacing,
  }) {
    final _this = (this as SpacingThemeExtension);

    return SpacingThemeExtension(
      xs: xs ?? _this.xs,
      sm: sm ?? _this.sm,
      md: md ?? _this.md,
      lg: lg ?? _this.lg,
      xl: xl ?? _this.xl,
      xxl: xxl ?? _this.xxl,
      pageHorizontal: pageHorizontal ?? _this.pageHorizontal,
      pageVertical: pageVertical ?? _this.pageVertical,
      sectionSpacing: sectionSpacing ?? _this.sectionSpacing,
      cardSpacing: cardSpacing ?? _this.cardSpacing,
    );
  }

  @override
  ThemeExtension<SpacingThemeExtension> lerp(
    ThemeExtension<SpacingThemeExtension>? other,
    double t,
  ) {
    if (other is! SpacingThemeExtension) {
      return this;
    }

    final _this = (this as SpacingThemeExtension);

    return SpacingThemeExtension(
      xs: lerpDouble$(_this.xs, other.xs, t)!,
      sm: lerpDouble$(_this.sm, other.sm, t)!,
      md: lerpDouble$(_this.md, other.md, t)!,
      lg: lerpDouble$(_this.lg, other.lg, t)!,
      xl: lerpDouble$(_this.xl, other.xl, t)!,
      xxl: lerpDouble$(_this.xxl, other.xxl, t)!,
      pageHorizontal: lerpDouble$(
        _this.pageHorizontal,
        other.pageHorizontal,
        t,
      )!,
      pageVertical: lerpDouble$(_this.pageVertical, other.pageVertical, t)!,
      sectionSpacing: lerpDouble$(
        _this.sectionSpacing,
        other.sectionSpacing,
        t,
      )!,
      cardSpacing: lerpDouble$(_this.cardSpacing, other.cardSpacing, t)!,
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

    final _this = (this as SpacingThemeExtension);
    final _other = (other as SpacingThemeExtension);

    return _other.xs == _this.xs &&
        _other.sm == _this.sm &&
        _other.md == _this.md &&
        _other.lg == _this.lg &&
        _other.xl == _this.xl &&
        _other.xxl == _this.xxl &&
        _other.pageHorizontal == _this.pageHorizontal &&
        _other.pageVertical == _this.pageVertical &&
        _other.sectionSpacing == _this.sectionSpacing &&
        _other.cardSpacing == _this.cardSpacing;
  }

  @override
  int get hashCode {
    final _this = (this as SpacingThemeExtension);

    return Object.hash(
      runtimeType,
      _this.xs,
      _this.sm,
      _this.md,
      _this.lg,
      _this.xl,
      _this.xxl,
      _this.pageHorizontal,
      _this.pageVertical,
      _this.sectionSpacing,
      _this.cardSpacing,
    );
  }
}

extension SpacingThemeExtensionBuildContext on BuildContext {
  SpacingThemeExtension get spacingTheme =>
      Theme.of(this).extension<SpacingThemeExtension>()!;
}
