/// @docImport 'fields_visitor.dart';

library;

/// Configuration for [FieldsVisitor] behavior.
///
/// This class controls what information should be collected during field
/// visiting. Disabling unnecessary lookups can significantly improve
/// performance for generators that don't use certain features.
class FieldsVisitorConfig {
  /// Creates a [FieldsVisitorConfig] with the specified settings.
  ///
  /// Example usage:
  /// ```dart
  /// // For ThemeGen, which generates a merge method
  /// const config = FieldsVisitorConfig();
  ///
  /// // For ThemeExtensions, which does not
  /// const config = FieldsVisitorConfig(includeMergeLookup: false);
  /// ```
  const FieldsVisitorConfig({this.includeMergeLookup = true});

  /// Whether to look up merge methods on field types.
  ///
  /// When `false`, the lookup is skipped and every field is reported as
  /// `NoMerge`. Use it for generators that don't emit a `merge` method.
  final bool includeMergeLookup;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldsVisitorConfig &&
          runtimeType == other.runtimeType &&
          includeMergeLookup == other.includeMergeLookup;

  @override
  int get hashCode => Object.hash(runtimeType, includeMergeLookup);

  @override
  String toString() =>
      'FieldsVisitorConfig(includeMergeLookup: $includeMergeLookup)';
}
