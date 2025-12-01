/// Mock implementations of Flutter framework classes for testing.
///
/// This library provides minimal mock implementations of key Flutter classes
/// that are needed for testing theme extensions without pulling in the entire
/// Flutter SDK as a dependency. This keeps tests lightweight and fast.
///
/// The mocks implement the essential API surface that theme_extensions_builder
/// relies on, including:
/// - [ThemeExtension]: The base class for custom theme extensions
/// - [Color]: Color representation and interpolation
/// - [BorderSide]: Border styling with interpolation support
/// - [BuildContext] and [Theme]: Context and theme access stubs
///
/// These implementations are intentionally simplified and should only be used
/// for testing the code generation output, not for production use.
library;

import 'dart:math' as math;

import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

/// Mock implementation of Flutter's ThemeExtension class.
///
/// This is a minimal implementation that provides the core API surface
/// needed for testing theme extensions without pulling in the full Flutter SDK.
///
/// Real Flutter ThemeExtension: https://api.flutter.dev/flutter/material/ThemeExtension-class.html
abstract class ThemeExtension<T extends ThemeExtension<T>> {
  /// Enable const constructor for subclasses.
  const ThemeExtension();

  /// The extension's type.
  Object get type => T;

  /// Creates a copy of this theme extension with the given fields
  /// replaced by the non-null parameter values.
  ///
  /// This method must be overridden by subclasses.
  ThemeExtension<T> copyWith() => throw UnimplementedError();

  /// Linearly interpolate with another [ThemeExtension] object.
  ///
  /// The argument `t` represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `this` (or something
  /// equivalent to `this`), and 1.0 meaning that the interpolation has
  /// finished, returning `other` (or something equivalent to `other`).
  ///
  /// Values between 0.0 and 1.0 inclusive indicate a value between `this` and
  /// `other`. Values outside of this range are allowed but may produce
  /// unexpected results.
  ///
  /// This method must be overridden by subclasses.
  ThemeExtension<T> lerp(covariant ThemeExtension<T>? other, double t) =>
      throw UnimplementedError();
}

/// Mock implementation of Flutter's BuildContext.
///
/// BuildContext is typically provided by the widget tree in Flutter.
/// For testing purposes, this minimal interface is sufficient.
class BuildContext {
  /// Creates a BuildContext with an optional theme.
  BuildContext([Theme? theme]) : _theme = theme;

  Theme? _theme;

  /// Sets the theme for this context.
  set theme(Theme theme) {
    _theme = theme;
  }

  /// Gets the theme for this context.
  Theme? get theme => _theme;
}

/// Mock implementation of Flutter's Theme class.
///
/// This provides just enough functionality to test theme extensions
/// without requiring the full Flutter framework.
///
/// Real Flutter Theme: https://api.flutter.dev/flutter/material/Theme-class.html
class Theme {
  /// Creates a Theme with theme extensions.
  Theme({required this.extensions});

  /// Returns the [Theme] from the given [BuildContext].
  static Theme of(BuildContext context) {
    final theme = context.theme;
    if (theme == null) {
      throw StateError('No Theme found in context');
    }
    return theme;
  }

  /// The theme extensions available in this theme.
  final Map<Type, ThemeExtension> extensions;

  /// Returns the extension of type [T] from this theme,
  /// or null if no such extension exists.
  T? extension<T extends ThemeExtension<T>>() => extensions[T] as T?;
}

/// Mock implementation of Flutter's Color class.
///
/// Represents a 32-bit ARGB color value in normalized [0.0, 1.0] format.
/// This implementation provides the essential API surface needed for testing
/// color interpolation and equality without the full Flutter framework.
///
/// Real Flutter Color: https://api.flutter.dev/flutter/dart-ui/Color-class.html
class Color {
  /// Creates a color from a 32-bit ARGB value.
  ///
  /// The bits are interpreted as follows:
  /// * Bits 24-31: alpha
  /// * Bits 16-23: red
  /// * Bits 8-15: green
  /// * Bits 0-7: blue
  const Color(int value)
    : a = ((value >> 24) & 0xff) / 255,
      r = ((value >> 16) & 0xff) / 255,
      g = ((value >> 8) & 0xff) / 255,
      b = (value & 0xff) / 255;

  const Color._fromRGBOC(int r, int g, int b, double opacity)
    : a = opacity,
      r = (r & 0xff) / 255,
      g = (g & 0xff) / 255,
      b = (b & 0xff) / 255;

  /// Creates a color from alpha, red, green, and blue components.
  ///
  /// Each component should be in the range 0-255.
  const Color.fromARGB(int a, int r, int g, int b)
    : this._fromRGBOC(r, g, b, a / 255.0);

  /// Linearly interpolate between two colors.
  ///
  /// If either color is null, this function linearly interpolates from a
  /// transparent version of the other color. This matches the Flutter
  /// implementation behavior.
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), and 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`).
  static Color? lerp(Color? x, Color? y, double t) {
    if (identical(x, y)) {
      return x;
    }

    if (x == null && y == null) {
      return null;
    }

    if (x == null) {
      return Color.fromARGB(
        (y!.a * t * 255).round(),
        (y.r * t * 255).round(),
        (y.g * t * 255).round(),
        (y.b * t * 255).round(),
      );
    }

    if (y == null) {
      return Color.fromARGB(
        (x.a * (1.0 - t) * 255).round(),
        (x.r * (1.0 - t) * 255).round(),
        (x.g * (1.0 - t) * 255).round(),
        (x.b * (1.0 - t) * 255).round(),
      );
    }

    return Color.fromARGB(
      ((x.a + (y.a - x.a) * t) * 255).round(),
      ((x.r + (y.r - x.r) * t) * 255).round(),
      ((x.g + (y.g - x.g) * t) * 255).round(),
      ((x.b + (y.b - x.b) * t) * 255).round(),
    );
  }

  /// The alpha channel of this color.
  final double a;

  /// The red channel of this color.
  final double r;

  /// The green channel of this color.
  final double g;

  /// The blue channel of this color.
  final double b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Color) {
      return false;
    }
    return a == other.a && r == other.r && g == other.g && b == other.b;
  }

  @override
  int get hashCode => Object.hash(a, r, g, b);

  @override
  String toString() => 'Color(a: $a, r: $r, g: $g, b: $b)';
}

/// Mock implementation of Flutter's BorderStyle enum.
///
/// Describes the style of a border.
enum BorderStyle {
  /// No border.
  none,

  /// A solid border line.
  solid,
}

/// Mock implementation of Flutter's BorderSide class.
///
/// A side of a border of a box, used to describe borders in Flutter widgets.
/// This implementation provides the essential API for testing without Flutter.
///
/// Real Flutter BorderSide: https://api.flutter.dev/flutter/painting/BorderSide-class.html
class BorderSide {
  /// Creates a [BorderSide] with the given color, width, style, and
  /// strokeAlign.
  const BorderSide({
    this.color = const Color(0xFF000000),
    this.width = 1.0,
    this.strokeAlign = 0.0,
    this.style = BorderStyle.solid,
  });

  /// The style of this side of the border.
  final BorderStyle style;

  /// The width of this side of the border, in logical pixels.
  final double width;

  /// The color of this side of the border.
  final Color color;

  /// A property that determines the side alignment of the border.
  ///
  /// The value ranges from -1.0 (inside) to 1.0 (outside).
  final double strokeAlign;

  /// Whether the two given [BorderSide]s can be merged using [merge].
  ///
  /// Two sides can be merged if one or both are zero-width with no border,
  /// or if they both have the same color and style.
  static bool canMerge(BorderSide a, BorderSide b) {
    if ((a.style == BorderStyle.none && a.width == 0.0) ||
        (b.style == BorderStyle.none && b.width == 0.0)) {
      return true;
    }
    return a.style == b.style && a.color == b.color;
  }

  /// Creates a [BorderSide] that represents the addition of the two given
  /// [BorderSide]s.
  ///
  /// It is an error to call this if [canMerge] returns false for the two sides.
  // ignore: prefer_constructors_over_static_methods
  static BorderSide merge(BorderSide a, BorderSide b) {
    assert(canMerge(a, b), 'BorderSides cannot be merged');
    final aIsNone = a.style == BorderStyle.none && a.width == 0.0;
    final bIsNone = b.style == BorderStyle.none && b.width == 0.0;
    if (aIsNone && bIsNone) {
      return BorderSide.none;
    }
    if (aIsNone) {
      return b;
    }
    if (bIsNone) {
      return a;
    }
    assert(a.color == b.color, 'a.color and b.color must be the same to merge');
    assert(a.style == b.style, 'a.style and b.style must be the same to merge');
    return BorderSide(
      color: a.color, // == b.color
      width: a.width + b.width,
      strokeAlign: math.max(a.strokeAlign, b.strokeAlign),
      style: a.style, // == b.style
    );
  }

  /// A hairline border side with no color.
  ///
  /// This is the default value for [BorderSide].
  static const BorderSide none = BorderSide(width: 0, style: BorderStyle.none);

  /// Linearly interpolate between two border sides.
  ///
  /// The `t` argument represents position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a`, and 1.0 meaning
  /// that the interpolation has finished, returning `b`.
  ///
  /// The interpolation can be extrapolated beyond 0.0 and 1.0, so negative
  /// values and values greater than 1.0 are valid.
  // ignore: prefer_constructors_over_static_methods
  static BorderSide lerp(BorderSide a, BorderSide b, double t) {
    if (identical(a, b)) {
      return a;
    }

    if (t == 0.0) {
      return a;
    }

    if (t == 1.0) {
      return b;
    }

    final width = lerpDouble$(a.width, b.width, t)!;
    if (width < 0.0) {
      return BorderSide.none;
    }

    if (a.style == b.style && a.strokeAlign == b.strokeAlign) {
      return BorderSide(
        color: Color.lerp(a.color, b.color, t)!,
        width: width,
        style: a.style,
        strokeAlign: a.strokeAlign,
      );
    }

    return BorderSide(
      color: Color.lerp(a.color, b.color, t)!,
      width: width,
      strokeAlign: a.strokeAlign,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! BorderSide) {
      return false;
    }
    return style == other.style &&
        width == other.width &&
        color == other.color &&
        strokeAlign == other.strokeAlign;
  }

  @override
  int get hashCode => Object.hash(style, width, color, strokeAlign);

  @override
  String toString() =>
      'BorderSide(style: $style, width: $width, color: $color, '
      'strokeAlign: $strokeAlign)';
}
