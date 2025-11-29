// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'empty_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$EmptyTheme {
  bool get canMerge => true;

  static EmptyTheme? lerp(EmptyTheme? a, EmptyTheme? b, double t) {
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

    return const EmptyTheme();
  }

  EmptyTheme copyWith() {
    return const EmptyTheme();
  }

  EmptyTheme merge(EmptyTheme? other) {
    final _this = (this as EmptyTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
