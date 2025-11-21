// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'empty.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$Empty {
  bool get canMerge => true;

  static Empty? lerp(Empty? a, Empty? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return Empty();
  }

  Empty copyWith() {
    return Empty();
  }

  Empty merge(Empty? other) {
    final current = (this as Empty);

    if (other == null) {
      return current;
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

    if (other is! Empty) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
