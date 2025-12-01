import 'package:meta/meta_meta.dart';

/// Annotation to exclude fields from code generation.
///
/// Fields marked with `@ignore` will be skipped during the generation of
/// `copyWith`, `lerp`, `merge`, `==`, and `hashCode` methods.
///
/// This is useful for:
/// - Fields that should not be included in theme extensions
/// - Internal state that shouldn't participate in equality checks
/// - Fields that are computed or derived from other fields
///
/// Example usage:
/// ```dart
/// @ThemeExtensions()
/// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme {
///   const MyTheme({
///     required this.color,
///     this.internalState = '',
///   });
///
///   final Color color;
///
///   @ignore
///   final String internalState;
/// }
/// ```
///
/// The generated code will only include `color` in the methods, while
/// `internalState` will be ignored.
const ignore = _Ignore();

/// Internal annotation class for marking fields to be ignored.
///
/// Use the [ignore] constant instead of instantiating this class directly.
@Target({TargetKind.field})
class _Ignore {
  /// Creates an [_Ignore] annotation.
  ///
  /// This constructor is private. Use the [ignore] constant instead.
  const _Ignore();
}
