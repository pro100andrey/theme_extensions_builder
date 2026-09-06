/// How a field type is interpolated.
///
/// Decided once per field while the class is analysed, then switched over by
/// the code builders.
sealed class LerpInfo {
  const LerpInfo();
}

/// A static `lerp` on the field type: `static T? lerp(T? a, T? b, double t)`.
final class StaticLerp extends LerpInfo {
  /// Creates a [StaticLerp] with the specified properties.
  const StaticLerp({
    required this.optionalResult,
    required this.isNullableParameter,
  });

  /// Whether the return type of the lerp method is nullable.
  final bool optionalResult;

  /// Whether the method accepts a null on both sides.
  ///
  /// When it doesn't, the call site has to guard against a null itself.
  final bool isNullableParameter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaticLerp &&
          runtimeType == other.runtimeType &&
          optionalResult == other.optionalResult &&
          isNullableParameter == other.isNullableParameter;

  @override
  int get hashCode =>
      Object.hash(runtimeType, optionalResult, isNullableParameter);

  @override
  String toString() =>
      'StaticLerp(optionalResult: $optionalResult, '
      'isNullableParameter: $isNullableParameter)';
}

/// An instance `lerp` on the field type: `T lerp(T other, double t)`.
///
/// The generated code never passes a null to it: a nullable field is guarded
/// at the call site whatever the parameter type is, so that `t == 0` keeps
/// `a` and `t == 1` keeps `b` when the other side is null.
final class InstanceLerp extends LerpInfo {
  /// Creates an [InstanceLerp] with the specified properties.
  const InstanceLerp({required this.optionalResult, this.needsCast = false});

  /// Whether the return type of the lerp method is nullable.
  final bool optionalResult;

  /// Whether the result has to be cast back to the field type.
  ///
  /// A method declared on a supertype returns that supertype: the generated
  /// `lerp` of a theme extension returns `ThemeExtension<T>`, not `T`. A
  /// method that already returns the field type needs no cast, and adding one
  /// would trip `unnecessary_cast` in the generated file.
  final bool needsCast;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstanceLerp &&
          runtimeType == other.runtimeType &&
          optionalResult == other.optionalResult &&
          needsCast == other.needsCast;

  @override
  int get hashCode => Object.hash(runtimeType, optionalResult, needsCast);

  @override
  String toString() =>
      'InstanceLerp(optionalResult: $optionalResult, needsCast: $needsCast)';
}

/// A `WidgetStateProperty` shaped field, interpolated through the four
/// parameter `WidgetStateProperty.lerp` with a lerp function for the generic.
final class WidgetStatePropertyLerp extends LerpInfo {
  /// Creates a [WidgetStatePropertyLerp] with the specified properties.
  const WidgetStatePropertyLerp({
    required this.baseTypeName,
    required this.genericType,
    required this.isNullableGeneric,
    required this.genericIsDouble,
    required this.genericIsDuration,
  });

  /// The base type name without generics.
  /// For `WidgetStateProperty<Color?>` this is 'WidgetStateProperty'.
  final String baseTypeName;

  /// The generic type without its nullability suffix.
  /// For `WidgetStateProperty<Color?>` this is 'Color'.
  final String genericType;

  /// Whether the generic type is nullable.
  final bool isNullableGeneric;

  /// Whether the generic is `double` from `dart:core`.
  final bool genericIsDouble;

  /// Whether the generic is `Duration` from `dart:core`.
  final bool genericIsDuration;

  /// The generic without its own type arguments.
  ///
  /// The inner lerp is reached through the class, so a generic generic —
  /// `WidgetStateProperty<Box<int>?>` — has to call `Box.lerp`, not
  /// `Box<int>.lerp`.
  String get genericBaseTypeName {
    final index = genericType.indexOf('<');

    return index == -1 ? genericType : genericType.substring(0, index);
  }

  // genericIsDouble and genericIsDuration follow from genericType, so they
  // take no part in equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStatePropertyLerp &&
          runtimeType == other.runtimeType &&
          baseTypeName == other.baseTypeName &&
          genericType == other.genericType &&
          isNullableGeneric == other.isNullableGeneric;

  @override
  int get hashCode =>
      Object.hash(runtimeType, baseTypeName, genericType, isNullableGeneric);

  @override
  String toString() =>
      'WidgetStatePropertyLerp('
      'baseTypeName: $baseTypeName, '
      'genericType: $genericType, '
      'isNullableGeneric: $isNullableGeneric)';
}

/// No usable lerp method on the field type.
///
/// `double` and `Duration` fields are still interpolated, through
/// `lerpDouble$` and `lerpDuration$`. Anything else switches over at
/// `t < 0.5 ? a : b`.
final class NoLerp extends LerpInfo {
  /// Creates a [NoLerp] instance.
  const NoLerp();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoLerp && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'NoLerp()';
}
