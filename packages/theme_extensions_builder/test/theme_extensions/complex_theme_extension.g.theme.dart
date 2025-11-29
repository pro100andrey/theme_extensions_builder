// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'complex_theme_extension.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

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
    EmptyTheme? requiredTheme,
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
      requiredTheme: EmptyTheme.lerp(
        _this.requiredTheme,
        other.requiredTheme,
        t,
      )!,
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

mixin _$ComplexThemeExtensionCustomAccessor
    on ThemeExtension<ComplexThemeExtensionCustomAccessor> {
  @override
  ThemeExtension<ComplexThemeExtensionCustomAccessor> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    double? spacing,
  }) {
    final _this = (this as ComplexThemeExtensionCustomAccessor);

    return ComplexThemeExtensionCustomAccessor(
      primaryColor: primaryColor ?? _this.primaryColor,
      secondaryColor: secondaryColor ?? _this.secondaryColor,
      spacing: spacing ?? _this.spacing,
    );
  }

  @override
  ThemeExtension<ComplexThemeExtensionCustomAccessor> lerp(
    ThemeExtension<ComplexThemeExtensionCustomAccessor>? other,
    double t,
  ) {
    if (other is! ComplexThemeExtensionCustomAccessor) {
      return this;
    }

    final _this = (this as ComplexThemeExtensionCustomAccessor);

    return ComplexThemeExtensionCustomAccessor(
      primaryColor: Color.lerp(_this.primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(_this.secondaryColor, other.secondaryColor, t),
      spacing: lerpDouble$(_this.spacing, other.spacing, t)!,
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

    final _this = (this as ComplexThemeExtensionCustomAccessor);
    final _other = (other as ComplexThemeExtensionCustomAccessor);

    return _other.primaryColor == _this.primaryColor &&
        _other.secondaryColor == _this.secondaryColor &&
        _other.spacing == _this.spacing;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeExtensionCustomAccessor);

    return Object.hash(
      runtimeType,
      _this.primaryColor,
      _this.secondaryColor,
      _this.spacing,
    );
  }
}

extension ComplexThemeExtensionCustomAccessorBuildContext on BuildContext {
  ComplexThemeExtensionCustomAccessor get myCustomTheme =>
      Theme.of(this).extension<ComplexThemeExtensionCustomAccessor>()!;
}

mixin _$ComplexThemeExtension on ThemeExtension<ComplexThemeExtension> {
  @override
  ThemeExtension<ComplexThemeExtension> copyWith({
    int? requiredInt,
    double? requiredDouble,
    String? requiredString,
    bool? requiredBool,
    Duration? requiredDuration,
    Color? requiredColor,
    BorderSide? requiredBorderSide,
    EmptyTheme? requiredTheme,
    int? optionalInt,
    double? optionalDouble,
    String? optionalString,
    bool? optionalBool,
    Duration? optionalDuration,
    Color? optionalColor,
    BorderSide? optionalBorderSide,
    EmptyTheme? optionalTheme,
  }) {
    final _this = (this as ComplexThemeExtension);

    return ComplexThemeExtension(
      requiredInt: requiredInt ?? _this.requiredInt,
      requiredDouble: requiredDouble ?? _this.requiredDouble,
      requiredString: requiredString ?? _this.requiredString,
      requiredBool: requiredBool ?? _this.requiredBool,
      requiredDuration: requiredDuration ?? _this.requiredDuration,
      requiredColor: requiredColor ?? _this.requiredColor,
      requiredBorderSide: requiredBorderSide ?? _this.requiredBorderSide,
      requiredTheme: requiredTheme ?? _this.requiredTheme,
      optionalInt: optionalInt ?? _this.optionalInt,
      optionalDouble: optionalDouble ?? _this.optionalDouble,
      optionalString: optionalString ?? _this.optionalString,
      optionalBool: optionalBool ?? _this.optionalBool,
      optionalDuration: optionalDuration ?? _this.optionalDuration,
      optionalColor: optionalColor ?? _this.optionalColor,
      optionalBorderSide: optionalBorderSide ?? _this.optionalBorderSide,
      optionalTheme: optionalTheme ?? _this.optionalTheme,
    );
  }

  @override
  ThemeExtension<ComplexThemeExtension> lerp(
    ThemeExtension<ComplexThemeExtension>? other,
    double t,
  ) {
    if (other is! ComplexThemeExtension) {
      return this;
    }

    final _this = (this as ComplexThemeExtension);

    return ComplexThemeExtension(
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
      requiredTheme: EmptyTheme.lerp(
        _this.requiredTheme,
        other.requiredTheme,
        t,
      )!,
      optionalInt: t < 0.5 ? _this.optionalInt : other.optionalInt,
      optionalDouble: lerpDouble$(
        _this.optionalDouble,
        other.optionalDouble,
        t,
      ),
      optionalString: t < 0.5 ? _this.optionalString : other.optionalString,
      optionalBool: t < 0.5 ? _this.optionalBool : other.optionalBool,
      optionalDuration: lerpDuration$(
        _this.optionalDuration,
        other.optionalDuration,
        t,
      ),
      optionalColor: Color.lerp(_this.optionalColor, other.optionalColor, t),
      optionalBorderSide:
          _this.optionalBorderSide == null || other.optionalBorderSide == null
          ? null
          : BorderSide.lerp(
              _this.optionalBorderSide!,
              other.optionalBorderSide!,
              t,
            ),
      optionalTheme: EmptyTheme.lerp(
        _this.optionalTheme,
        other.optionalTheme,
        t,
      ),
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

    final _this = (this as ComplexThemeExtension);
    final _other = (other as ComplexThemeExtension);

    return _other.requiredInt == _this.requiredInt &&
        _other.requiredDouble == _this.requiredDouble &&
        _other.requiredString == _this.requiredString &&
        _other.requiredBool == _this.requiredBool &&
        _other.requiredDuration == _this.requiredDuration &&
        _other.requiredColor == _this.requiredColor &&
        _other.requiredBorderSide == _this.requiredBorderSide &&
        _other.requiredTheme == _this.requiredTheme &&
        _other.optionalInt == _this.optionalInt &&
        _other.optionalDouble == _this.optionalDouble &&
        _other.optionalString == _this.optionalString &&
        _other.optionalBool == _this.optionalBool &&
        _other.optionalDuration == _this.optionalDuration &&
        _other.optionalColor == _this.optionalColor &&
        _other.optionalBorderSide == _this.optionalBorderSide &&
        _other.optionalTheme == _this.optionalTheme;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeExtension);

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
      _this.optionalInt,
      _this.optionalDouble,
      _this.optionalString,
      _this.optionalBool,
      _this.optionalDuration,
      _this.optionalColor,
      _this.optionalBorderSide,
      _this.optionalTheme,
    );
  }
}

extension ComplexThemeExtensionBuildContext on BuildContext {
  ComplexThemeExtension get complexTheme =>
      Theme.of(this).extension<ComplexThemeExtension>()!;
}
