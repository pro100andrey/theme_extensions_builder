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
          ifStatement(
            'identical'.ref(['this'.ref, 'other'.ref]),
            Block((b) => b.addExpression(literalTrue.returned)),
          ),
        )
        ..addEmptyLine()
        ..statements.add(
          ifStatement(
            'other'.ref.prop('runtimeType').notEqualTo('runtimeType'.ref),
            Block((b) => b.addExpression(literalFalse.returned)),
          ),
        )
        ..addEmptyLine();

      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal('_this').assign(
              'this'.ref.asA(className.ref),
            ),
          )
          ..addExpression(
            declareFinal('_other').assign(
              'other'.ref.asA(className.ref),
            ),
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
/// [ifBlock] The code to execute if the condition is true.
/// [elseBlock] (Optional) The code to execute if the condition is false.

Code ifStatement(Expression condition, Block ifBlock, [Block? elseBlock]) {
  final visiter = DartEmitter();
  final conditionV = condition.accept(visiter);
  final ifBlockV = ifBlock.accept(visiter);
  final elseBlockV = elseBlock?.accept(visiter);

  final ifElse =
      'if($conditionV){$ifBlockV}'
      '${elseBlockV != null ? 'else {$elseBlockV}' : ''}';

  return Code(ifElse);
}

/// A wrapper around [Reference] to provide additional utility methods.
extension type const Ref._(Reference ref) implements Reference {
  @redeclare
  String get symbol => ref.symbol!;
}

extension StringRef on String {
  ///Shortcut to get a [Ref] from a [String].
  Ref get ref => Ref._(Reference(this));

  Ref typeRef({bool isNullable = false}) => Ref._(
    TypeReference(
      (b) => b
        ..isNullable = isNullable
        ..symbol = this,
    ),
  );
}

extension ExpressionExtensions on Expression {
  BinaryExpression prop(
    String name, {
    bool nullSafe = false,
  }) =>
      (nullSafe ? nullSafeProperty(name) : property(name)) as BinaryExpression;
}

extension BlockBuilderExtensions on BlockBuilder {
  /// Adds an empty line to the block.
  void addEmptyLine() => statements.add(const Code(''));
}
