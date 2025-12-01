/// Base sealed class representing information about a merge method.
///
/// This is used during code generation to determine how to merge two theme
/// instances together.
sealed class MergeInfo {
  const MergeInfo();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'MergeInfo()';
}

/// Indicates that no merge method is available for the field type.
///
/// When this is used, the generator will simply take the value from the
/// `other` parameter.
final class NoMerge extends MergeInfo {
  /// Creates a [NoMerge] instance.
  const NoMerge();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'NoMerge()';
}

/// Represents a static merge method with the signature:
/// `static T merge(T a, T b)`
final class StaticMerge extends MergeInfo {
  /// Creates a [StaticMerge] instance.
  const StaticMerge();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'StaticMerge()';
}

/// Represents an instance merge method with the signature:
/// `T merge(T other)`
final class InstanceMerge extends MergeInfo {
  /// Creates an [InstanceMerge] instance.
  const InstanceMerge();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'InstanceMerge()';
}
