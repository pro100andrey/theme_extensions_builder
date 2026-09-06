// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'inherited_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$InheritedTheme {
  bool get canMerge => true;

  static InheritedTheme? lerp(InheritedTheme? a, InheritedTheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return InheritedTheme(inherited: t < 0.5 ? a.inherited : b.inherited);
  }

  InheritedTheme copyWith({int? inherited}) {
    final _this = (this as InheritedTheme);

    return InheritedTheme(inherited: inherited ?? _this.inherited);
  }

  InheritedTheme merge(InheritedTheme? other) {
    final _this = (this as InheritedTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(inherited: other.inherited);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as InheritedTheme);
    final _other = (other as InheritedTheme);

    return _other.inherited == _this.inherited;
  }

  @override
  int get hashCode {
    final _this = (this as InheritedTheme);

    return Object.hash(runtimeType, _this.inherited);
  }
}

mixin _$GenericInheritedTheme {
  bool get canMerge => true;

  static GenericInheritedTheme? lerp(
    GenericInheritedTheme? a,
    GenericInheritedTheme? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return GenericInheritedTheme(value: t < 0.5 ? a.value : b.value);
  }

  GenericInheritedTheme copyWith({num? value}) {
    final _this = (this as GenericInheritedTheme);

    return GenericInheritedTheme(value: value ?? _this.value);
  }

  GenericInheritedTheme merge(GenericInheritedTheme? other) {
    final _this = (this as GenericInheritedTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(value: other.value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as GenericInheritedTheme);
    final _other = (other as GenericInheritedTheme);

    return _other.value == _this.value;
  }

  @override
  int get hashCode {
    final _this = (this as GenericInheritedTheme);

    return Object.hash(runtimeType, _this.value);
  }
}
