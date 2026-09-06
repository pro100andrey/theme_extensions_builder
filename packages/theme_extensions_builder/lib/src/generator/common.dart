/// Code generation shared by the `@ThemeExtensions` and `@ThemeGen`
/// generators: `copyWith`, the per-field `lerp` expression, `==`, `hashCode`,
/// and the small helpers around `code_builder`.
library;

import 'package:code_builder/code_builder.dart';

import '../common/symbols/field_info.dart';
import '../common/symbols/lerp_info.dart';
import '../config/config.dart';

/// The local the generated methods read the current instance through.
///
/// The methods live in a mixin, so `this` is the mixin type; the local holds
/// it cast to the class, which is what the fields are declared on.
const thisAlias = '_this';

/// A reference to [thisAlias].
Reference get thisRef => thisAlias.ref;

/// The `t` parameter of a `lerp`.
Reference get tRef => 't'.ref;

/// Emits the `DartEmitter` configuration every generator uses.
///
/// The output is a part file, so nothing is ever imported and no allocator is
/// needed; only the null safety syntax matters.
DartEmitter partEmitter() => DartEmitter(useNullSafetySyntax: true);

/// `final _this = (this as ClassName);`
Expression declareThis(BaseConfig config) =>
    declareFinal(thisAlias).assign('this'.ref.asA(config.className.ref));

/// Builds a new instance of the configured class with [args].
///
/// The call is `const` when the constructor allows it and there is nothing
/// to pass, which is the only case where the arguments are constant too.
Expression construct(BaseConfig config, Map<String, Expression> args) =>
    (args.isEmpty && config.constConstructor
    ? InvokeExpression.constOf
    : InvokeExpression.newOf)(
      config.className.ref,
      [],
      args,
      [],
      config.constructor,
    );

/// Generates `copyWith`: every field as an optional named parameter that
/// falls back to the current value.
Method copyWithMethod(
  BaseConfig config, {
  required Reference returns,
  bool isOverride = false,
}) => Method((m) {
  final fields = config.fields;

  m
    ..name = 'copyWith'
    ..returns = returns
    ..optionalParameters.addAll(
      fields.map(
        (field) => Parameter(
          (p) => p
            ..name = field.name
            ..named = true
            ..type = field.typeName.typeRef(isNullable: true),
        ),
      ),
    )
    ..body = Block((b) {
      if (fields.isNotEmpty) {
        b
          ..addExpression(declareThis(config))
          ..addEmptyLine();
      }

      b.addExpression(
        construct(config, {
          for (final field in fields)
            field.name: field.name.ref.ifNullThen(thisRef.property(field.name)),
        }).returned,
      );
    });

  if (isOverride) {
    m.annotations.add(overrideAnnotation);
  }
});

/// The `@override` annotation.
Reference get overrideAnnotation => 'override'.ref;

/// The expression that interpolates [field] between [a] and [b] at `t`.
///
/// [a] and [b] are the two values of the field, `a.field` and `b.field` or
/// `_this.field` and `other.field`, depending on the generator.
Expression lerpFieldExpression(FieldInfo field, Expression a, Expression b) {
  final staticLerp = field.baseTypeName.ref.property('lerp');
  final fieldType = field.typeName.typeRef(isNullable: field.isNullable);

  // An interpolation that returns a nullable result still has to produce a
  // value for a non-nullable field.
  Expression nullCheckedUnlessNullable(Expression expression) =>
      field.isNullable ? expression : expression.nullChecked;

  return switch (field.lerp) {
    // Non-nullable field, static lerp returning an optional result:
    // Class.lerp(a.field, b.field, t)!
    StaticLerp(optionalResult: true) when !field.isNullable => staticLerp([
      a,
      b,
      tRef,
    ]).nullChecked,

    // Non-nullable field, static lerp returning a non-optional result:
    // Class.lerp(a.field, b.field, t)
    StaticLerp() when !field.isNullable => staticLerp([a, b, tRef]),

    // Nullable field, static lerp taking nullable arguments:
    // Class.lerp(a.field, b.field, t)
    StaticLerp(isNullableParameter: true) => staticLerp([a, b, tRef]),

    // Nullable field, static lerp taking non-nullable arguments:
    // a.field == null || b.field == null
    //     ? (t < 0.5 ? a.field : b.field)
    //     : Class.lerp(a.field!, b.field!, t)
    StaticLerp() => _nullGuarded(
      a,
      b,
      staticLerp([a.nullChecked, b.nullChecked, tRef]),
    ),

    // Nullable field, instance lerp declared on a supertype:
    // a.field == null || b.field == null
    //     ? (t < 0.5 ? a.field : b.field)
    //     : (a.field!.lerp(b.field!, t) as Class?)
    InstanceLerp(needsCast: true) when field.isNullable => _nullGuarded(
      a,
      b,
      a.nullChecked.property('lerp')([b.nullChecked, tRef]).asA(fieldType),
    ),

    // Nullable field, instance lerp:
    // a.field == null || b.field == null
    //     ? (t < 0.5 ? a.field : b.field)
    //     : a.field!.lerp(b.field!, t)
    InstanceLerp() when field.isNullable => _nullGuarded(
      a,
      b,
      a.nullChecked.property('lerp')([b.nullChecked, tRef]),
    ),

    // Non-nullable field, instance lerp declared on a supertype:
    // (a.field.lerp(b.field, t) as Class)
    InstanceLerp(needsCast: true) =>
      a.property('lerp')([b, tRef]).asA(fieldType),

    // Non-nullable field, instance lerp returning an optional result:
    // a.field.lerp(b.field, t)!
    InstanceLerp(optionalResult: true) =>
      a.property('lerp')([b, tRef]).nullChecked,

    // Non-nullable field, instance lerp:
    // a.field.lerp(b.field, t)
    InstanceLerp() => a.property('lerp')([b, tRef]),

    // WidgetStateProperty.lerp<Color?>(a.field, b.field, t, Color.lerp)
    WidgetStatePropertyLerp(
      :final baseTypeName,
      :final genericType,
      :final genericBaseTypeName,
      :final genericIsDouble,
      :final genericIsDuration,
    ) =>
      nullCheckedUnlessNullable(
        baseTypeName.ref.property('lerp')(
          [
            a,
            b,
            tRef,
            if (genericIsDouble)
              r'lerpDouble$'.ref
            else if (genericIsDuration)
              r'lerpDuration$'.ref
            else
              genericBaseTypeName.ref.property('lerp'),
          ],
          {},
          [genericType.typeRef(isNullable: true)],
        ),
      ),

    // lerpDouble$(a.field, b.field, t)
    NoLerp() when field.isDouble => nullCheckedUnlessNullable(
      r'lerpDouble$'.ref([a, b, tRef]),
    ),

    // lerpDuration$(a.field, b.field, t)
    NoLerp() when field.isDuration => nullCheckedUnlessNullable(
      r'lerpDuration$'.ref([a, b, tRef]),
    ),

    // t < 0.5 ? a.field : b.field
    NoLerp() => _switchOver(a, b),
  };
}

/// `t < 0.5 ? a : b`
Expression _switchOver(Expression a, Expression b) =>
    tRef.lessThan(literalNum(0.5)).conditional(a, b);

/// Wraps [lerpCall] so that it only runs when both sides are present.
///
/// An interpolation that cannot accept a null falls back to the value the
/// timeline is closest to, which keeps `t == 0` on [a] and `t == 1` on [b].
Expression _nullGuarded(Expression a, Expression b, Expression lerpCall) => a
    .equalTo(literalNull)
    .or(b.equalTo(literalNull))
    .conditional(_switchOver(a, b), lerpCall);

/// Generates the equality operator (`==`) for theme classes.
///
/// The generated method performs identity and type checks before comparing
/// all fields from [config]. Returns `true` if all fields are equal, `false`
/// otherwise.
Method equalOperator(BaseConfig config) => Method((m) {
  final fields = config.fields;
  final className = config.className;
  m
    ..name = 'operator =='
    ..annotations.add(overrideAnnotation)
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
            'other'.ref.property('runtimeType').notEqualTo('runtimeType'.ref),
            Block((b) => b.addExpression(literalFalse.returned)),
          ),
        )
        ..addEmptyLine();

      if (fields.isNotEmpty) {
        b
          ..addExpression(declareThis(config))
          ..addExpression(
            declareFinal('_other').assign('other'.ref.asA(className.ref)),
          )
          ..addEmptyLine()
          ..addExpression(
            fields
                .map(
                  (field) => '_other'.ref
                      .property(field.name)
                      .equalTo(thisRef.property(field.name)),
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
  final fields = config.fields;
  m
    ..name = 'hashCode'
    ..annotations.add(overrideAnnotation)
    ..returns = 'int'.ref
    ..type = MethodType.getter
    ..body = Block((b) {
      if (fields.isNotEmpty) {
        b
          ..addExpression(declareThis(config))
          ..addEmptyLine();
      }

      final values = [
        'runtimeType'.ref,
        for (final field in fields) thisRef.property(field.name),
      ];

      switch (fields.length) {
        case 0:
          b.addExpression('runtimeType'.ref.property('hashCode').returned);
        case <= 19:
          b.addExpression('Object'.ref.property('hash')(values).returned);
        case _:
          b.addExpression(
            'Object'.ref.property('hashAll')([literalList(values)]).returned,
          );
      }
    });
});

/// Generates an if statement as code.
///
/// Creates a code block with the given [condition], executing [ifBlock] when
/// true.
///
/// This is a utility function for generating conditional code when using
/// code_builder, as it doesn't provide a built-in if construct.
Code ifStatement(Expression condition, Block ifBlock) {
  final visitor = partEmitter();
  final conditionV = condition.accept(visitor);
  final ifBlockV = ifBlock.accept(visitor);

  return Code('if($conditionV){$ifBlockV}');
}

/// Extension providing shortcut methods for creating references from strings.
extension StringRef on String {
  /// Creates a [Reference] from this string as a symbol reference.
  ///
  /// Example:
  /// ```dart
  /// 'MyClass'.ref // Ref to MyClass
  /// ```
  Reference get ref => Reference(this);

  /// Creates a [TypeReference] from this string.
  ///
  /// Example:
  /// ```dart
  /// 'String'.typeRef() // String
  /// 'int'.typeRef(isNullable: true) // int?
  /// ```
  TypeReference typeRef({bool isNullable = false}) => TypeReference(
    (b) => b
      ..isNullable = isNullable
      ..symbol = this,
  );
}

/// Extension providing utility methods for building code blocks.
extension BlockBuilderExtensions on BlockBuilder {
  /// Adds an empty line to the code block for better readability.
  ///
  /// This is useful for separating logical sections of generated code.
  void addEmptyLine() => statements.add(const Code(''));
}
