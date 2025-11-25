import 'dart:math' as math;

/// A placeholder for Flutter's ThemeExtension class
abstract class ThemeExtension<T extends ThemeExtension<T>> {
  /// Enable const constructor for subclasses.
  const ThemeExtension();

  /// The extension's type.
  Object get type => T;

  /// Creates a copy of this theme extension with the given fields
  /// replaced by the non-null parameter values.
  ThemeExtension<T> copyWith() => throw UnimplementedError();

  /// Linearly interpolate with another [ThemeExtension] object.
  ///
  /// {@macro dart.ui.shadow.lerp}
  ThemeExtension<T> lerp(covariant ThemeExtension<T>? other, double t) =>
      throw UnimplementedError();
}

/// A placeholder for Flutter's BuildContext
abstract class BuildContext {}

// A placeholder for Flutter's Theme class
abstract class Theme {
  const Theme(this.context);

  factory Theme.of(BuildContext context) {
    final _ = context;
    throw UnimplementedError();
  }

  final BuildContext context;

  T? extension<T extends ThemeExtension<T>>() => null;
}

class Color {
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

  const Color.fromARGB(int a, int r, int g, int b)
    : this._fromRGBOC(r, g, b, a / 255.0);

  static Color? lerp(Color? x, Color? y, double t) => null;

  /// The alpha channel of this color.
  final double a;

  /// The red channel of this color.
  final double r;

  /// The green channel of this color.
  final double g;

  /// The blue channel of this color.
  final double b;
}

enum BorderStyle {
  none,
  solid,
}

class BorderSide {
  const BorderSide({
    this.color = const Color(0xFF000000),
    this.width = 1.0,
    this.strokeAlign = 0.0,
    this.style = BorderStyle.solid,
  });

  final BorderStyle style;
  final double width;
  final Color color;
  final double strokeAlign;

  static bool canMerge(BorderSide a, BorderSide b) {
    if ((a.style == BorderStyle.none && a.width == 0.0) ||
        (b.style == BorderStyle.none && b.width == 0.0)) {
      return true;
    }
    return a.style == b.style && a.color == b.color;
  }

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

  static const BorderSide none = BorderSide(
    width: 0,
    style: BorderStyle.none,
  );
}
