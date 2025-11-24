// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'card_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$CardThemeExtension on ThemeExtension<CardThemeExtension> {
  @override
  ThemeExtension<CardThemeExtension> copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Border? border,
    EdgeInsetsGeometry? padding,
  }) {
    final _this = (this as CardThemeExtension);

    return CardThemeExtension(
      borderRadius: borderRadius ?? _this.borderRadius,
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      boxShadow: boxShadow ?? _this.boxShadow,
      titleTextStyle: titleTextStyle ?? _this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? _this.subtitleTextStyle,
      border: border ?? _this.border,
      padding: padding ?? _this.padding,
    );
  }

  @override
  ThemeExtension<CardThemeExtension> lerp(
    ThemeExtension<CardThemeExtension>? other,
    double t,
  ) {
    if (other is! CardThemeExtension) {
      return this;
    }

    final _this = (this as CardThemeExtension);

    return CardThemeExtension(
      borderRadius: BorderRadius.lerp(
        _this.borderRadius,
        other.borderRadius,
        t,
      )!,
      backgroundColor: Color.lerp(
        _this.backgroundColor,
        other.backgroundColor,
        t,
      )!,
      boxShadow: t < 0.5 ? _this.boxShadow : other.boxShadow,
      titleTextStyle: TextStyle.lerp(
        _this.titleTextStyle,
        other.titleTextStyle,
        t,
      )!,
      subtitleTextStyle: TextStyle.lerp(
        _this.subtitleTextStyle,
        other.subtitleTextStyle,
        t,
      )!,
      border: Border.lerp(_this.border, other.border, t)!,
      padding: EdgeInsetsGeometry.lerp(_this.padding, other.padding, t)!,
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

    final _this = (this as CardThemeExtension);
    final _other = (other as CardThemeExtension);

    return _other.borderRadius == _this.borderRadius &&
        _other.backgroundColor == _this.backgroundColor &&
        _other.boxShadow == _this.boxShadow &&
        _other.titleTextStyle == _this.titleTextStyle &&
        _other.subtitleTextStyle == _this.subtitleTextStyle &&
        _other.border == _this.border &&
        _other.padding == _this.padding;
  }

  @override
  int get hashCode {
    final _this = (this as CardThemeExtension);

    return Object.hash(
      runtimeType,
      _this.borderRadius,
      _this.backgroundColor,
      _this.boxShadow,
      _this.titleTextStyle,
      _this.subtitleTextStyle,
      _this.border,
      _this.padding,
    );
  }
}

extension CardThemeExtensionBuildContext on BuildContext {
  CardThemeExtension get cardTheme =>
      Theme.of(this).extension<CardThemeExtension>()!;
}

mixin _$BaseTheme on ThemeExtension<BaseTheme> {
  @override
  ThemeExtension<BaseTheme> copyWith({
    CardThemeExtension? cardTheme,
    CardThemeExtension? cardTheme1,
    double? value,
    double? value1,
    Duration? duration,
    Duration? duration1,
  }) {
    final _this = (this as BaseTheme);

    return BaseTheme(
      cardTheme: cardTheme ?? _this.cardTheme,
      cardTheme1: cardTheme1 ?? _this.cardTheme1,
      value: value ?? _this.value,
      value1: value1 ?? _this.value1,
      duration: duration ?? _this.duration,
      duration1: duration1 ?? _this.duration1,
    );
  }

  @override
  ThemeExtension<BaseTheme> lerp(ThemeExtension<BaseTheme>? other, double t) {
    if (other is! BaseTheme) {
      return this;
    }

    final _this = (this as BaseTheme);

    return BaseTheme(
      cardTheme:
          (_this.cardTheme.lerp(other.cardTheme, t) as CardThemeExtension),
      cardTheme1:
          (_this.cardTheme1?.lerp(other.cardTheme1, t) as CardThemeExtension?),
      value: lerpDouble$(_this.value, other.value, t),
      value1: lerpDouble$(_this.value1, other.value1, t)!,
      duration: lerpDuration$(_this.duration, other.duration, t)!,
      duration1: lerpDuration$(_this.duration1, other.duration1, t),
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

    final _this = (this as BaseTheme);
    final _other = (other as BaseTheme);

    return _other.cardTheme == _this.cardTheme &&
        _other.cardTheme1 == _this.cardTheme1 &&
        _other.value == _this.value &&
        _other.value1 == _this.value1 &&
        _other.duration == _this.duration &&
        _other.duration1 == _this.duration1;
  }

  @override
  int get hashCode {
    final _this = (this as BaseTheme);

    return Object.hash(
      runtimeType,
      _this.cardTheme,
      _this.cardTheme1,
      _this.value,
      _this.value1,
      _this.duration,
      _this.duration1,
    );
  }
}

extension BaseThemeBuildContext on BuildContext {
  BaseTheme get baseTheme => Theme.of(this).extension<BaseTheme>()!;
}

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$SimpleThemeGen {
  bool get canMerge => true;

  static SimpleThemeGen? lerp(SimpleThemeGen? a, SimpleThemeGen? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return SimpleThemeGen(
      size: lerpDouble$(a?.size, b?.size, t)!,
      name: t < 0.5 ? a?.name : b?.name,
      theme: SimpleThemeGen.lerp(a?.theme, b?.theme, t),
      baseTheme: (a?.baseTheme.lerp(b?.baseTheme, t) as BaseTheme),
      baseThemeOptional:
          (a?.baseThemeOptional?.lerp(b?.baseThemeOptional, t) as BaseTheme),
    );
  }

  SimpleThemeGen copyWith({
    double? size,
    String? name,
    SimpleThemeGen? theme,
    BaseTheme? baseTheme,
    BaseTheme? baseThemeOptional,
  }) {
    final _this = (this as SimpleThemeGen);

    return SimpleThemeGen(
      size: size ?? _this.size,
      name: name ?? _this.name,
      theme: theme ?? _this.theme,
      baseTheme: baseTheme ?? _this.baseTheme,
      baseThemeOptional: baseThemeOptional ?? _this.baseThemeOptional,
    );
  }

  SimpleThemeGen merge(SimpleThemeGen? other) {
    final _this = (this as SimpleThemeGen);

    if (other == null) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      size: other.size,
      name: other.name,
      theme: other.theme,
      baseTheme: other.baseTheme,
      baseThemeOptional: other.baseThemeOptional,
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

    final _this = (this as SimpleThemeGen);
    final _other = (other as SimpleThemeGen);

    return _other.size == _this.size &&
        _other.name == _this.name &&
        _other.theme == _this.theme &&
        _other.baseTheme == _this.baseTheme &&
        _other.baseThemeOptional == _this.baseThemeOptional;
  }

  @override
  int get hashCode {
    final _this = (this as SimpleThemeGen);

    return Object.hash(
      runtimeType,
      _this.size,
      _this.name,
      _this.theme,
      _this.baseTheme,
      _this.baseThemeOptional,
    );
  }
}
