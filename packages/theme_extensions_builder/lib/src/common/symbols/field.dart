import 'lerp_method.dart';
import 'merge_method.dart';

final class FieldSymbol {
  const FieldSymbol({
    required this.name,
    required this.baseType,
    required this.optional,
    required this.isDouble,
    required this.isDuration,
    required this.merge,
    required this.lerp,
    required this.isStatic,
  });

  /// The name of the field.
  final String name;

  /// The base type name of the field without nullability suffix.
  final String baseType;

  /// True if the field type is nullable.
  final bool optional;

  /// True if the field type is double.
  final bool isDouble;

  /// True if the field type is Duration.
  final bool isDuration;

  /// Information about the merge method for the field type.
  final MergeMethod merge;

  /// Information about the lerp method for the field type.
  final LerpMethod lerp;

  /// True if the field is static.
  final bool isStatic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldSymbol &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          baseType == other.baseType &&
          optional == other.optional &&
          isDouble == other.isDouble &&
          isDuration == other.isDuration &&
          isStatic == other.isStatic &&
          merge == other.merge &&
          lerp == other.lerp;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    baseType,
    optional,
    isDouble,
    isDuration,
    isStatic,
    merge,
    lerp,
  );

  @override
  String toString() =>
      'FieldSymbol(name: $name, '
      'baseType: $baseType, '
      'optional: $optional, '
      'isDouble: $isDouble, '
      'isDuration: $isDuration, '
      'isStatic: $isStatic, '
      'merge: $merge, '
      'lerp: $lerp)';
}
