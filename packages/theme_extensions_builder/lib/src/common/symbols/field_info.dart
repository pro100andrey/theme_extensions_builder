import 'lerp_info.dart';
import 'merge_info.dart';

/// Represents comprehensive information about a class field during code
/// generation.
///
/// This class stores all metadata needed to generate `copyWith`, `lerp`,
/// `merge`, `==`, and `hashCode` methods for theme extensions.
final class FieldInfo {
  /// Creates a [FieldInfo] with the specified properties.
  const FieldInfo({
    required this.name,
    required this.typeName,
    required this.isNullable,
    required this.isDouble,
    required this.isDuration,
    required this.merge,
    required this.lerp,
    required this.isStatic,
  });

  /// The name of the field.
  final String name;

  /// The type name of the field without nullability suffix.
  final String typeName;

  /// Whether the field type is nullable.
  final bool isNullable;

  /// Whether the field type is `double`.
  ///
  /// When `true`, special handling using `lerpDouble` is applied.
  final bool isDouble;

  /// Whether the field type is `Duration`.
  ///
  /// When `true`, special handling using `lerpDuration` is applied.
  final bool isDuration;

  /// Information about how to merge this field type.
  final MergeInfo merge;

  /// Information about how to interpolate (lerp) this field type.
  final LerpInfo lerp;

  /// Whether the field is static.
  ///
  /// Static fields are typically filtered out during code generation.
  final bool isStatic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          typeName == other.typeName &&
          isNullable == other.isNullable &&
          isDouble == other.isDouble &&
          isDuration == other.isDuration &&
          isStatic == other.isStatic &&
          merge == other.merge &&
          lerp == other.lerp;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    typeName,
    isNullable,
    isDouble,
    isDuration,
    isStatic,
    merge,
    lerp,
  );

  @override
  String toString() =>
      'FieldInfo(name: $name, '
      'typeName: $typeName, '
      'isNullable: $isNullable, '
      'isDouble: $isDouble, '
      'isDuration: $isDuration, '
      'isStatic: $isStatic, '
      'merge: $merge, '
      'lerp: $lerp)';
}
