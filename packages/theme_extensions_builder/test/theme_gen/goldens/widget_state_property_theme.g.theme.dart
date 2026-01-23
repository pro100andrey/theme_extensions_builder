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
      backgroundColor: t < 0.5 ? a.backgroundColor : b.backgroundColor,
    );
  }

  WidgetStatePropertyTheme copyWith({InvalidType? backgroundColor}) {
    final _this = (this as WidgetStatePropertyTheme);

    return WidgetStatePropertyTheme(
      backgroundColor: backgroundColor ?? _this.backgroundColor,
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

    return copyWith(backgroundColor: other.backgroundColor);
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

    return _other.backgroundColor == _this.backgroundColor;
  }

  @override
  int get hashCode {
    final _this = (this as WidgetStatePropertyTheme);

    return Object.hash(runtimeType, _this.backgroundColor);
  }
}
