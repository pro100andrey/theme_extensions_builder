part of '../complex_theme_extension.dart';

mixin _$ComplexThemeExtensionNoContext
    on ThemeExtension<ComplexThemeExtensionNoContext> {
  @override
  ThemeExtension<ComplexThemeExtensionNoContext> copyWith({
    int? requiredInt,
    double? requiredDouble,
    String? requiredString,
    bool? requiredBool,
    Duration? requiredDuration,
    Color? requiredColor,
    BorderSide? requiredBorderSide,
    InvalidType? requiredTheme,
  }) {
    final _this = (this as ComplexThemeExtensionNoContext);

    return ComplexThemeExtensionNoContext._internal(
      requiredInt: requiredInt ?? _this.requiredInt,
      requiredDouble: requiredDouble ?? _this.requiredDouble,
      requiredString: requiredString ?? _this.requiredString,
      requiredBool: requiredBool ?? _this.requiredBool,
      requiredDuration: requiredDuration ?? _this.requiredDuration,
      requiredColor: requiredColor ?? _this.requiredColor,
      requiredBorderSide: requiredBorderSide ?? _this.requiredBorderSide,
      requiredTheme: requiredTheme ?? _this.requiredTheme,
    );
  }

  @override
  ThemeExtension<ComplexThemeExtensionNoContext> lerp(
    ThemeExtension<ComplexThemeExtensionNoContext>? other,
    double t,
  ) {
    if (other is! ComplexThemeExtensionNoContext) {
      return this;
    }

    final _this = (this as ComplexThemeExtensionNoContext);

    return ComplexThemeExtensionNoContext._internal(
      requiredInt: t < 0.5 ? _this.requiredInt : other.requiredInt,
      requiredDouble: lerpDouble$(
        _this.requiredDouble,
        other.requiredDouble,
        t,
      )!,
      requiredString: t < 0.5 ? _this.requiredString : other.requiredString,
      requiredBool: t < 0.5 ? _this.requiredBool : other.requiredBool,
      requiredDuration: lerpDuration$(
        _this.requiredDuration,
        other.requiredDuration,
        t,
      )!,
      requiredColor: Color.lerp(_this.requiredColor, other.requiredColor, t)!,
      requiredBorderSide: BorderSide.lerp(
        _this.requiredBorderSide,
        other.requiredBorderSide,
        t,
      ),
      requiredTheme: t < 0.5 ? _this.requiredTheme : other.requiredTheme,
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

    final _this = (this as ComplexThemeExtensionNoContext);
    final _other = (other as ComplexThemeExtensionNoContext);

    return _other.requiredInt == _this.requiredInt &&
        _other.requiredDouble == _this.requiredDouble &&
        _other.requiredString == _this.requiredString &&
        _other.requiredBool == _this.requiredBool &&
        _other.requiredDuration == _this.requiredDuration &&
        _other.requiredColor == _this.requiredColor &&
        _other.requiredBorderSide == _this.requiredBorderSide &&
        _other.requiredTheme == _this.requiredTheme;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeExtensionNoContext);

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
    );
  }
}
