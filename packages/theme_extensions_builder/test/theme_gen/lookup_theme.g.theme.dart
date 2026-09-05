// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'lookup_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$LookupTheme {
  bool get canMerge => true;

  static LookupTheme? lerp(LookupTheme? a, LookupTheme? b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return LookupTheme(
      curve: t < 0.5 ? a.curve : b.curve,
      settings: t < 0.5 ? a.settings : b.settings,
      optionalSettings: t < 0.5 ? a.optionalSettings : b.optionalSettings,
      flags: t < 0.5 ? a.flags : b.flags,
      clamped: t < 0.5 ? a.clamped : b.clamped,
      unrelated: t < 0.5 ? a.unrelated : b.unrelated,
      narrowed: t < 0.5 ? a.narrowed : b.narrowed,
    );
  }

  LookupTheme copyWith({
    Curve? curve,
    Settings? settings,
    Settings? optionalSettings,
    Flags? flags,
    Clamped? clamped,
    Unrelated? unrelated,
    int? narrowed,
  }) {
    final _this = (this as LookupTheme);

    return LookupTheme(
      curve: curve ?? _this.curve,
      settings: settings ?? _this.settings,
      optionalSettings: optionalSettings ?? _this.optionalSettings,
      flags: flags ?? _this.flags,
      clamped: clamped ?? _this.clamped,
      unrelated: unrelated ?? _this.unrelated,
      narrowed: narrowed ?? _this.narrowed,
    );
  }

  LookupTheme merge(LookupTheme? other) {
    final _this = (this as LookupTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      curve: other.curve,
      settings: _this.settings.merge(other.settings),
      optionalSettings: _this.optionalSettings == null
          ? other.optionalSettings
          : other.optionalSettings == null
          ? _this.optionalSettings
          : _this.optionalSettings!.merge(other.optionalSettings!),
      flags: other.flags,
      clamped: other.clamped,
      unrelated: other.unrelated,
      narrowed: other.narrowed,
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

    final _this = (this as LookupTheme);
    final _other = (other as LookupTheme);

    return _other.curve == _this.curve &&
        _other.settings == _this.settings &&
        _other.optionalSettings == _this.optionalSettings &&
        _other.flags == _this.flags &&
        _other.clamped == _this.clamped &&
        _other.unrelated == _this.unrelated &&
        _other.narrowed == _this.narrowed;
  }

  @override
  int get hashCode {
    final _this = (this as LookupTheme);

    return Object.hash(
      runtimeType,
      _this.curve,
      _this.settings,
      _this.optionalSettings,
      _this.flags,
      _this.clamped,
      _this.unrelated,
      _this.narrowed,
    );
  }
}
