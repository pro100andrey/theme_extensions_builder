part of '../inherited_theme.dart';

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
