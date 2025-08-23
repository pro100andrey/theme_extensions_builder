typedef LerpInfo = ({bool isStatic});

/// It's a class that represents a field
class FieldSymbol {
  const FieldSymbol({
    required this.name,
    required this.type,
    required this.lerpInfo,
  });

  final String name;
  final String type;
  final LerpInfo? lerpInfo;

  bool get isNullable => type.contains('?');
  bool get hasLerp => lerpInfo != null;

}
