import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

extension type const Ref._(Reference ref) implements Reference {
  @redeclare
  String get symbol => ref.symbol!;
}

extension StringRef on String {
  ///Shortcut to get a [Ref] from a [String].
  Ref get ref => Ref._(Reference(this));

  Ref typeRef({bool optional = false}) => Ref._(
    TypeReference(
      (b) => b
        ..isNullable = optional
        ..symbol = this,
    ),
  );
}

Code ifCode(
  Code condition,
  List<Code> thenBody, [
  List<Code>? elseBody,
]) {
  final buf = StringBuffer();
  final conditionStr = condition.accept(DartEmitter());

  buf.writeln('if ($conditionStr) {');

  for (final c in thenBody) {
    buf.writeln('  ${c.accept(DartEmitter())}');
  }

  buf.write('}');

  if (elseBody != null && elseBody.isNotEmpty) {
    buf.writeln(' else {');
    for (final c in elseBody) {
      buf.writeln('  ${c.accept(DartEmitter())}');
    }
    buf.write('}');
  }

  return Code(buf.toString());
}

extension ExpressionExtensions on Expression {
  BinaryExpression prop(String name) => property(name) as BinaryExpression;
}

extension BinaryExpressionExtensions on BinaryExpression {
  // ignore: avoid_positional_boolean_parameters
  BinaryExpression withNullSafety([bool enable = true]) {
    if (!enable) {
      return this;
    }

    final lSymbol = (left as Reference).symbol!;
    final rSymbol = (right as LiteralExpression).literal;

    return CodeExpression(Code(lSymbol)).nullSafeProperty(rSymbol)
        as BinaryExpression;
  }

  BinaryExpression get nullSafe => withNullSafety();
}
