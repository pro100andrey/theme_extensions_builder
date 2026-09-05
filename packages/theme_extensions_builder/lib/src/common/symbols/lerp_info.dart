import 'package:collection/collection.dart';

import 'parameter_info.dart';

const _listEquality = ListEquality<dynamic>();

/// Base sealed class representing information about a lerp (linear
/// interpolation) method.
///
/// This is used during code generation to determine how to generate lerp
/// logic for different field types.
sealed class LerpInfo {
  const LerpInfo();
}

/// Represents a static lerp method with specific signature requirements.
///
/// Static lerp methods typically have the signature:
/// `static T? lerp(T? a, T? b, double t)`
final class StaticLerp extends LerpInfo {
  /// Creates a [StaticLerp] with the specified properties.
  const StaticLerp({required this.optionalResult, required this.args});

  /// The parameters of the lerp method.
  final List<ParameterInfo> args;

  /// Whether the return type of the lerp method is nullable.
  final bool optionalResult;

  /// Returns `true` if the lerp method accepts nullable arguments.
  ///
  /// When it doesn't, the call site has to guard against a null itself.
  bool get isNullableParameter =>
      args.length >= 2 && args[0].isNullable && args[1].isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaticLerp &&
          runtimeType == other.runtimeType &&
          optionalResult == other.optionalResult &&
          _listEquality.equals(args, other.args);

  @override
  int get hashCode =>
      Object.hash(runtimeType, optionalResult, _listEquality.hash(args));

  @override
  String toString() =>
      'StaticLerp(optionalResult: $optionalResult, args: $args)';
}

/// Represents an instance lerp method on a class.
///
/// Instance lerp methods typically have the signature:
/// `T lerp(T other, double t)`
final class InstanceLerp extends LerpInfo {
  /// Creates an [InstanceLerp] with the specified properties.
  const InstanceLerp({
    required this.optionalResult,
    required this.args,
    this.needsCast = false,
  });

  /// The parameters of the lerp method.
  final List<ParameterInfo> args;

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
          needsCast == other.needsCast &&
          _listEquality.equals(args, other.args);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    optionalResult,
    needsCast,
    _listEquality.hash(args),
  );

  @override
  String toString() =>
      'InstanceLerp(optionalResult: $optionalResult, '
      'needsCast: $needsCast, args: $args)';
}

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

  /// The generic type with nullability.
  /// For `WidgetStateProperty<Color?>` this is 'Color'.
  final String genericType;

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

  // genericIsDouble and genericIsDuration follow from genericType, so they
  // take no part in equality.
}

/// Indicates that no lerp method is available for the field type.
///
/// When this is used, the generator will fall back to a simple conditional
/// expression: `t < 0.5 ? a : b`
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
