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

// ignore: avoid_classes_with_only_static_members
abstract class Color {
  static Color? lerp(Color? x, Color? y, double t) => null;
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
