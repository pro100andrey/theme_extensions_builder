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
  String toString() => 'Arg(name: $name, type: $type, isNullable: $isNullable)';
}
