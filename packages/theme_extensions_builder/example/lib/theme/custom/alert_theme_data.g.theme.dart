// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'alert_theme_data.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$AlertThemeData {
  bool get canMerge => true;

  static AlertThemeData? lerp(AlertThemeData? a, AlertThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return AlertThemeData(
      canMerge: b?.canMerge ?? true,
      transitionDuration: lerpDuration$(
        a?.transitionDuration,
        b?.transitionDuration,
        t,
      )!,
      iconPadding: EdgeInsetsGeometry.lerp(a?.iconPadding, b?.iconPadding, t),
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      mainAxisAlignment: t < 0.5 ? a?.mainAxisAlignment : b?.mainAxisAlignment,
      crossAxisAlignment: t < 0.5
          ? a?.crossAxisAlignment
          : b?.crossAxisAlignment,
      baseTheme: BaseTheme.lerp(a?.baseTheme, b?.baseTheme, t),
      borderRadius: lerpDouble$(a?.borderRadius, b?.borderRadius, t),
      borderSide: a != null && b != null
          ? BorderSide.lerp(a.borderSide!, b.borderSide!, t)
          : t < 0.5
          ? a?.borderSide
          : b?.borderSide,
      curve: t < 0.5 ? a?.curve : b?.curve,
      border: Border.lerp(a?.border, b?.border, t),
      animationDuration: lerpDuration$(
        a?.animationDuration,
        b?.animationDuration,
        t,
      ),
    );
  }

  AlertThemeData copyWith({
    bool? canMerge,
    Duration? transitionDuration,
    EdgeInsetsGeometry? iconPadding,
    TextStyle? titleTextStyle,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    BaseTheme? baseTheme,
    double? borderRadius,
    BorderSide? borderSide,
    Curve? curve,
    Border? border,
    Duration? animationDuration,
  }) {
    final a = (this as AlertThemeData);

    return AlertThemeData(
      canMerge: canMerge ?? a.canMerge,
      transitionDuration: transitionDuration ?? a.transitionDuration,
      iconPadding: iconPadding ?? a.iconPadding,
      titleTextStyle: titleTextStyle ?? a.titleTextStyle,
      mainAxisAlignment: mainAxisAlignment ?? a.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? a.crossAxisAlignment,
      baseTheme: baseTheme ?? a.baseTheme,
      borderRadius: borderRadius ?? a.borderRadius,
      borderSide: borderSide ?? a.borderSide,
      curve: curve ?? a.curve,
      border: border ?? a.border,
      animationDuration: animationDuration ?? a.animationDuration,
    );
  }

  AlertThemeData merge(AlertThemeData? other) {
    final current = (this as AlertThemeData);

    if (other == null) {
      return current;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      canMerge: other.canMerge,
      transitionDuration: other.transitionDuration,
      iconPadding: other.iconPadding,
      titleTextStyle:
          current.titleTextStyle?.merge(other.titleTextStyle) ??
          other.titleTextStyle,
      mainAxisAlignment: other.mainAxisAlignment,
      crossAxisAlignment: other.crossAxisAlignment,
      baseTheme: other.baseTheme,
      borderRadius: other.borderRadius,
      borderSide: current.borderSide != null && other.borderSide != null
          ? BorderSide.merge(current.borderSide!, other.borderSide!)
          : other.borderSide,
      curve: other.curve,
      border: current.border != null && other.border != null
          ? Border.merge(current.border!, other.border!)
          : other.border,
      animationDuration: other.animationDuration,
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

    final value = (this as AlertThemeData);

    return other is AlertThemeData &&
        other.canMerge == value.canMerge &&
        other.transitionDuration == value.transitionDuration &&
        other.iconPadding == value.iconPadding &&
        other.titleTextStyle == value.titleTextStyle &&
        other.mainAxisAlignment == value.mainAxisAlignment &&
        other.crossAxisAlignment == value.crossAxisAlignment &&
        other.baseTheme == value.baseTheme &&
        other.borderRadius == value.borderRadius &&
        other.borderSide == value.borderSide &&
        other.curve == value.curve &&
        other.border == value.border &&
        other.animationDuration == value.animationDuration;
  }

  @override
  int get hashCode {
    final value = (this as AlertThemeData);

    return Object.hash(
      runtimeType,
      value.canMerge,
      value.transitionDuration,
      value.iconPadding,
      value.titleTextStyle,
      value.mainAxisAlignment,
      value.crossAxisAlignment,
      value.baseTheme,
      value.borderRadius,
      value.borderSide,
      value.curve,
      value.border,
      value.animationDuration,
    );
  }
}

mixin _$BaseTheme {
  bool get canMerge => true;

  static BaseTheme? lerp(BaseTheme? a, BaseTheme? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return BaseTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
    );
  }

  BaseTheme copyWith({Color? backgroundColor}) {
    final a = (this as BaseTheme);

    return BaseTheme(backgroundColor: backgroundColor ?? a.backgroundColor);
  }

  BaseTheme merge(BaseTheme? other) {
    final current = (this as BaseTheme);

    if (other == null) {
      return current;
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

    final value = (this as BaseTheme);

    return other is BaseTheme && other.backgroundColor == value.backgroundColor;
  }

  @override
  int get hashCode {
    final value = (this as BaseTheme);

    return Object.hash(runtimeType, value.backgroundColor);
  }
}
