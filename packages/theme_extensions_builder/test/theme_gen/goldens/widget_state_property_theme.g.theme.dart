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

    return const WidgetStatePropertyTheme();
  }

  WidgetStatePropertyTheme copyWith() {
    return const WidgetStatePropertyTheme();
  }

  WidgetStatePropertyTheme merge(WidgetStatePropertyTheme? other) {
    final _this = (this as WidgetStatePropertyTheme);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
