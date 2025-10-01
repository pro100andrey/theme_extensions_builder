typedef LerpInfo = ({bool isStatic, bool nullableArgs});
typedef MergeInfo = ({bool isStatic});

/// It's a class that represents a field
class FieldSymbol {
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
}
