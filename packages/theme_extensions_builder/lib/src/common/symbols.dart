typedef LerpInfo = ({bool isStatic});

/// It's a class that represents a field
class FieldSymbol {
  const FieldSymbol({
    required this.name,
    required this.type,
    required this.lerpInfo,
    required this.isNullable,
  });

  final String name;
  final String type;
  final LerpInfo? lerpInfo;
  final bool isNullable;

  bool get hasLerp => lerpInfo != null;
  bool get isStatic => lerpInfo?.isStatic ?? false;
  bool get isDouble => type == 'double';
}

extension FieldSymbolX on FieldSymbol {
  String get nullableType {
    if (type == 'dynamic') {
      return type;
    }

    return '$type?';
  }
}
