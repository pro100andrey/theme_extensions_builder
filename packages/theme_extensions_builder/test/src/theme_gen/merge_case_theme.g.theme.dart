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
      hasBorder: t < 0.5 ? a.hasBorder : b.hasBorder,
      isOptional: t < 0.5 ? a.isOptional : b.isOptional,
      doubleValue: lerpDouble$(a.doubleValue, b.doubleValue, t)!,
      doubleValueOptional: lerpDouble$(
        a.doubleValueOptional,
        b.doubleValueOptional,
        t,
      ),
    );
  }

  MergeCaseTheme copyWith({
    BorderSide? borderSide,
    BorderSide? borderSideOptional,
    bool? hasBorder,
    bool? isOptional,
    double? doubleValue,
    double? doubleValueOptional,
  }) {
    final _this = (this as MergeCaseTheme);

    return MergeCaseTheme(
      borderSide: borderSide ?? _this.borderSide,
      borderSideOptional: borderSideOptional ?? _this.borderSideOptional,
      hasBorder: hasBorder ?? _this.hasBorder,
      isOptional: isOptional ?? _this.isOptional,
      doubleValue: doubleValue ?? _this.doubleValue,
      doubleValueOptional: doubleValueOptional ?? _this.doubleValueOptional,
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
      hasBorder: other.hasBorder,
      isOptional: other.isOptional,
      doubleValue: other.doubleValue,
      doubleValueOptional: other.doubleValueOptional,
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
        _other.hasBorder == _this.hasBorder &&
        _other.isOptional == _this.isOptional &&
        _other.doubleValue == _this.doubleValue &&
        _other.doubleValueOptional == _this.doubleValueOptional;
  }

  @override
  int get hashCode {
    final _this = (this as MergeCaseTheme);

    return Object.hash(
      runtimeType,
      _this.borderSide,
      _this.borderSideOptional,
      _this.hasBorder,
      _this.isOptional,
      _this.doubleValue,
      _this.doubleValueOptional,
    );
  }
}
