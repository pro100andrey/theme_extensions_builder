import 'package:meta/meta_meta.dart';

/// Annotation for generating theme data classes without extending
/// `ThemeExtension`.
///
/// Apply this annotation to theme data classes to automatically generate:
/// - `copyWith` method for creating modified copies
/// - `merge` method for combining theme instances
/// - `lerp` static method for smooth interpolation between themes
/// - `==` operator and `hashCode` for equality comparison
/// - `canMerge` getter indicating if the theme can be merged
///
/// Unlike `@ThemeExtensions`, this is for pure data classes that don't extend
/// Flutter's `ThemeExtension`. Useful for nested theme data or standalone
/// theme classes.
///
/// Basic usage:
/// ```dart
/// @ThemeGen()
/// class ButtonThemeData with _$ButtonThemeData {
///   const ButtonThemeData({
///     required this.backgroundColor,
///     required this.textColor,
///   });
///
///   final Color backgroundColor;
///   final Color textColor;
///
///   static ButtonThemeData? lerp(
///     ButtonThemeData? a,
///     ButtonThemeData? b,
///     double t,
///   ) => _$ButtonThemeData.lerp(a, b, t);
/// }
/// ```
const themeGen = ThemeGen();

/// Annotation for generating code for theme data classes.
///
/// This annotation marks classes for code generation that provides theme
/// functionality without requiring the class to extend Flutter's
/// `ThemeExtension`. The generator creates a mixin with methods for copying,
/// merging, and interpolating theme data.
///
/// The annotation can only be applied to classes.
///
/// Key differences from `@ThemeExtensions`:
/// - Does not require extending `ThemeExtension<T>`
/// - Generates `merge` method for combining themes
/// - No BuildContext extension generation
/// - Suitable for nested theme data structures
///
/// Example with custom constructor:
/// ```dart
/// @ThemeGen(constructor: '_internal')
/// class CardThemeData with _$CardThemeData {
///   const CardThemeData._internal({
///     required this.elevation,
///     required this.borderRadius,
///     this.padding,
///   });
///
///   factory CardThemeData({
///     double elevation = 2.0,
///     double borderRadius = 8.0,
///     EdgeInsets? padding,
///   }) {
///     return CardThemeData._internal(
///       elevation: elevation,
///       borderRadius: borderRadius,
///       padding: padding,
///     );
///   }
///
///   final double elevation;
///   final double borderRadius;
///   final EdgeInsets? padding;
///
///   static CardThemeData? lerp(
///     CardThemeData? a,
///     CardThemeData? b,
///     double t,
///   ) => _$CardThemeData.lerp(a, b, t);
/// }
/// ```
@Target({TargetKind.classType})
class ThemeGen {
  /// Creates a [ThemeGen] annotation with optional configuration.
  ///
  /// Parameters:
  /// - [constructor]: Name of the constructor to use in generated code.
  ///   If `null`, uses the default constructor.
  const ThemeGen({this.constructor});

  /// The name of the constructor to use in generated methods.
  ///
  /// If `null`, the default constructor is used. Useful when you need a
  /// private or named constructor for your theme class, typically for
  /// factory pattern implementations or validation logic.
  ///
  /// The generated `copyWith`, `merge`, and `lerp` methods will use this
  /// constructor when creating new instances.
  ///
  /// Example with validation:
  /// ```dart
  /// @ThemeGen(constructor: '_internal')
  /// class SpacingTheme with _$SpacingTheme {
  ///   const SpacingTheme._internal({
  ///     required this.small,
  ///     required this.medium,
  ///     required this.large,
  ///   }) : assert(small < medium && medium < large);
  ///
  ///   factory SpacingTheme({
  ///     required double small,
  ///     required double medium,
  ///     required double large,
  ///   }) {
  ///     if (small >= medium || medium >= large) {
  ///       throw ArgumentError('Spacing values must be in ascending order');
  ///     }
  ///     return SpacingTheme._internal(
  ///       small: small,
  ///       medium: medium,
  ///       large: large,
  ///     );
  ///   }
  ///
  ///   final double small;
  ///   final double medium;
  ///   final double large;
  /// }
  /// ```
  final String? constructor;
}
