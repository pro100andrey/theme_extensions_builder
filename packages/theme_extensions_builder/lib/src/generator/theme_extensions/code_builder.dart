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

/// Generates the `copyWith` method for the theme extension.
///
/// Allows creating a copy of the theme extension with some fields replaced.
Method copyWith(ThemeExtensionsConfig config) {
  final body = BlockBuilder();
  final fields = config.fields;
  final classNameRef = config.className.ref;
  final isEmpty = fields.isEmpty;

  if (!isEmpty) {
    body
      ..addExpression(
        declareFinal('_this'.ref.symbol).assign('this'.ref.asA(classNameRef)),
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
      ..annotations.add('override'.ref)
      ..returns = _buildThemeExtensionRef(config)
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
  final isEmpty = fields.isEmpty;

  body
    ..statements.add(
      ifCode(
        'other'.ref.isNotA(config.className.ref).code,
        ['this'.ref.returned.statement],
      ),
    )
    ..statements.add(const Code(''));

  if (!isEmpty) {
    body
      ..addExpression(
        declareFinal('_this'.ref.symbol).assign(
          'this'.ref.asA(config.className.ref),
        ),
      )
      ..statements.add(const Code(''));
  }

  body.addExpression(
    _buildConstructorCall(
      config,
      args: () {
        final args = <String, Expression>{};

        for (final field in fields) {
          switch (field) {
            // Lerp class with static lerp method
            case FieldSymbol(lerpInfo: (isStatic: true, :final displayType)):
              final expression = displayType.ref.property('lerp').call([
                '_this'.ref.property(field.name),
                'other'.ref.property(field.name),
                't'.ref,
              ]);

              args[field.name] = field.isNullable
                  ? expression
                  : expression.nullChecked;

            // Lerp class with instance lerp method
            case FieldSymbol(lerpInfo: (isStatic: false, displayType: _)):
              final expression = '_this'.ref
                  .property(field.name)
                  .prop('lerp', nullSafe: field.isNullable)
                  .call(['other'.ref.property(field.name), 't'.ref])
                  .asA(field.type.typeRef(optional: field.isNullable));

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
              args[field.name] = 't'.ref
                  .lessThan(literalNum(0.5))
                  .conditional(
                    '_this'.ref.property(field.name),
                    'other'.ref.property(field.name),
                  );
          }
        }

        return args;
      }(),
    ).returned,
  );

  final result = Method((m) {
    m
      ..name = 'lerp'
      ..annotations.add('override'.ref)
      ..returns = _buildThemeExtensionRef(config)
      ..requiredParameters.addAll([
        Parameter(
          (p) => p
            ..name = 'other'
            ..type = _buildThemeExtensionRef(config, isNullable: true),
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

// Returns a type reference for `ThemeExtension<T>` based on [config].
TypeReference _buildThemeExtensionRef(
  ThemeExtensionsConfig config, {
  bool isNullable = false,
}) => TypeReference(
  (t) => t
    ..symbol = 'ThemeExtension'
    ..types.add(config.className.ref)
    ..isNullable = isNullable,
);

/// Helper to build constructor call with correct const/new.
InvokeExpression _buildConstructorCall(
  ThemeExtensionsConfig config, {
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
