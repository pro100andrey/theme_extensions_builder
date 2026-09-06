part of '../lookup_theme.dart';

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
      mode: t < 0.5 ? a.mode : b.mode,
      pair: t < 0.5 ? a.pair : b.pair,
      strict: t < 0.5 ? a.strict : b.strict,
      box: a.box.lerp(b.box, t),
      special: a.special == null || b.special == null
          ? t < 0.5
                ? a.special
                : b.special
          : (a.special!.lerp(b.special!, t) as Special?),
      soft: a.soft.lerp(b.soft, t)!,
      fade: t < 0.5 ? a.fade : b.fade,
      ratio: t < 0.5 ? a.ratio : b.ratio,
      counter: t < 0.5 ? a.counter : b.counter,
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
    Mode? mode,
    Pair? pair,
    Strict? strict,
    Box<int>? box,
    Special? special,
    Soft? soft,
    Fade? fade,
    Ratio? ratio,
    Counter? counter,
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
      mode: mode ?? _this.mode,
      pair: pair ?? _this.pair,
      strict: strict ?? _this.strict,
      box: box ?? _this.box,
      special: special ?? _this.special,
      soft: soft ?? _this.soft,
      fade: fade ?? _this.fade,
      ratio: ratio ?? _this.ratio,
      counter: counter ?? _this.counter,
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
      mode: other.mode,
      pair: other.pair,
      strict: other.strict,
      box: _this.box.merge(other.box),
      special: _this.special == null
          ? other.special
          : other.special == null
          ? _this.special
          : (_this.special!.merge(other.special!) as Special?),
      soft: other.soft,
      fade: other.fade,
      ratio: other.ratio,
      counter: other.counter,
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
        _other.mode == _this.mode &&
        _other.pair == _this.pair &&
        _other.strict == _this.strict &&
        _other.box == _this.box &&
        _other.special == _this.special &&
        _other.soft == _this.soft &&
        _other.fade == _this.fade &&
        _other.ratio == _this.ratio &&
        _other.counter == _this.counter &&
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
      _this.mode,
      _this.pair,
      _this.strict,
      _this.box,
      _this.special,
      _this.soft,
      _this.fade,
      _this.ratio,
      _this.counter,
      _this.narrowed,
    );
  }
}
