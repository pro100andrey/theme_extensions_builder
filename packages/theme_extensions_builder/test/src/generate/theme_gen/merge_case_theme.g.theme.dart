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
    if (a == null && b == null) {
      return null;
    }

    return MergeCaseTheme(borderSide: t < 0.5 ? a?.borderSide : b?.borderSide);
  }

  MergeCaseTheme copyWith({BorderSide? borderSide}) {
    final _this = (this as MergeCaseTheme);

    return MergeCaseTheme(borderSide: borderSide ?? _this.borderSide);
  }

  MergeCaseTheme merge(MergeCaseTheme? other) {
    final _this = (this as MergeCaseTheme);

    if (other == null) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      borderSide: BorderSide.merge(_this.borderSide, other.borderSide),
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

    return _other.borderSide == _this.borderSide;
  }

  @override
  int get hashCode {
    final _this = (this as MergeCaseTheme);

    return Object.hash(runtimeType, _this.borderSide);
  }
}
