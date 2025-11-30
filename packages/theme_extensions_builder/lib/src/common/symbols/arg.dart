final class Arg {
  const Arg({
    required this.name,
    required this.type,
    required this.isNullable,
  });

  final String name;
  final String type;
  final bool isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Arg &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          isNullable == other.isNullable;

  @override
  int get hashCode => Object.hash(runtimeType, name, type, isNullable);

  @override
  String toString() => 'Arg(name: $name, type: $type, isNullable: $isNullable)';
}
