import 'package:collection/collection.dart';

import 'arg.dart';

const _listEquality = ListEquality();

sealed class LerpMethod {
  const LerpMethod();
}

final class StaticLerpMethod extends LerpMethod {
  const StaticLerpMethod({
    required this.optionalResult,
    required this.args,
  });

  final List<Arg> args;
  final bool optionalResult;

  bool get isNullableSignature =>
      optionalResult && args[0].isNullable && args[1].isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaticLerpMethod &&
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
      'StaticLerpMethod(optionalResult: $optionalResult, args: $args)';
}

final class InstanceLerpMethod extends LerpMethod {
  const InstanceLerpMethod({
    required this.optionalResult,
    required this.args,
  });

  final List<Arg> args;
  final bool optionalResult;

  bool get isNullableSignature => optionalResult && args[0].isNullable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstanceLerpMethod &&
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
      'InstanceLerpMethod(optionalResult: $optionalResult, args: $args)';
}

final class NoLerpMethod extends LerpMethod {
  const NoLerpMethod();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoLerpMethod && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'NoLerpMethod()';
}
