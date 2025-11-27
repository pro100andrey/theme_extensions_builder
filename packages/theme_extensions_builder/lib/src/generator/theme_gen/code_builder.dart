import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../../common/code_builder.dart';
import '../../common/symbols.dart';
import '../../config/config.dart';

/// Generates code for theme extensions based on a given configuration.
class ThemeGenCodeBuilder {
  const ThemeGenCodeBuilder();

  /// Generates Dart code for the provided [config].
  ///
  /// The generated code includes methods such as `copyWith`, `merge`,
  /// `lerp`, equality operators, and hashCode.
  String generate(ThemeGenConfig config) {
    final mix = Mixin((m) {
      final name = '_\$${config.className}';

      m.name = name;

      m.methods.addAll([
        canMerge(config),
        staticLerp(config),
        copyWith(config),
        merge(config),
        equalOperator(config),
        hashMethod(config),
      ]);
    });

    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      useNullSafetySyntax: true,
      orderDirectives: true,
    );

    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
      pageWidth: DartFormatter.defaultPageWidth,
      trailingCommas: TrailingCommas.automate,
    );

    final mixinLibrary = Library((b) => b.body.addAll([mix]));

    final rawCode = mixinLibrary.accept(emitter).toString();
    final formattedCode = formatter.format(rawCode);

    return formattedCode;
  }
}

/// Generates a getter `canMerge` which always returns true.
Method canMerge(ThemeGenConfig config) {
  final result = Method((m) {
    m
      ..name = 'canMerge'
      ..returns = 'bool'.ref
      ..type = MethodType.getter
      ..lambda = true
      ..body = literalTrue.code;
  });

  return result;
}

/// Generates a `copyWith` method for the theme class.
Method copyWith(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.supportedFields;
  final isEmpty = fields.isEmpty;
  final thisRef = '_this'.ref;

  if (!isEmpty) {
    body
      ..addExpression(
        declareFinal(thisRef.symbol).assign(
          'this'.ref.asA(config.className.ref),
        ),
      )
      ..addEmptyLine();
  }

  body.addExpression(
    _buildConstructorCall(
      config,
      args: isEmpty
          ? {}
          : {
              for (final field in fields)
                field.name: field.name.ref.ifNullThen(
                  thisRef.prop(field.name),
                ),
            },
    ).returned,
  );

  return Method((m) {
    m
      ..name = 'copyWith'
      ..returns = config.className.ref
      ..optionalParameters.addAll(
        fields.map(
          (field) => Parameter(
            (p) => p
              ..name = field.name
              ..named = true
              ..type = field.baseType.typeRef(optional: true),
          ),
        ),
      )
      ..body = body.build();
  });
}

/// Generates a `merge` method for the theme class.
Method merge(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.supportedFields;
  final thisRef = '_this'.ref;
  final otherRef = 'other'.ref;

  body
    ..addExpression(
      declareFinal(thisRef.symbol).assign(
        'this'.ref.asA(config.className.ref),
      ),
    )
    ..addEmptyLine()
    ..statements.add(
      ifCode(
        otherRef
            .equalTo(literalNull)
            .or('identical'.ref([thisRef, otherRef]))
            .code,
        [thisRef.returned.statement],
      ),
    )
    ..addEmptyLine()
    ..statements.add(
      ifCode(
        otherRef.negate().prop('canMerge').code,
        [otherRef.returned.statement],
      ),
    )
    ..addEmptyLine();

  final namedArguments = fields.map((field) {
    final thisProp = thisRef.prop(field.name);
    final otherProp = otherRef.prop(field.name);

    final staticMerge = field.baseType.ref.prop('merge');
    final instanceMerge = thisProp.prop('merge');

    final key = field.name;
    final value = switch (field.merge) {
      NoMergeMethod() => otherProp,
      StaticMergeMethod() when field.optional =>
        thisProp
            .notEqualTo(literalNull)
            .and(otherProp.notEqualTo(literalNull))
            .conditional(
              staticMerge([thisProp.nullChecked, otherProp.nullChecked]),
              otherProp,
            ),

      StaticMergeMethod() when !field.optional => staticMerge([
        thisProp,
        otherProp,
      ]),
      InstanceMergeMethod() =>
        field.optional
            ? thisProp
                  .nullSafeProperty('merge')([otherProp])
                  .ifNullThen(otherProp)
            : instanceMerge([otherProp]),
      _ => throw StateError(
        'Unsupported merge info for field ${field.name}',
      ),
    };

    return MapEntry(key, value);
  });

  body.addExpression(
    'copyWith'.ref
        .call(
          [],
          Map.fromEntries(namedArguments),
        )
        .returned,
  );

  final result = Method((m) {
    m
      ..name = 'merge'
      ..returns = config.className.ref
      ..requiredParameters.add(
        Parameter(
          (p) => p
            ..name = 'other'
            ..type = config.className.typeRef(optional: true),
        ),
      )
      ..body = body.build();
  });

  return result;
}

/// Generates a static `lerp` method for interpolating between two theme
/// instances.
///
/// Supports fields with custom static or instance `lerp` methods, as well as
/// `double` and `Duration` fields.
Method staticLerp(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.supportedFields;
  final a = 'a'.ref;
  final b = 'b'.ref;
  final t = 't'.ref;

  body
    ..statements.add(
      ifCode(
        'identical'.ref([a, b]).code,
        [a.returned.statement],
      ),
    )
    ..addEmptyLine()
    ..statements.add(
      ifCode(
        a.equalTo(literalNull).and(b.equalTo(literalNull)).code,
        [literalNull.returned.statement],
      ),
    )
    ..addEmptyLine()
    ..statements.add(
      ifCode(
        a.equalTo(literalNull).code,
        [
          t
              .equalTo(literalNum(1.0))
              .conditional(b, literalNull)
              .returned
              .statement,
        ],
      ),
    )
    ..addEmptyLine()
    ..statements.add(
      ifCode(
        b.equalTo(literalNull).code,
        [
          t
              .equalTo(literalNum(0.0))
              .conditional(a, literalNull)
              .returned
              .statement,
        ],
      ),
    )
    ..addEmptyLine()
    ..addExpression(() {
      final argsResult = <String, Expression>{};

      for (final field in fields) {
        final aProp = a.prop(field.name);
        final bProp = b.prop(field.name);
        final lerp = field.baseType.ref.prop('lerp');

        // Non-nullable field with non-nullable lerp signature
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: false,
        ) when !field.optional) {
          // value: Class.lerp(a.field, b.field, t)
          argsResult[field.name] = lerp([aProp, bProp, t]);

          continue;
        }

        // Nullable field with non-nullable lerp signature
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: false,
        ) when field.optional) {
          final expression = aProp
              .equalTo(literalNull)
              .conditional(
                bProp,
                bProp
                    .equalTo(literalNull)
                    .conditional(
                      aProp,
                      lerp([aProp.nullChecked, bProp.nullChecked, t]),
                    ),
              );

          argsResult[field.name] = expression;

          continue;
        }

        // Non-nullable field with non-nullable lerp signature
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: false,
        ) when !field.optional) {
          final expression = lerp([
            aProp.nullSafe.nullChecked,
            bProp.nullSafe.nullChecked,
            t,
          ]);

          argsResult[field.name] = expression;
          continue;
        }

        // Nullable field with nullable lerp signature
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: true,
        ) when field.optional) {
          final expression = lerp([aProp, bProp, t]);
          argsResult[field.name] = expression;
          continue;
        }

        // Instance lerp method
        if (field.lerp case InstanceLerpMethod()) {
          final expression = aProp.nullSafe
              .prop('lerp')
              .withNullSafety(field.optional)
              .call([bProp.nullSafe, t])
              .asA(field.baseType.typeRef(optional: field.optional));

          argsResult[field.name] = expression;
          continue;
        }

        // When the field is of type double
        if (field case FieldSymbol(
          isDouble: true,
        ) when field.lerp is NoLerpMethod) {
          final expression = r'lerpDouble$'.ref([
            aProp,
            bProp,
            t,
          ]);

          argsResult[field.name] = field.optional
              ? expression
              : expression.nullChecked;

          continue;
        }

        // When the field is of type Duration
        if (field case FieldSymbol(
          isDuration: true,
        ) when field.lerp is NoLerpMethod) {
          final expression = r'lerpDuration$'.ref.call([
            aProp,
            bProp,
            t,
          ]);

          argsResult[field.name] = field.optional
              ? expression
              : expression.nullChecked;

          continue;
        }

        if (field.name == 'canMerge') {
          argsResult[field.name] = bProp;
          continue;
        }

        argsResult[field.name] = t
            .lessThan(literalNum(0.5))
            .conditional(aProp, bProp);
      }

      return _buildConstructorCall(config, args: argsResult).returned;
    }());

  final result = Method((m) {
    m
      ..name = 'lerp'
      ..static = true
      ..returns = config.className.typeRef(optional: true)
      ..requiredParameters.addAll([
        Parameter(
          (p) => p
            ..name = a.symbol
            ..type = config.className.typeRef(optional: true),
        ),
        Parameter(
          (p) => p
            ..name = b.symbol
            ..type = config.className.typeRef(optional: true),
        ),
        Parameter(
          (p) => p
            ..name = t.symbol
            ..type = 'double'.ref,
        ),
      ])
      ..body = body.build();
  });

  return result;
}

/// Generates the equality operator `==` for the theme class.
Method equalOperator(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.supportedFields;

  body
    ..statements.add(
      ifCode(
        'identical'.ref.call(['this'.ref, 'other'.ref]).code,
        [literalTrue.returned.statement],
      ),
    )
    ..addEmptyLine()
    ..statements.add(
      ifCode(
        'other'.ref.property('runtimeType').notEqualTo('runtimeType'.ref).code,
        [literalFalse.returned.statement],
      ),
    )
    ..addEmptyLine();

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('_this').assign('this'.ref.asA(config.className.ref)),
      )
      ..addExpression(
        declareFinal('_other').assign('other'.ref.asA(config.className.ref)),
      )
      ..addEmptyLine()
      ..addExpression(
        fields
            .map(
              (field) => '_other'.ref
                  .property(field.name)
                  .equalTo(
                    '_this'.ref.property(field.name),
                  ),
            )
            .reduce((a, b) => a.and(b))
            .returned,
      );
  } else {
    body.addExpression(literalTrue.returned);
  }

  final result = Method((m) {
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
      ..body = body.build();
  });

  return result;
}

/// Generates the `hashCode` getter for the theme class.
Method hashMethod(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.supportedFields;

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('_this').assign(
          'this'.ref.asA(config.className.ref),
        ),
      )
      ..addEmptyLine();
  }

  switch (fields.length) {
    case 0:
      body.addExpression(
        'runtimeType'.ref.property('hashCode').returned,
      );
    case <= 19:
      body.addExpression(
        'Object'.ref.property('hash').call([
          'runtimeType'.ref,
          for (final field in fields) '_this'.ref.property(field.name),
        ]).returned,
      );
    case _:
      body.addExpression(
        'Object'.ref.property('hashAll').call([
          literalList([
            'runtimeType'.ref,
            for (final field in fields) '_this'.ref.property(field.name),
          ]),
        ]).returned,
      );
  }

  final result = Method((m) {
    m
      ..name = 'hashCode'
      ..annotations.add('override'.ref)
      ..returns = 'int'.ref
      ..type = MethodType.getter
      ..body = body.build();
  });

  return result;
}

/// Helper to build constructor call with correct const/new.
InvokeExpression _buildConstructorCall(
  ThemeGenConfig config, {
  required Map<String, Expression> args,
}) {
  final isEmpty = args.isEmpty;
  final useConst = isEmpty && config.constConstructor;

  return useConst
      ? InvokeExpression.constOf(
          config.className.ref,
          [],
          {},
          [],
          config.constructor,
        )
      : InvokeExpression.newOf(
          config.className.ref,
          [],
          args,
          [],
          config.constructor,
        );
}
