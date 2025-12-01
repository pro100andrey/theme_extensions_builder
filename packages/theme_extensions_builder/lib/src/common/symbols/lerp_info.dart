import 'package:collection/collection.dart';

import 'parameter_info.dart';

const _listEquality = ListEquality();

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
  const StaticLerp({
    required this.optionalResult,
    required this.args,
  });

  /// The parameters of the lerp method.
  final List<ParameterInfo> args;

  /// Whether the return type of the lerp method is nullable.
  final bool optionalResult;

  /// Returns `true` if the lerp method signature accepts nullable parameters
  /// and returns a nullable result.
  ///
  /// This is determined by checking if the result is optional and the first
  /// two arguments are nullable.
  bool get isNullableSignature =>
      optionalResult &&
      args.length >= 2 &&
      args[0].isNullable &&
      args[1].isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaticLerp &&
          runtimeType == other.runtimeType &&
          optionalResult == other.optionalResult &&
          _listEquality.equals(args, other.args);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    optionalResult,
  );

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
  });

  /// The parameters of the lerp method.
  final List<ParameterInfo> args;

  /// Whether the return type of the lerp method is nullable.
  final bool optionalResult;

  /// Returns `true` if the lerp method signature accepts a nullable parameter
  /// and returns a nullable result.
  bool get isNullableSignature =>
      optionalResult && args.isNotEmpty && args[0].isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstanceLerp &&
          runtimeType == other.runtimeType &&
          optionalResult == other.optionalResult &&
          _listEquality.equals(args, other.args);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    optionalResult,
    args,
  );

  @override
  String toString() =>
      'InstanceLerp(optionalResult: $optionalResult, args: $args)';
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
