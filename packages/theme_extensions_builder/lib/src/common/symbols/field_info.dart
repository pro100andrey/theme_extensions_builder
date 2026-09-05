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
  ///
  /// Type arguments are part of it, so this is the name to declare a variable
  /// or write a cast with. Use [baseTypeName] to call a static member.
  final String typeName;

  /// The type name without type arguments.
  ///
  /// A static member is reached through the class, not through an
  /// instantiation of it: `Box.lerp(...)` is valid where `Box<int>.lerp(...)`
  /// is not.
  String get baseTypeName {
    final index = typeName.indexOf('<');

    return index == -1 ? typeName : typeName.substring(0, index);
  }

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
