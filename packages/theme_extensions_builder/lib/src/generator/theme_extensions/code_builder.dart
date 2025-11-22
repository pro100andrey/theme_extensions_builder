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
      m
        ..name = '_\$${config.className}Mixin'
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
    InvokeExpression.newOf(
      refer(config.className),
      [],
      {
        for (final field in fields)
          field.name: refer(field.name).ifNullThen(
            refer('object').property(field.name),
          ),
      },
      [],
      config.constructor,
    ).returned,
  );

  final parameters = fields
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

    for (final field in fields) {
      switch (field) {
        // Lerp class with static lerp method
        case FieldSymbol(
          hasLerp: true,
          lerpInfo: (isStatic: true, nullableArgs: _, :final methodName),
        ):
          final expression = refer(field.type).property(methodName).call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]);

          args[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

        // Lerp class with instance lerp method
        case FieldSymbol(
          hasLerp: true,
          lerpInfo: (isStatic: false, nullableArgs: _, :final methodName),
        ):
          final expression = refer('value')
              .property(field.name)
              .property(methodName)
              .call([
                refer('otherValue').property(field.name),
                refer('t'),
              ])
              .asA(refer(field.type));

          args[field.name] = expression;

        // When the field is of type double
        case FieldSymbol(isDouble: true):
          final expression = refer(r'lerpDouble$').call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]);

          args[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

        // When the field is of type Duration
        case FieldSymbol(isDuration: true):
          final expression = refer(r'lerpDuration$').call([
            refer('value').property(field.name),
            refer('otherValue').property(field.name),
            refer('t'),
          ]);

          args[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

        // Default case: use a simple conditional expression
        case _:
          final expression = refer('t')
              .lessThan(literalNum(0.5))
              .conditional(
                refer('value').property(field.name),
                refer('otherValue').property(field.name),
              );

          args[field.name] = expression;
      }
    }

    return InvokeExpression.newOf(
      refer(config.className),
      [],
      args,
      [],
      config.constructor,
    ).returned;
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
        refer('other').isNotA(refer(config.className)).code,
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
      ..statements.add(const Code(''))
      ..addExpression(
        fields
            .map(
              (field) => refer('other')
                  .property(field.name)
                  .equalTo(
                    refer('value').property(field.name),
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
          for (final field in fields) refer('value').property(field.name),
        ]).returned,
      );
    case _:
      body.addExpression(
        refer('Object').property('hashAll').call([
          literalList([
            refer('runtimeType'),
            for (final field in fields) refer('value').property(field.name),
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
