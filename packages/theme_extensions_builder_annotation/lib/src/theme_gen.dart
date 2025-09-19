import 'package:meta/meta_meta.dart';

/// A constant used to mark classes for theme generation.
///
/// Apply this annotation to a class to indicate that
/// theme-related extensions, helpers, or generated code
/// should be created for it.
const themeGen = ThemeGen();

/// Annotation used to indicate that a class should have
/// theme-related code generated.
///
/// This annotation can only be applied to classes
/// (`TargetKind.classType`).
///
/// Place it on any class to signal a code generator
/// to process it for theme-related extensions or helpers.
@Target({TargetKind.classType})
class ThemeGen {
  /// Creates a [ThemeGen] annotation.
  const ThemeGen();
}
