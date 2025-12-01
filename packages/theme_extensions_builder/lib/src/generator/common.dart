/// Common code generation utilities for theme builders.
///
/// This library provides shared code generation functions used by both
/// ThemeExtensions and ThemeGen generators, including equality operators,
/// hash codes, and utility extensions.
library;

import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

import '../config/config.dart';

/// Generates the equality operator (`==`) for theme classes.
///
/// The generated method performs identity and type checks before comparing
/// all non-static fields from [config]. Returns `true` if all fields are equal,
/// `false` otherwise.
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
            declareFinal('_this').assign('this'.ref.asA(className.ref)),
          )
          ..addExpression(
            declareFinal('_other').assign('other'.ref.asA(className.ref)),
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

/// Generates the `hashCode` getter for theme classes.
///
/// Uses different strategies based on the number of fields:
/// - **0 fields**: Returns `runtimeType.hashCode`
/// - **1-19 fields**: Uses `Object.hash()` for optimal performance
/// - **20+ fields**: Uses `Object.hashAll()` for unlimited field support
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

/// Generates an if-else statement as code.
///
/// Creates a code block with the given [condition], executing [ifBlock] when
/// true and optionally [elseBlock] when false.
///
/// This is a utility function for generating conditional code when using
/// code_builder, as it doesn't provide a built-in if-else construct.
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

/// A wrapper around [Reference] that guarantees a non-null symbol.
///
/// This extension type provides convenient access to the symbol property
/// without null checks, as it's guaranteed to be non-null when constructed
/// through the provided extensions.
extension type const Ref._(Reference ref) implements Reference {
  /// Returns the non-null symbol from the underlying [Reference].
  @redeclare
  String get symbol => ref.symbol!;
}

/// Extension providing shortcut methods for creating references from strings.
extension StringRef on String {
  /// Creates a [Ref] from this string as a symbol reference.
  ///
  /// Example:
  /// ```dart
  /// 'MyClass'.ref // Ref to MyClass
  /// ```
  Ref get ref => Ref._(Reference(this));

  /// Creates a [Ref] representing a type reference.
  ///
  /// Example:
  /// ```dart
  /// 'String'.typeRef() // String
  /// 'int'.typeRef(isNullable: true) // int?
  /// ```
  Ref typeRef({bool isNullable = false}) => Ref._(
    TypeReference(
      (b) => b
        ..isNullable = isNullable
        ..symbol = this,
    ),
  );
}

/// Extension providing convenient property access for expressions.
extension ExpressionExtensions on Expression {
  /// Accesses a property on this expression.
  ///
  /// When [nullSafe] is `true`, uses null-safe property access (`?.`).
  /// Otherwise uses regular property access (`.`).
  ///
  /// Example:
  /// ```dart
  /// 'obj'.ref.prop('field') // obj.field
  /// 'obj'.ref.prop('field', nullSafe: true) // obj?.field
  /// ```
  BinaryExpression prop(String name, {bool nullSafe = false}) =>
      (nullSafe ? nullSafeProperty(name) : property(name)) as BinaryExpression;
}

/// Extension providing utility methods for building code blocks.
extension BlockBuilderExtensions on BlockBuilder {
  /// Adds an empty line to the code block for better readability.
  ///
  /// This is useful for separating logical sections of generated code.
  void addEmptyLine() => statements.add(const Code(''));
}
