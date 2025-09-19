import 'package:meta/meta_meta.dart';

/// A constant used to mark classes for theme extensions generation.
///
/// Apply this annotation to a class to automatically generate
/// theme-related extension methods, optionally including a
/// `BuildContext` extension.
const themeExtensions = ThemeExtensions();

/// Annotation used to indicate that a class should have theme-related
/// extensions generated.
///
/// This annotation can be applied only to classes (`TargetKind.classType`).
/// You can customize whether a `BuildContext` extension should be generated
/// and optionally specify a custom name for the context accessor.
@Target({TargetKind.classType})
class ThemeExtensions {
  /// Creates a [ThemeExtensions] annotation.
  ///
  /// [buildContextExtension] specifies whether an extension on `BuildContext`
  /// should be generated. Defaults to `true`.
  ///
  /// [contextAccessorName] allows specifying a custom name for the context
  /// accessor property. If `null`, a default name will be used.
  const ThemeExtensions({
    this.buildContextExtension = true,
    this.contextAccessorName,
  });

  /// Whether to generate an extension on `BuildContext`.
  final bool buildContextExtension;

  /// Optional custom name for the context accessor property in the generated
  /// extensions.
  final String? contextAccessorName;
}
