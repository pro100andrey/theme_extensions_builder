// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'widget_state_property_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

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
      backgroundColor: WidgetStateProperty.lerp<Color?>(
        a.backgroundColor,
        b.backgroundColor,
        t,
        Color.lerp,
      ),
      width: WidgetStateProperty.lerp<double?>(
        a.width,
        b.width,
        t,
        lerpDouble$,
      ),
      duration: WidgetStateProperty.lerp<Duration?>(
        a.duration,
        b.duration,
        t,
        lerpDuration$,
      ),
    );
  }

  WidgetStatePropertyTheme copyWith({
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<double?>? width,
    WidgetStateProperty<Duration?>? duration,
  }) {
    final _this = (this as WidgetStatePropertyTheme);

    return WidgetStatePropertyTheme(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
      width: width ?? _this.width,
      duration: duration ?? _this.duration,
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
      backgroundColor: other.backgroundColor,
      width: other.width,
      duration: other.duration,
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

    return _other.backgroundColor == _this.backgroundColor &&
        _other.width == _this.width &&
        _other.duration == _this.duration;
  }

  @override
  int get hashCode {
    final _this = (this as WidgetStatePropertyTheme);

    return Object.hash(
      runtimeType,
      _this.backgroundColor,
      _this.width,
      _this.duration,
    );
  }
}
