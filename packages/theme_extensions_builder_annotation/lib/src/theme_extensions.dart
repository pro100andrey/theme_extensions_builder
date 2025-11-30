import 'package:meta/meta_meta.dart';

/// Annotation for generating Flutter `ThemeExtension` implementations.
///
/// Apply this annotation to classes that extend `ThemeExtension<T>` to
/// automatically generate:
/// - `copyWith` method for creating modified copies
/// - `lerp` method for smooth theme transitions
/// - `==` operator and `hashCode` for equality comparison
/// - Optional `BuildContext` extension for convenient theme access
///
/// Basic usage:
/// ```dart
/// @ThemeExtensions()
/// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme {
///   const MyTheme({required this.primaryColor});
///   final Color primaryColor;
/// }
///
/// // Access theme via context extension
/// context.myTheme.primaryColor
/// ```
const themeExtensions = ThemeExtensions();

/// Annotation for generating code for Flutter theme extensions.
///
/// This annotation marks classes that extend `ThemeExtension<T>` for code
/// generation. The generator creates a mixin with necessary methods and
/// optionally a `BuildContext` extension for easy theme access.
///
/// The annotation can only be applied to classes.
///
/// Example with all options:
/// ```dart
/// @ThemeExtensions(
///   buildContextExtension: true,
///   contextAccessorName: 'customTheme',
///   constructor: '_internal',
/// )
/// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme {
///   const MyTheme._internal({
///     required this.primaryColor,
///     required this.secondaryColor,
///   });
///
///   final Color primaryColor;
///   final Color secondaryColor;
/// }
///
/// // Access via custom name
/// context.customTheme.primaryColor
/// ```
@Target({TargetKind.classType})
class ThemeExtensions {
  /// Creates a [ThemeExtensions] annotation with optional configuration.
  ///
  /// Parameters:
  /// - [buildContextExtension]: Whether to generate a `BuildContext` extension
  ///   for convenient theme access. Defaults to `true`.
  /// - [contextAccessorName]: Custom name for the context extension property.
  ///   If `null`, uses a camelCase version of the class name.
  /// - [constructor]: Name of the constructor to use in generated code.
  ///   If `null`, uses the default constructor.
  const ThemeExtensions({
    this.buildContextExtension = true,
    this.contextAccessorName,
    this.constructor,
  });

  /// Whether to generate a `BuildContext` extension.
  ///
  /// When `true`, generates an extension like:
  /// ```dart
  /// extension MyThemeExtension on BuildContext {
  ///   MyTheme get myTheme => Theme.of(this).extension<MyTheme>()!;
  /// }
  /// ```
  ///
  /// This allows convenient access: `context.myTheme` instead of
  /// `Theme.of(context).extension<MyTheme>()!`.
  final bool buildContextExtension;

  /// Custom name for the context accessor property.
  ///
  /// If `null`, the generator uses a camelCase version of the class name.
  /// For example, `MyThemeExtension` becomes `myTheme`.
  ///
  /// Example:
  /// ```dart
  /// @ThemeExtensions(contextAccessorName: 'customName')
  /// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme { ... }
  ///
  /// // Usage: context.customName instead of context.myTheme
  /// ```
  final String? contextAccessorName;

  /// The name of the constructor to use in generated `copyWith` and `lerp`.
  ///
  /// If `null`, the default constructor is used. Useful when you need a
  /// private or named constructor for your theme class.
  ///
  /// Example:
  /// ```dart
  /// @ThemeExtensions(constructor: '_internal')
  /// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme {
  ///   const MyTheme._internal({required this.color});
  ///
  ///   factory MyTheme({required Color color}) {
  ///     // Custom validation or logic
  ///     return MyTheme._internal(color: color);
  ///   }
  ///
  ///   final Color color;
  /// }
  /// ```
  final String? constructor;
}
