// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'merge_case_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$MergeCaseTheme {
  bool get canMerge => true;

  static MergeCaseTheme? lerp(MergeCaseTheme? a, MergeCaseTheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return MergeCaseTheme(
      borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
      borderSideOptional: a.borderSideOptional == null
          ? b.borderSideOptional
          : b.borderSideOptional == null
          ? a.borderSideOptional
          : BorderSide.lerp(a.borderSideOptional!, b.borderSideOptional!, t),
      theme: EmptyTheme.lerp(a.theme, b.theme, t)!,
      optionalTheme: EmptyTheme.lerp(a.optionalTheme, b.optionalTheme, t),
      themeExtension:
          (a.themeExtension.lerp(b.themeExtension, t) as EmptyThemeExtension),
      optionalThemeExtension: t < 0.5
          ? a.optionalThemeExtension
          : b.optionalThemeExtension,
      hasBorder: t < 0.5 ? a.hasBorder : b.hasBorder,
      isOptional: t < 0.5 ? a.isOptional : b.isOptional,
      doubleValue: lerpDouble$(a.doubleValue, b.doubleValue, t)!,
      doubleValueOptional: lerpDouble$(
        a.doubleValueOptional,
        b.doubleValueOptional,
        t,
      ),
      duration: lerpDuration$(a.duration, b.duration, t)!,
    );
  }

  MergeCaseTheme copyWith({
    BorderSide? borderSide,
    BorderSide? borderSideOptional,
    EmptyTheme? theme,
    EmptyTheme? optionalTheme,
    EmptyThemeExtension? themeExtension,
    EmptyThemeExtension? optionalThemeExtension,
    bool? hasBorder,
    bool? isOptional,
    double? doubleValue,
    double? doubleValueOptional,
    Duration? duration,
  }) {
    final _this = (this as MergeCaseTheme);

    return MergeCaseTheme(
      borderSide: borderSide ?? _this.borderSide,
      borderSideOptional: borderSideOptional ?? _this.borderSideOptional,
      theme: theme ?? _this.theme,
      optionalTheme: optionalTheme ?? _this.optionalTheme,
      themeExtension: themeExtension ?? _this.themeExtension,
      optionalThemeExtension:
          optionalThemeExtension ?? _this.optionalThemeExtension,
      hasBorder: hasBorder ?? _this.hasBorder,
      isOptional: isOptional ?? _this.isOptional,
      doubleValue: doubleValue ?? _this.doubleValue,
      doubleValueOptional: doubleValueOptional ?? _this.doubleValueOptional,
      duration: duration ?? _this.duration,
    );
  }

  MergeCaseTheme merge(MergeCaseTheme? other) {
    final _this = (this as MergeCaseTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      borderSide: BorderSide.merge(_this.borderSide, other.borderSide),
      borderSideOptional:
          _this.borderSideOptional != null && other.borderSideOptional != null
          ? BorderSide.merge(
              _this.borderSideOptional!,
              other.borderSideOptional!,
            )
          : other.borderSideOptional,
      theme: _this.theme.merge(other.theme),
      optionalTheme:
          _this.optionalTheme?.merge(other.optionalTheme) ??
          other.optionalTheme,
      themeExtension: other.themeExtension,
      optionalThemeExtension: other.optionalThemeExtension,
      hasBorder: other.hasBorder,
      isOptional: other.isOptional,
      doubleValue: other.doubleValue,
      doubleValueOptional: other.doubleValueOptional,
      duration: other.duration,
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

    final _this = (this as MergeCaseTheme);
    final _other = (other as MergeCaseTheme);

    return _other.borderSide == _this.borderSide &&
        _other.borderSideOptional == _this.borderSideOptional &&
        _other.theme == _this.theme &&
        _other.optionalTheme == _this.optionalTheme &&
        _other.themeExtension == _this.themeExtension &&
        _other.optionalThemeExtension == _this.optionalThemeExtension &&
        _other.hasBorder == _this.hasBorder &&
        _other.isOptional == _this.isOptional &&
        _other.doubleValue == _this.doubleValue &&
        _other.doubleValueOptional == _this.doubleValueOptional &&
        _other.duration == _this.duration;
  }

  @override
  int get hashCode {
    final _this = (this as MergeCaseTheme);

    return Object.hash(
      runtimeType,
      _this.borderSide,
      _this.borderSideOptional,
      _this.theme,
      _this.optionalTheme,
      _this.themeExtension,
      _this.optionalThemeExtension,
      _this.hasBorder,
      _this.isOptional,
      _this.doubleValue,
      _this.doubleValueOptional,
      _this.duration,
    );
  }
}
