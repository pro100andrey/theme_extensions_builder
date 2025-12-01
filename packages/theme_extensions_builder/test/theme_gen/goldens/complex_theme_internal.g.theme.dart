part of '../complex_theme.dart';

mixin _$ComplexThemeInternal {
  bool get canMerge => true;

  static ComplexThemeInternal? lerp(
    ComplexThemeInternal? a,
    ComplexThemeInternal? b,
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

    return ComplexThemeInternal._internal(
      requiredInt: t < 0.5 ? a.requiredInt : b.requiredInt,
      requiredDouble: lerpDouble$(a.requiredDouble, b.requiredDouble, t)!,
      requiredString: t < 0.5 ? a.requiredString : b.requiredString,
      requiredBool: t < 0.5 ? a.requiredBool : b.requiredBool,
      requiredDuration: lerpDuration$(
        a.requiredDuration,
        b.requiredDuration,
        t,
      )!,
      requiredColor: Color.lerp(a.requiredColor, b.requiredColor, t)!,
      requiredBorderSide: BorderSide.lerp(
        a.requiredBorderSide,
        b.requiredBorderSide,
        t,
      ),
      requiredTheme: EmptyTheme.lerp(a.requiredTheme, b.requiredTheme, t)!,
      requiredThemeExtension:
          (a.requiredThemeExtension.lerp(b.requiredThemeExtension, t)
              as EmptyThemeExtension),
      optionalInt: t < 0.5 ? a.optionalInt : b.optionalInt,
      optionalDouble: lerpDouble$(a.optionalDouble, b.optionalDouble, t),
      optionalString: t < 0.5 ? a.optionalString : b.optionalString,
      optionalBool: t < 0.5 ? a.optionalBool : b.optionalBool,
      optionalDuration: lerpDuration$(
        a.optionalDuration,
        b.optionalDuration,
        t,
      ),
      optionalColor: Color.lerp(a.optionalColor, b.optionalColor, t),
      optionalBorderSide: a.optionalBorderSide == null
          ? b.optionalBorderSide
          : b.optionalBorderSide == null
          ? a.optionalBorderSide
          : BorderSide.lerp(a.optionalBorderSide!, b.optionalBorderSide!, t),
      optionalTheme: EmptyTheme.lerp(a.optionalTheme, b.optionalTheme, t),
      optionalThemeExtension: t < 0.5
          ? a.optionalThemeExtension
          : b.optionalThemeExtension,
    );
  }

  ComplexThemeInternal copyWith({
    int? requiredInt,
    double? requiredDouble,
    String? requiredString,
    bool? requiredBool,
    Duration? requiredDuration,
    Color? requiredColor,
    BorderSide? requiredBorderSide,
    EmptyTheme? requiredTheme,
    EmptyThemeExtension? requiredThemeExtension,
    int? optionalInt,
    double? optionalDouble,
    String? optionalString,
    bool? optionalBool,
    Duration? optionalDuration,
    Color? optionalColor,
    BorderSide? optionalBorderSide,
    EmptyTheme? optionalTheme,
    EmptyThemeExtension? optionalThemeExtension,
  }) {
    final _this = (this as ComplexThemeInternal);

    return ComplexThemeInternal._internal(
      requiredInt: requiredInt ?? _this.requiredInt,
      requiredDouble: requiredDouble ?? _this.requiredDouble,
      requiredString: requiredString ?? _this.requiredString,
      requiredBool: requiredBool ?? _this.requiredBool,
      requiredDuration: requiredDuration ?? _this.requiredDuration,
      requiredColor: requiredColor ?? _this.requiredColor,
      requiredBorderSide: requiredBorderSide ?? _this.requiredBorderSide,
      requiredTheme: requiredTheme ?? _this.requiredTheme,
      requiredThemeExtension:
          requiredThemeExtension ?? _this.requiredThemeExtension,
      optionalInt: optionalInt ?? _this.optionalInt,
      optionalDouble: optionalDouble ?? _this.optionalDouble,
      optionalString: optionalString ?? _this.optionalString,
      optionalBool: optionalBool ?? _this.optionalBool,
      optionalDuration: optionalDuration ?? _this.optionalDuration,
      optionalColor: optionalColor ?? _this.optionalColor,
      optionalBorderSide: optionalBorderSide ?? _this.optionalBorderSide,
      optionalTheme: optionalTheme ?? _this.optionalTheme,
      optionalThemeExtension:
          optionalThemeExtension ?? _this.optionalThemeExtension,
    );
  }

  ComplexThemeInternal merge(ComplexThemeInternal? other) {
    final _this = (this as ComplexThemeInternal);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      requiredInt: other.requiredInt,
      requiredDouble: other.requiredDouble,
      requiredString: other.requiredString,
      requiredBool: other.requiredBool,
      requiredDuration: other.requiredDuration,
      requiredColor: other.requiredColor,
      requiredBorderSide: BorderSide.merge(
        _this.requiredBorderSide,
        other.requiredBorderSide,
      ),
      requiredTheme: _this.requiredTheme.merge(other.requiredTheme),
      requiredThemeExtension: other.requiredThemeExtension,
      optionalInt: other.optionalInt,
      optionalDouble: other.optionalDouble,
      optionalString: other.optionalString,
      optionalBool: other.optionalBool,
      optionalDuration: other.optionalDuration,
      optionalColor: other.optionalColor,
      optionalBorderSide:
          _this.optionalBorderSide != null && other.optionalBorderSide != null
          ? BorderSide.merge(
              _this.optionalBorderSide!,
              other.optionalBorderSide!,
            )
          : other.optionalBorderSide,
      optionalTheme:
          _this.optionalTheme?.merge(other.optionalTheme) ??
          other.optionalTheme,
      optionalThemeExtension: other.optionalThemeExtension,
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

    final _this = (this as ComplexThemeInternal);
    final _other = (other as ComplexThemeInternal);

    return _other.requiredInt == _this.requiredInt &&
        _other.requiredDouble == _this.requiredDouble &&
        _other.requiredString == _this.requiredString &&
        _other.requiredBool == _this.requiredBool &&
        _other.requiredDuration == _this.requiredDuration &&
        _other.requiredColor == _this.requiredColor &&
        _other.requiredBorderSide == _this.requiredBorderSide &&
        _other.requiredTheme == _this.requiredTheme &&
        _other.requiredThemeExtension == _this.requiredThemeExtension &&
        _other.optionalInt == _this.optionalInt &&
        _other.optionalDouble == _this.optionalDouble &&
        _other.optionalString == _this.optionalString &&
        _other.optionalBool == _this.optionalBool &&
        _other.optionalDuration == _this.optionalDuration &&
        _other.optionalColor == _this.optionalColor &&
        _other.optionalBorderSide == _this.optionalBorderSide &&
        _other.optionalTheme == _this.optionalTheme &&
        _other.optionalThemeExtension == _this.optionalThemeExtension;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeInternal);

    return Object.hash(
      runtimeType,
      _this.requiredInt,
      _this.requiredDouble,
      _this.requiredString,
      _this.requiredBool,
      _this.requiredDuration,
      _this.requiredColor,
      _this.requiredBorderSide,
      _this.requiredTheme,
      _this.requiredThemeExtension,
      _this.optionalInt,
      _this.optionalDouble,
      _this.optionalString,
      _this.optionalBool,
      _this.optionalDuration,
      _this.optionalColor,
      _this.optionalBorderSide,
      _this.optionalTheme,
      _this.optionalThemeExtension,
    );
  }
}
