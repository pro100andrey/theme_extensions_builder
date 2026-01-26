part of '../widget_state_property_theme.dart';

mixin _$WidgetStatePropertyTheme {
  bool get canMerge => true;

  static WidgetStatePropertyTheme? lerp(
    WidgetStatePropertyTheme? a,
    WidgetStatePropertyTheme? b,
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

    return WidgetStatePropertyTheme(
      color: WidgetStateProperty.lerp<Color?>(a.color, b.color, t, Color.lerp)!,
      width: WidgetStateProperty.lerp<double?>(
        a.width,
        b.width,
        t,
        lerpDouble$,
      )!,
      duration: WidgetStateProperty.lerp<Duration?>(
        a.duration,
        b.duration,
        t,
        lerpDuration$,
      )!,
      optionalColor: WidgetStateProperty.lerp<Color?>(
        a.optionalColor,
        b.optionalColor,
        t,
        Color.lerp,
      )!,
      optionalWidth: WidgetStateProperty.lerp<double?>(
        a.optionalWidth,
        b.optionalWidth,
        t,
        lerpDouble$,
      )!,
      optionalDuration: WidgetStateProperty.lerp<Duration?>(
        a.optionalDuration,
        b.optionalDuration,
        t,
        lerpDuration$,
      )!,
    );
  }

  WidgetStatePropertyTheme copyWith({
    WidgetStateProperty<Color?>? color,
    WidgetStateProperty<double?>? width,
    WidgetStateProperty<Duration?>? duration,
    WidgetStateProperty<Color?>? optionalColor,
    WidgetStateProperty<double?>? optionalWidth,
    WidgetStateProperty<Duration?>? optionalDuration,
  }) {
    final _this = (this as WidgetStatePropertyTheme);

    return WidgetStatePropertyTheme(
      color: color ?? _this.color,
      width: width ?? _this.width,
      duration: duration ?? _this.duration,
      optionalColor: optionalColor ?? _this.optionalColor,
      optionalWidth: optionalWidth ?? _this.optionalWidth,
      optionalDuration: optionalDuration ?? _this.optionalDuration,
    );
  }

  WidgetStatePropertyTheme merge(WidgetStatePropertyTheme? other) {
    final _this = (this as WidgetStatePropertyTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      color: other.color,
      width: other.width,
      duration: other.duration,
      optionalColor: other.optionalColor,
      optionalWidth: other.optionalWidth,
      optionalDuration: other.optionalDuration,
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

    final _this = (this as WidgetStatePropertyTheme);
    final _other = (other as WidgetStatePropertyTheme);

    return _other.color == _this.color &&
        _other.width == _this.width &&
        _other.duration == _this.duration &&
        _other.optionalColor == _this.optionalColor &&
        _other.optionalWidth == _this.optionalWidth &&
        _other.optionalDuration == _this.optionalDuration;
  }

  @override
  int get hashCode {
    final _this = (this as WidgetStatePropertyTheme);

    return Object.hash(
      runtimeType,
      _this.color,
      _this.width,
      _this.duration,
      _this.optionalColor,
      _this.optionalWidth,
      _this.optionalDuration,
    );
  }
}
