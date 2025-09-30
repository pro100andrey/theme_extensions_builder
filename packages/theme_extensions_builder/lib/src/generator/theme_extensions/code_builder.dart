import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../../common/code_builder.dart';
import '../../common/symbols.dart';
import '../../config/config.dart';
import '../../extensions/string.dart';

/// Generates code for `ThemeExtension` mixins and related helpers.
class ThemeExtensionsCodeBuilder {
  const ThemeExtensionsCodeBuilder();

  /// Generates Dart code for the provided [config].
  ///
  /// The generated code includes:
  /// - a mixin for the theme extension,
  /// - `copyWith` and `lerp` methods,
  /// - equality (`==`) operator and `hashCode`,
  /// - optional BuildContext extension if `config.buildContextExtension` is
  /// true.
  String generate(ThemeExtensionsConfig config) {
    final themeExtensionRef = TypeReference(
      (t) => t
        ..symbol = 'ThemeExtension'
        ..types.add(refer(config.className)),
    );

    final mix = Mixin((m) {
      final name = !config.isDeprecatedMixin
          ? '_\$${config.className}Mixin'
          : r'_$ThemeExtensionMixin';
      m
        ..annotations.addAll([
          if (config.isDeprecatedMixin)
            refer('Deprecated').call([
              literalString(
                'This mixin is deprecated. '
                'Use `with _\\\$${config.className}Mixin` instead.',
              ),
            ]),
        ])
        ..name = name
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

    final buffer = StringBuffer(mix.accept(emitter).toString());
    if (config.buildContextExtension) {
      buffer.write(contextExtension(config).accept(emitter).toString());
    }

    final rawCode = buffer.toString();
    final formattedCode = formatter.format(rawCode);

    return formattedCode;
  }
}

// Returns a type reference for `ThemeExtension<T>` based on [config].
TypeReference themeExtensionRef(
  ThemeExtensionsConfig config, {
  bool isNullable = false,
}) => TypeReference(
  (t) => t
    ..symbol = 'ThemeExtension'
    ..types.add(refer(config.className))
    ..isNullable = isNullable,
);

/// Generates the `copyWith` method for the theme extension.
///
/// Allows creating a copy of the theme extension with some fields replaced.
Method copyWith(ThemeExtensionsConfig config) {
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
            ..type = refer(field.type.nullable()),
        ),
      )
      .toList(growable: false);

  final result = Method((m) {
    m
      ..name = 'copyWith'
      ..annotations.add(refer('override'))
      ..returns = themeExtensionRef(config)
      ..optionalParameters.addAll(parameters)
      ..body = body.build();
  });

  return result;
}

/// Generates the `lerp` (linear interpolation) method for the theme extension.
///
/// Supports:
/// - Fields with static `lerp` methods,
/// - Fields with instance `lerp` methods,
/// - `double` and `Duration` fields,
/// - Default conditional interpolation for other types.
Method lerpMethod(ThemeExtensionsConfig config) {
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

      switch (field) {
        // Lerp class with static lerp method
        case FieldSymbol(hasLerp: true, lerpInfo: (isStatic: true)):
          final expression = refer(field.type).property('lerp').call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]);

          args[e.key] = field.isNullable ? expression : expression.nullChecked;

        // Lerp class with instance lerp method
        case FieldSymbol(hasLerp: true, lerpInfo: (isStatic: false)):
          final expression = refer('value')
              .property(field.name)
              .property('lerp')
              .call([
                refer('otherValue').property(field.name),
                refer('t'),
              ])
              .asA(refer(field.type));

          args[e.key] = expression;

        // When the field is of type double
        case FieldSymbol(isDouble: true):
          final expression = refer(r'lerpDouble$').call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]);

          args[e.key] = field.isNullable ? expression : expression.nullChecked;

        // When the field is of type Duration
        case FieldSymbol(isDuration: true):
          final expression = refer(r'lerpDuration$').call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]);

          args[e.key] = field.isNullable ? expression : expression.nullChecked;

        // Default case: use a simple conditional expression
        case _:
          final expression = refer('t')
              .lessThan(literalNum(0.5))
              .conditional(
                refer('value').property(field.name),
                refer('otherValue').property(field.name),
              );

          args[e.key] = expression;
      }
    }

    final v = refer(config.className).newInstance([], args).returned;

    return v;
  }());

  final result = Method((m) {
    m
      ..name = 'lerp'
      ..annotations.add(refer('override'))
      ..returns = themeExtensionRef(config)
      ..requiredParameters.addAll([
        Parameter(
          (p) => p
            ..name = 'other'
            ..type = themeExtensionRef(config, isNullable: true),
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

/// Generates the equality operator `==` for the theme extension.
Method equalOperator(ThemeExtensionsConfig config) {
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

/// Generates the `hashCode` getter for the theme extension.
Method hashMethod(ThemeExtensionsConfig config) {
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

/// Generates a `BuildContext` extension to easily access the theme extension.
///
/// Example:
/// ```dart
/// context.myThemeExtension
/// ```
Extension contextExtension(ThemeExtensionsConfig config) {
  final result = Extension((b) {
    b
      ..name = '${config.className}BuildContext'
      ..on = refer('BuildContext')
      ..methods.add(
        Method((mb) {
          mb
            ..type = MethodType.getter
            ..lambda = true
            ..name = config.contextAccessorName ?? config.className.camelCase
            ..returns = refer(config.className)
            ..body = refer('Theme')
                .property('of')
                .call([refer('this')])
                .property('extension')
                .call([], {}, [refer(config.className)])
                .nullChecked
                .code;
        }),
      );
  });

  return result;
}
