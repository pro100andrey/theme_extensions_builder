import 'arg.dart';

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
  String toString() =>
      'InstanceLerpMethod(optionalResult: $optionalResult, args: $args)';
}

final class NoLerpMethod extends LerpMethod {
  const NoLerpMethod();

  @override
  String toString() => 'NoLerpMethod()';
}
