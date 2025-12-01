/// Represents information about a method parameter during code generation.
///
/// This class stores metadata about parameters in lerp and merge methods,
/// including the parameter name, type, and nullability.
final class ParameterInfo {
  /// Creates a [ParameterInfo] with the specified properties.
  const ParameterInfo({
    required this.name,
    required this.type,
    required this.isNullable,
  });

  /// The name of the parameter.
  final String name;

  /// The type of the parameter as a string.
  final String type;

  /// Whether the parameter type is nullable.
  final bool isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParameterInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          isNullable == other.isNullable;

  @override
  int get hashCode => Object.hash(runtimeType, name, type, isNullable);

  @override
  String toString() =>
      'ParameterInfo(name: $name, type: $type, isNullable: $isNullable)';
}
