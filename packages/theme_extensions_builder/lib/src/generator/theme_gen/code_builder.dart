import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../../common/code_builder.dart';
import '../../common/symbols.dart';
import '../../extensions/string.dart';
import 'config.dart';

/// Generates code for theme extensions.
class ThemeGenCodeBuilder {
  const ThemeGenCodeBuilder();

  /// Generates code for the given [config].
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

    final buffer = StringBuffer(mix.accept(emitter).toString());
    // if (config.buildContextExtension) {
    //   buffer.write(contextExtension(config).accept(emitter).toString());
    // }

    final rawCode = buffer.toString();
    final formattedCode = formatter.format(rawCode);

    return formattedCode;
  }
}

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
            ..type = refer(field.nullableType),
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

// ShadOptionTheme mergeWith(ShadOptionTheme? other) {
//   if (other == null) return this;
//   if (!other.merge) return other;
//   return copyWith(
//     hoveredBackgroundColor: other.hoveredBackgroundColor,
//     padding: other.padding,
//     radius: other.radius,
//   );
// }

Method merge(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.fields;

  body
    ..addExpression(
      declareFinal('current').assign(
        refer('this').asA(refer(config.className)),
      ),
    )
    ..statements.add(const Code(''));

  body
    ..statements.add(
      ifCode(
        refer('other').equalTo(literalNull).code,
        [refer('current').returned.statement],
      ),
    )
    ..statements.add(const Code(''));

  body
    ..statements.add(
      ifCode(
        refer('other').negate().property('canMerge').code,
        [refer('other').returned.statement],
      ),
    )
    ..statements.add(const Code(''));

  body.addExpression(
    refer(config.className).newInstance([], {
      for (final e in fields.entries) e.key: refer('other').property(e.key),
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
    ..statements.add(const Code(''));

  body.addExpression(() {
    final args = <String, Expression>{};

    for (final e in fields.entries) {
      final field = e.value;

      switch (field) {
        // When the field has a static lerp method
        case FieldSymbol(hasLerp: true, lerpInfo: (isStatic: true)):
          args[e.key] = refer(field.type).property('lerp').call([
            refer('a'.nullable).property(field.name),
            refer('b'.nullable).property(field.name),
            refer('t'),
          ]).nullChecked;
        // When the field has a non-static lerp method
        case FieldSymbol(hasLerp: true, lerpInfo: (isStatic: false)):
          args[e.key] = refer('a'.nullable)
              .property(field.name)
              .property('lerp')
              .call([
                refer('b'.nullable).property(field.name),
                refer('t'),
              ])
              .asA(refer(field.type));
        // When the field is of type double
        case FieldSymbol(isDouble: true):
          args[e.key] = refer(r'lerpDouble$').call([
            refer('a'.nullable).property(field.name),
            refer('b'.nullable).property(field.name),
            refer('t'),
          ]).nullChecked;

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

Method equalOperator(ThemeGenConfig config) {
  final body = BlockBuilder();
  final fields = config.fields;

  body
    ..statements.add(
      ifCode(
        refer('identical').call([refer('this'), refer('other')]).code,
        [const Code('return true;')],
      ),
    )
    ..statements.add(const Code(''));

  if (fields.isNotEmpty) {
    body.addExpression(
      declareFinal('value').assign(
        refer('this').asA(refer(config.className)),
      ),
    );
  }

  final baseEquality = refer('other')
      .property('runtimeType')
      .equalTo(refer('runtimeType'))
      .and(
        refer('other').isA(refer(config.className)),
      );

  body.addExpression(
    fields.isEmpty
        ? baseEquality.returned
        : baseEquality
              .and(
                fields.entries
                    .map((e) {
                      final name = e.key;
                      return refer('identical').call([
                        refer('value').property(name),
                        refer('other').property(name),
                      ]);
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
