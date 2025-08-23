import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../model/field_symbol.dart';
import '../model/theme_mixin_config.dart';

/// A template for generate _$ThemeExtensionMixin.
class ThemeMixinTemplate {
  const ThemeMixinTemplate(this.config);

  final ThemeMixinConfig config;

  TypeReference themeExtensionRef({bool isNullable = false}) => TypeReference(
    (t) => t
      ..symbol = 'ThemeExtension'
      ..types.add(refer(config.className))
      ..isNullable = isNullable,
  );

  Method copyWith(ThemeMixinConfig config) {
    final body = BlockBuilder();
    final fields = config.fields;

    if (fields.isNotEmpty) {
      body
        ..addExpression(
          declareFinal('object').assign(
            refer('this').asA(refer(config.className)),
          ),
        )
        ..statements.add(const Code(''));
    }

    body.addExpression(
      refer(config.className).newInstance([], {
        for (final e in fields.entries)
          e.key: refer(e.key).ifNullThen(
            refer('object').property(e.key),
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
        ..annotations.add(refer('override'))
        ..returns = themeExtensionRef()
        ..optionalParameters.addAll(parameters)
        ..body = body.build();
    });

    return result;
  }

  Method lerpMethod(ThemeMixinConfig config) {
    final body = BlockBuilder();
    final fields = config.fields;

    body
      ..addExpression(
        declareFinal('otherValue').assign(
          refer('other'),
        ),
      )
      ..statements.add(
        ifCode(
          refer('otherValue').isNotA(refer(config.className)).code,
          [
            refer('this').returned.statement,
          ],
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

    body.addExpression(() {
      final args = <String, Expression>{};

      for (final e in fields.entries) {
        final field = e.value;

        if (field.hasLerp && field.lerpInfo!.isStatic) {
          args[e.key] = refer(field.type).property('lerp').call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]).nullChecked;
        } else {
          args[e.key] = refer('otherValue').property(field.name);
        }
      }

      final v = refer(config.className).newInstance([], args).returned;

      return v;
    }());

    final result = Method((m) {
      m
        ..name = 'lerp'
        ..annotations.add(refer('override'))
        ..returns = themeExtensionRef()
        ..requiredParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'other'
              ..type = themeExtensionRef(isNullable: true),
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

  Method equalOperator(ThemeMixinConfig config) {
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

  Method hashMethod(ThemeMixinConfig config) {
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
      case <= 20:
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
            refer('runtimeType'),
            for (final field in fields.values)
              refer('value').property(field.name),
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

  @override
  String toString() {
    final themeExtensionRef = TypeReference(
      (t) => t
        ..symbol = 'ThemeExtension'
        ..types.add(refer(config.className)),
    );

    final mix = Mixin((m) {
      m
        ..name = r'_$ThemeExtensionMixin'
        ..on = themeExtensionRef;

      m.methods.addAll([
        copyWith(config),
        lerpMethod(config),
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

    final dartCode = mix.accept(emitter).toString();
    final formattedCode = formatter.format(dartCode);

    return formattedCode;
  }
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
