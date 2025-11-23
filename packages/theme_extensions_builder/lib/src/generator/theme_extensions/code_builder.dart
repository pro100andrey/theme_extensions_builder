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
        ..types.add(config.className.ref),
    );

    final mix = Mixin((m) {
      m
        ..name = config.themeExtensionMixinName
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
    ..types.add(config.className.ref)
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
        declareFinal('_this'.ref.symbol).assign(
          'this'.ref.asA(config.className.ref),
        ),
      )
      ..statements.add(const Code(''));
  }

  body.addExpression(
    InvokeExpression.newOf(
      config.className.ref,
      [],
      {
        for (final field in fields)
          field.name: field.name.ref.ifNullThen(
            '_this'.ref.property(field.name),
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
            ..type = field.type.nullable().ref,
        ),
      )
      .toList(growable: false);

  final result = Method((m) {
    m
      ..name = 'copyWith'
      ..annotations.add('override'.ref)
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
    ..statements.add(
      ifCode(
        'other'.ref.isNotA(config.className.ref).code,
        ['this'.ref.returned.statement],
      ),
    )
    ..statements.add(const Code(''));

  if (fields.isNotEmpty) {
    body
      ..addExpression(
        declareFinal('_this'.ref.symbol).assign(
          'this'.ref.asA(config.className.ref),
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
          final expression = field.type.ref.property(methodName).call([
            '_this'.ref.property(field.name),
            'other'.ref.property(field.name),
            't'.ref,
          ]);

          args[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

        // Lerp class with instance lerp method
        case FieldSymbol(
          hasLerp: true,
          lerpInfo: (isStatic: false, nullableArgs: _, :final methodName),
        ):
          final expression = '_this'.ref
              .property(field.name)
              .property(methodName)
              .call([
                'other'.ref.property(field.name),
                't'.ref,
              ])
              .asA(field.type.ref);

          args[field.name] = expression;

        // When the field is of type double
        case FieldSymbol(isDouble: true):
          final expression = r'lerpDouble$'.ref.call([
            '_this'.ref.property(field.name),
            'other'.ref.property(field.name),
            't'.ref,
          ]);

          args[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

        // When the field is of type Duration
        case FieldSymbol(isDuration: true):
          final expression = r'lerpDuration$'.ref.call([
            '_this'.ref.property(field.name),
            'other'.ref.property(field.name),
            't'.ref,
          ]);

          args[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

        // Default case: use a simple conditional expression
        case _:
          final expression = 't'.ref
              .lessThan(literalNum(0.5))
              .conditional(
                '_this'.ref.property(field.name),
                'other'.ref.property(field.name),
              );

          args[field.name] = expression;
      }
    }

    return InvokeExpression.newOf(
      config.className.ref,
      [],
      args,
      [],
      config.constructor,
    ).returned;
  }());

  final result = Method((m) {
    m
      ..name = 'lerp'
      ..annotations.add('override'.ref)
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
            ..type = 'double'.ref,
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

/// Generates the `hashCode` getter for the theme extension.
Method hashMethod(ThemeExtensionsConfig config) {
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
      ..on = 'BuildContext'.ref
      ..methods.add(
        Method((mb) {
          mb
            ..type = MethodType.getter
            ..lambda = true
            ..name = config.contextAccessorName ?? config.className.camelCase
            ..returns = config.className.ref
            ..body = 'Theme'.ref
                .property('of')
                .call(['this'.ref])
                .property('extension')
                .call([], {}, [config.className.ref])
                .nullChecked
                .code;
        }),
      );
  });

  return result;
}
