class Field {
  const Field({
    required this.name,
    required this.typeName,
  });

  final String name;
  final String typeName;

  bool get isNullable => typeName.contains('?');

  Field copyWith({
    String? name,
    String? typeName,
  }) {
    return Field(
      name: name ?? this.name,
      typeName: typeName ?? this.typeName,
    );
  }
}
