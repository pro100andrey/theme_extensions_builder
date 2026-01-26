part of '../widget_state_property_theme_extension.dart';

mixin _$WidgetStatePropertyThemeExtension
    on ThemeExtension<WidgetStatePropertyThemeExtension> {
  @override
  ThemeExtension<WidgetStatePropertyThemeExtension> copyWith({
    WidgetStateProperty<double?>? fontSize,
    WidgetStateProperty<Color?>? color,
    WidgetStateProperty<Duration?>? animationDuration,
    WidgetStateProperty<double?>? optionalFontSize,
    WidgetStateProperty<Color?>? optionalColor,
    WidgetStateProperty<Duration?>? optionalAnimationDuration,
  }) {
    final _this = (this as WidgetStatePropertyThemeExtension);

    return WidgetStatePropertyThemeExtension(
      fontSize: fontSize ?? _this.fontSize,
      color: color ?? _this.color,
      animationDuration: animationDuration ?? _this.animationDuration,
      optionalFontSize: optionalFontSize ?? _this.optionalFontSize,
      optionalColor: optionalColor ?? _this.optionalColor,
      optionalAnimationDuration:
          optionalAnimationDuration ?? _this.optionalAnimationDuration,
    );
  }

  @override
  ThemeExtension<WidgetStatePropertyThemeExtension> lerp(
    ThemeExtension<WidgetStatePropertyThemeExtension>? other,
    double t,
  ) {
    if (other is! WidgetStatePropertyThemeExtension) {
      return this;
    }

    final _this = (this as WidgetStatePropertyThemeExtension);

    return WidgetStatePropertyThemeExtension(
      fontSize: WidgetStateProperty.lerp<double?>(
        _this.fontSize,
        other.fontSize,
        t,
        lerpDouble$,
      )!,
      color: WidgetStateProperty.lerp<Color?>(
        _this.color,
        other.color,
        t,
        Color.lerp,
      )!,
      animationDuration: WidgetStateProperty.lerp<Duration?>(
        _this.animationDuration,
        other.animationDuration,
        t,
        lerpDuration$,
      )!,
      optionalFontSize: WidgetStateProperty.lerp<double?>(
        _this.optionalFontSize,
        other.optionalFontSize,
        t,
        lerpDouble$,
      ),
      optionalColor: WidgetStateProperty.lerp<Color?>(
        _this.optionalColor,
        other.optionalColor,
        t,
        Color.lerp,
      ),
      optionalAnimationDuration: WidgetStateProperty.lerp<Duration?>(
        _this.optionalAnimationDuration,
        other.optionalAnimationDuration,
        t,
        lerpDuration$,
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

    final _this = (this as WidgetStatePropertyThemeExtension);
    final _other = (other as WidgetStatePropertyThemeExtension);

    return _other.fontSize == _this.fontSize &&
        _other.color == _this.color &&
        _other.animationDuration == _this.animationDuration &&
        _other.optionalFontSize == _this.optionalFontSize &&
        _other.optionalColor == _this.optionalColor &&
        _other.optionalAnimationDuration == _this.optionalAnimationDuration;
  }

  @override
  int get hashCode {
    final _this = (this as WidgetStatePropertyThemeExtension);

    return Object.hash(
      runtimeType,
      _this.fontSize,
      _this.color,
      _this.animationDuration,
      _this.optionalFontSize,
      _this.optionalColor,
      _this.optionalAnimationDuration,
    );
  }
}

extension WidgetStatePropertyThemeExtensionBuildContext on BuildContext {
  WidgetStatePropertyThemeExtension get widgetStatePropertyTheme =>
      Theme.of(this).extension<WidgetStatePropertyThemeExtension>()!;
}
