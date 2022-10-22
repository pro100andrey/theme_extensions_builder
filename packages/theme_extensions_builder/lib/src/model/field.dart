class Field {
  const Field({
    required this.name,
    required this.typeName,
    required this.hasLerp,
  });

  final String name;
  final String typeName;
  final bool hasLerp;

  bool get isNullable => typeName.contains('?');

  Field copyWith({
    String? name,
    String? typeName,
    bool? hasLerp,
  }) {
    return Field(
      name: name ?? this.name,
      typeName: typeName ?? this.typeName,
      hasLerp: hasLerp ?? this.hasLerp,
    );
  }
}
