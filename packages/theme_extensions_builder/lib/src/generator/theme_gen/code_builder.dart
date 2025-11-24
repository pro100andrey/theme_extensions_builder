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

    final rawCode = mix.accept(emitter).toString();
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
  final fields = config.fields;
  final isEmpty = fields.isEmpty;

  if (!isEmpty) {
    body
      ..addExpression(
        declareFinal('_this').assign(
          'this'.ref.asA(config.className.ref),
        ),
      )
      ..statements.add(const Code(''));
  }

  body.addExpression(
    _buildConstructorCall(
      config,
      args: isEmpty
          ? {}
          : {
              for (final field in fields)
                field.name: field.name.ref.ifNullThen(
                  '_this'.ref.property(field.name),
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
              ..type = field.type.typeRef(optional: true),
          ),
        ),
      )
      ..body = body.build();
  });
}

/// Generates a `merge` method for the theme class.
Method merge(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.fields;

  body
    ..addExpression(
      declareFinal('_this').assign(
        'this'.ref.asA(config.className.ref),
      ),
    )
    ..statements.add(const Code(''))
    ..statements.add(
      ifCode(
        'other'.ref.equalTo(literalNull).code,
        ['_this'.ref.returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..statements.add(
      ifCode(
        'other'.ref.negate().property('canMerge').code,
        ['other'.ref.returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..addExpression(
      'copyWith'.ref.call([], {
        for (final field in fields)
          field.name: field.hasMerge
              ? () {
                  if (field.mergeInfo!.isStatic && field.isNullable) {
                    final prop = '_this'.ref
                        .property(field.name)
                        .notEqualTo(literalNull)
                        .and(
                          'other'.ref
                              .property(field.name)
                              .notEqualTo(literalNull),
                        )
                        .conditional(
                          field.type.ref.property('merge').call([
                            '_this'.ref.property(field.name).nullChecked,
                            'other'.ref.property(field.name).nullChecked,
                          ]),
                          'other'.ref.property(field.name),
                        );

                    return prop;
                  } else if (field.mergeInfo!.isStatic && !field.isNullable) {
                    return field.type.ref.property('merge').call([
                      '_this'.ref.property(field.name),
                      'other'.ref.property(field.name),
                    ]);
                  } else {
                    var prop = '_this'.ref.property(field.name);
                    prop = field.isNullable
                        ? prop.nullSafeProperty('merge')
                        : prop.property('merge');

                    prop = prop.call(['other'.ref.property(field.name)]);

                    if (field.isNullable) {
                      prop = prop.ifNullThen(
                        'other'.ref.property(field.name),
                      );
                    }

                    return prop;
                  }
                }()
              : 'other'.ref.property(field.name),
      }).returned,
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
  final fields = config.fields;

  body
    ..statements.add(
      ifCode(
        'a'.ref.equalTo(literalNull).and('b'.ref.equalTo(literalNull)).code,
        [literalNull.returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..addExpression(() {
      final args = <String, Expression>{};

      for (final field in fields) {
        switch (field) {
          // When the field has a static lerp method
          case FieldSymbol(lerpInfo: (isStatic: true, :final displayType)):
            final expression = displayType.ref.property('lerp').call([
              'a'.ref.prop(field.name, nullSafe: true),
              'b'.ref.prop(field.name, nullSafe: true),
              't'.ref,
            ]);

            args[field.name] = field.isNullable
                ? expression
                : expression.nullChecked;

          // When the field has a non-static lerp method
          case FieldSymbol(lerpInfo: (isStatic: false, displayType: _)):
            final expression = 'a'.ref
                .nullSafeProperty(field.name)
                .prop('lerp', nullSafe: field.isNullable)
                .call(['b'.ref.prop(field.name, nullSafe: true), 't'.ref])
                .asA(field.type.typeRef(optional: field.isNullable));

            args[field.name] = expression;

          // When the field is of type double
          case FieldSymbol(isDouble: true):
            final expression = r'lerpDouble$'.ref.call([
              'a'.ref.prop(field.name, nullSafe: true),
              'b'.ref.prop(field.name, nullSafe: true),
              't'.ref,
            ]);

            args[field.name] = field.isNullable
                ? expression
                : expression.nullChecked;

          // When the field is of type Duration
          case FieldSymbol(isDuration: true):
            final expression = r'lerpDuration$'.ref.call([
              'a'.ref.prop(field.name, nullSafe: true),
              'b'.ref.prop(field.name, nullSafe: true),
              't'.ref,
            ]);

            args[field.name] = field.isNullable
                ? expression
                : expression.nullChecked;

          // Default case: use a simple conditional expression
          case _:
            if (field.name == 'canMerge') {
              args[field.name] = 'b'.ref
                  .prop(field.name, nullSafe: true)
                  .ifNullThen(literalTrue);
              continue;
            }

            args[field.name] = 't'.ref
                .lessThan(literalNum(0.5))
                .conditional(
                  'a'.ref.prop(field.name, nullSafe: true),
                  'b'.ref.prop(field.name, nullSafe: true),
                );
        }
      }

      return _buildConstructorCall(config, args: args).returned;
    }());

  final result = Method((m) {
    m
      ..name = 'lerp'
      ..static = true
      ..returns = config.className.typeRef(optional: true)
      ..requiredParameters.addAll([
        Parameter(
          (p) => p
            ..name = 'a'
            ..type = config.className.typeRef(optional: true),
        ),
        Parameter(
          (p) => p
            ..name = 'b'
            ..type = config.className.typeRef(optional: true),
        ),
        Parameter(
          (p) => p
            ..name = 't'
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
  final fields = config.fields;

  body
    ..statements.add(
      ifCode(
        'identical'.ref.call(['this'.ref, 'other'.ref]).code,
        [literalTrue.returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..statements.add(
      ifCode(
        'other'.ref.property('runtimeType').notEqualTo('runtimeType'.ref).code,
        [literalFalse.returned.statement],
      ),
    )
    ..statements.add(const Code(''));

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('_this').assign('this'.ref.asA(config.className.ref)),
      )
      ..addExpression(
        declareFinal('_other').assign('other'.ref.asA(config.className.ref)),
      )
      ..statements.add(const Code(''))
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
  final fields = config.fields;

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('_this').assign(
          'this'.ref.asA(config.className.ref),
        ),
      )
      ..statements.add(const Code(''));
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
