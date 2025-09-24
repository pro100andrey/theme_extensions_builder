typedef LerpInfo = ({bool isStatic});

/// It's a class that represents a field
class FieldSymbol {
  const FieldSymbol({
    required this.name,
    required this.type,
    required this.lerpInfo,
    required this.isNullable,
    this.hasMerge = false,
  });

  final String name;
  final String type;
  final LerpInfo? lerpInfo;
  final bool hasMerge;
  final bool isNullable;

  bool get hasLerp => lerpInfo != null;
  bool get isStatic => lerpInfo?.isStatic ?? false;
  bool get isDouble => type == 'double';
  bool get isDuration => type == 'Duration';
}
