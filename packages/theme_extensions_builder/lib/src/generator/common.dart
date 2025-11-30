// Generates the equality operator `==` for the theme extension.
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

import '../config/config.dart';

/// Generates the equality operator `==` for the theme extension.
///
/// [config] The configuration containing the fields to be compared.
///
/// Returns a [Method] representing the equality operator.
Method equalOperator(BaseConfig config) => Method((m) {
  final fields = config.filteredFields;
  final className = config.className;
  m
    ..name = 'operator =='
    ..annotations.add('override'.ref)
    ..returns = 'bool'.ref
    ..requiredParameters.add(
      Parameter(
        (p) => p
          ..name = 'other'
          ..type = 'Object'.ref,
      ),
    )
    ..body = Block((b) {
      b
        ..statements.add(
          ifCode(
            'identical'.ref(['this'.ref, 'other'.ref]),
            thenBody: [literalTrue.returned],
          ),
        )
        ..addEmptyLine()
        ..statements.add(
          ifCode(
            'other'.ref.prop('runtimeType').notEqualTo('runtimeType'.ref),
            thenBody: [literalFalse.returned],
          ),
        )
        ..addEmptyLine();

      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal(
              '_this',
            ).assign('this'.ref.asA(className.ref)),
          )
          ..addExpression(
            declareFinal(
              '_other',
            ).assign('other'.ref.asA(className.ref)),
          )
          ..addEmptyLine()
          ..addExpression(
            fields
                .map(
                  (field) => '_other'.ref
                      .prop(field.name)
                      .equalTo('_this'.ref.prop(field.name)),
                )
                .reduce((a, b) => a.and(b))
                .returned,
          );
      } else {
        b.addExpression(literalTrue.returned);
      }
    });
});

/// Generates the `hashCode` getter with appropriate handling based on the
/// number of fields in the configuration.
///
/// [config] The configuration containing the fields to be included in the
/// hash code computation.
///
/// Returns a [Method] representing the `hashCode` getter.
Method hashMethod(BaseConfig config) => Method((m) {
  final fields = config.filteredFields;
  final className = config.className;
  m
    ..name = 'hashCode'
    ..annotations.add('override'.ref)
    ..returns = 'int'.ref
    ..type = MethodType.getter
    ..body = Block((b) {
      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal('_this').assign('this'.ref.asA(className.ref)),
          )
          ..addEmptyLine();
      }

      switch (fields.length) {
        case 0:
          b.addExpression('runtimeType'.ref.prop('hashCode').returned);
        case <= 19:
          b.addExpression(
            'Object'.ref
                .prop('hash')([
                  'runtimeType'.ref,
                  for (final field in fields) '_this'.ref.prop(field.name),
                ])
                .returned,
          );
        case _:
          b.addExpression(
            'Object'.ref
                .prop('hashAll')([
                  literalList([
                    'runtimeType'.ref,
                    for (final field in fields) '_this'.ref.prop(field.name),
                  ]),
                ])
                .returned,
          );
      }
    });
});

/// Generates an if-else code block.
/// [condition] The condition for the if statement.
/// [thenBody] The list of code statements to execute if the condition is true.
/// [elseBody] (Optional) The list of code statements to execute if the
/// condition is false.
Code ifCode(
  Expression condition, {
  required List<Expression> thenBody,
  List<Expression>? elseBody,
}) {
  final buf = StringBuffer();
  final conditionStr = condition.accept(DartEmitter());

  buf.writeln('if ($conditionStr) {');

  for (final c in thenBody) {
    buf.writeln('  ${c.statement.accept(DartEmitter())}');
  }

  buf.write('}');

  if (elseBody != null && elseBody.isNotEmpty) {
    buf.writeln(' else {');
    for (final c in elseBody) {
      buf.writeln('  ${c.statement.accept(DartEmitter())}');
    }
    buf.write('}');
  }

  return Code(buf.toString());
}

/// A wrapper around [Reference] to provide additional utility methods.
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

extension ExpressionExtensions on Expression {
  BinaryExpression prop(String name) => property(name) as BinaryExpression;
}

extension BlockBuilderExtensions on BlockBuilder {
  /// Adds an empty line to the block.
  void addEmptyLine() => statements.add(const Code(''));
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
