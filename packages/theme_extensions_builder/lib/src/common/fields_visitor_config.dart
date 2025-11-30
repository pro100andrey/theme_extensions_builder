/// @docImport 'fields_visiter.dart';

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
  /// // For ThemeExtensions (only needs lerp)
  /// final config = FieldsVisitorConfig(
  ///   includeMerge: false,
  ///   includeMergeLookup: false,
  /// );
  ///
  /// // For ThemeGen (needs both lerp and merge)
  /// final config = FieldsVisitorConfig.full();
  ///
  /// // Minimal config (skip all lookups)
  /// final config = FieldsVisitorConfig.minimal();
  /// ```
  const FieldsVisitorConfig({
    this.includeLerpLookup = true,
    this.includeMergeLookup = true,
  });

  /// Whether to perform method lookups for lerp methods.
  ///
  /// When `false`, skips expensive method lookups in _lerpInfo.
  /// The lerp info will still be collected but without method lookup details.
  final bool includeLerpLookup;

  /// Whether to perform method lookups for merge methods.
  ///
  /// When `false`, skips expensive method lookups in _mergeInfo.
  /// Only relevant when [includeMergeLookup] is `true`.
  final bool includeMergeLookup;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldsVisitorConfig &&
          runtimeType == other.runtimeType &&
          includeLerpLookup == other.includeLerpLookup &&
          includeMergeLookup == other.includeMergeLookup;

  @override
  int get hashCode => includeLerpLookup.hashCode ^ includeMergeLookup.hashCode;

  @override
  String toString() =>
      'FieldsVisitorConfig('
      'includeLerpLookup: $includeLerpLookup, '
      'includeMergeLookup: $includeMergeLookup)';
}
