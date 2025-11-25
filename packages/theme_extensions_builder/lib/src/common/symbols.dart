/// A class that represents information about lerp method.
final class LerpInfo {
  const LerpInfo({
    required this.isStatic,
    required this.type,
  });

  /// Whether the lerp method is static.
  final bool isStatic;

  /// The display type of the class that contains the lerp method.
  final String type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LerpInfo &&
        other.isStatic == isStatic &&
        other.type == type;
  }

  @override
  int get hashCode => isStatic.hashCode ^ type.hashCode;
}

/// A class that represents information about merge method.
final class MergeInfo {
  const MergeInfo({
    required this.isStatic,
  });

  /// Whether the merge method is static.
  final bool isStatic;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MergeInfo && other.isStatic == isStatic;
  }

  @override
  int get hashCode => isStatic.hashCode;
}

/// A class that represents information about a field.
final class FieldSymbol {
  const FieldSymbol({
    required this.name,
    required this.type,
    required this.lerpInfo,
    required this.isNullable,
    required this.mergeInfo,
  });

  final String name;
  final String type;
  final LerpInfo? lerpInfo;
  final MergeInfo? mergeInfo;
  final bool isNullable;

  bool get hasLerp => lerpInfo != null;
  bool get hasMerge => mergeInfo != null;

  bool get isDouble => type == 'double';
  bool get isDuration => type == 'Duration';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FieldSymbol &&
        other.name == name &&
        other.type == type &&
        other.lerpInfo == lerpInfo &&
        other.isNullable == isNullable &&
        other.mergeInfo == mergeInfo;
  }

  @override
  int get hashCode => Object.hash(
    name,
    type,
    lerpInfo,
    isNullable,
    mergeInfo,
  );
}
