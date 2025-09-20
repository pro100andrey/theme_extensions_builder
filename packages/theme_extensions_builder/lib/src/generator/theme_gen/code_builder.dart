import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../../common/code_builder.dart';
import '../../common/symbols.dart';
import '../../config/config.dart';
import '../../extensions/string.dart';

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
      ..returns = refer('bool')
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

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('a').assign(
          refer('this').asA(refer(config.className)),
        ),
      )
      ..statements.add(const Code(''));
  }

  body.addExpression(
    refer(config.className).newInstance([], {
      for (final e in fields.entries)
        e.key: refer(e.key).ifNullThen(
          refer('a').property(e.key),
        ),
    }).returned,
  );

  final parameters = fields.values
      .map(
        (field) => Parameter(
          (p) => p
            ..name = field.name
            ..named = true
            ..type = refer(field.type.nullable),
        ),
      )
      .toList(growable: false);

  final result = Method((m) {
    m
      ..name = 'copyWith'
      ..returns = refer(config.className)
      ..optionalParameters.addAll(parameters)
      ..body = body.build();
  });

  return result;
}

/// Generates a `merge` method for the theme class.
Method merge(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.fields;

  body
    ..addExpression(
      declareFinal('current').assign(
        refer('this').asA(refer(config.className)),
      ),
    )
    ..statements.add(const Code(''))
    ..statements.add(
      ifCode(
        refer('other').equalTo(literalNull).code,
        [refer('current').returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..statements.add(
      ifCode(
        refer('other').negate().property('canMerge').code,
        [refer('other').returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..addExpression(
      refer('copyWith').call([], {
        for (final e in fields.entries)
          e.key: e.value.hasMerge
              ? () {
                  var prop = refer('current').property(e.value.name);

                  prop = e.value.isNullable
                      ? prop.nullSafeProperty('merge')
                      : prop.property('merge');

                  prop = prop.call([refer('other').property(e.key)]);

                  if (e.value.isNullable) {
                    prop = prop.ifNullThen(refer('other').property(e.key));
                  }
                  return prop;
                }()
              : refer('other').property(e.key),
      }).returned,
    );

  final result = Method((m) {
    m
      ..name = 'merge'
      ..returns = refer(config.className)
      ..requiredParameters.add(
        Parameter(
          (p) => p
            ..name = 'other'
            ..type = refer(config.className.nullable),
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
        refer('identical').call([refer('a'), refer('b')]).code,
        [refer('a').returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..addExpression(() {
      final args = <String, Expression>{};

      for (final e in fields.entries) {
        final field = e.value;

        switch (field) {
          // When the field has a static lerp method
          case FieldSymbol(hasLerp: true, lerpInfo: (isStatic: true)):
            final expression = refer(field.type).property('lerp').call([
              refer('a'.nullable).property(field.name),
              refer('b'.nullable).property(field.name),
              refer('t'),
            ]);

            args[e.key] = field.isNullable
                ? expression
                : expression.nullChecked;

          // When the field has a non-static lerp method
          case FieldSymbol(hasLerp: true, lerpInfo: (isStatic: false)):
            final expression = refer('a'.nullable)
                .property(field.name)
                .property('lerp')
                .call([
                  refer('b'.nullable).property(field.name),
                  refer('t'),
                ])
                .asA(refer(field.type));

            args[e.key] = expression;

          // When the field is of type double
          case FieldSymbol(isDouble: true):
            final expression = refer(r'lerpDouble$').call([
              refer('a'.nullable).property(field.name),
              refer('b'.nullable).property(field.name),
              refer('t'),
            ]);

            args[e.key] = field.isNullable
                ? expression
                : expression.nullChecked;

          // When the field is of type Duration
          case FieldSymbol(isDuration: true):
            final expression = refer(r'lerpDuration$').call([
              refer('a'.nullable).property(field.name),
              refer('b'.nullable).property(field.name),
              refer('t'),
            ]);

            args[e.key] = field.isNullable
                ? expression
                : expression.nullChecked;

          // Default case: use a simple conditional expression
          case _:
            if (field.name == 'canMerge') {
              args[e.key] = refer('b'.nullable)
                  .property(field.name)
                  .ifNullThen(
                    literalTrue,
                  );
              continue;
            }

            args[e.key] = refer('t')
                .lessThan(literalNum(0.5))
                .conditional(
                  refer('a'.nullable).property(field.name),
                  refer('b'.nullable).property(field.name),
                );
        }
      }

      final v = refer(config.className).newInstance([], args).returned;

      return v;
    }());

  final result = Method((m) {
    m
      ..name = 'lerp'
      ..static = true
      ..returns = refer(config.className.nullable)
      ..requiredParameters.addAll([
        Parameter(
          (p) => p
            ..name = 'a'
            ..type = refer(config.className.nullable),
        ),
        Parameter(
          (p) => p
            ..name = 'b'
            ..type = refer(config.className.nullable),
        ),
        Parameter(
          (p) => p
            ..name = 't'
            ..type = refer('double'),
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
        refer('identical').call([refer('this'), refer('other')]).code,
        [literalTrue.returned.statement],
      ),
    )
    ..statements.add(const Code(''))
    ..statements.add(
      ifCode(
        refer(
          'other',
        ).property('runtimeType').notEqualTo(refer('runtimeType')).code,
        [literalFalse.returned.statement],
      ),
    )
    ..statements.add(const Code(''));

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('value').assign(
          refer('this').asA(refer(config.className)),
        ),
      )
      ..statements.add(const Code(''));
  }

  body.addExpression(
    refer('other')
        .isA(refer(config.className))
        .and(
          fields.entries
              .map((e) {
                final name = e.key;
                return refer('other')
                    .property(name)
                    .equalTo(
                      refer('value').property(name),
                    );
              })
              .reduce((a, b) => a.and(b)),
        )
        .returned,
  );

  final result = Method((m) {
    m
      ..name = 'operator =='
      ..annotations.add(refer('override'))
      ..returns = refer('bool')
      ..requiredParameters.add(
        Parameter(
          (p) => p
            ..name = 'other'
            ..type = refer('Object'),
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
        declareFinal('value').assign(
          refer('this').asA(refer(config.className)),
        ),
      )
      ..statements.add(const Code(''));
  }

  switch (fields.length) {
    case 0:
      body.addExpression(
        refer('runtimeType').property('hashCode').returned,
      );
    case <= 19:
      body.addExpression(
        refer('Object').property('hash').call([
          refer('runtimeType'),
          for (final field in fields.values)
            refer('value').property(field.name),
        ]).returned,
      );
    case _:
      body.addExpression(
        refer('Object').property('hashAll').call([
          literalList([
            refer('runtimeType'),
            for (final field in fields.values)
              refer('value').property(field.name),
          ]),
        ]).returned,
      );
  }

  final result = Method((m) {
    m
      ..name = 'hashCode'
      ..annotations.add(refer('override'))
      ..returns = refer('int')
      ..type = MethodType.getter
      ..body = body.build();
  });

  return result;
}
