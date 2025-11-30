import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '../../common/symbols.dart';
import '../../config/config.dart';
import '../../extensions/string.dart';
import '../common.dart';

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
    final mix = Mixin((m) {
      m
        ..name = config.themeExtensionMixinName
        ..on = TypeReference(
          (t) => t
            ..symbol = 'ThemeExtension'
            ..types.add(config.className.ref),
        )
        ..methods.addAll([
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

    final library = Library(
      (b) => b.body.addAll([
        mix,
        if (config.buildContextExtension) contextExtension(config),
      ]),
    );

    final rawCode = library.accept(emitter).toString();
    final formattedCode = formatter.format(rawCode);

    return formattedCode;
  }
}

/// Generates the `copyWith` method for the theme extension.
///
/// Allows creating a copy of the theme extension with some fields replaced.
Method copyWith(ThemeExtensionsConfig config) => Method((m) {
  final fields = config.filteredFields;

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
            ..type = field.baseType.typeRef(optional: true),
        ),
      ),
    )
    ..body = Block((b) {
      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal('_this'.ref.symbol).assign(
              'this'.ref.asA(config.className.ref),
            ),
          )
          ..addEmptyLine();
      }

      final args = <String, Expression>{};
      for (final field in fields) {
        args[field.name] = field.name.ref.ifNullThen(
          '_this'.ref.prop(field.name),
        );
      }

      b.addExpression(
        (fields.isEmpty && config.constConstructor
                ? InvokeExpression.constOf
                : InvokeExpression.newOf)(
              config.className.ref,
              [],
              args,
              [],
              config.constructor,
            )
            .returned,
      );
    });
});

/// Generates the `lerp` (linear interpolation) method for the theme extension.
///
/// Supports:
/// - Fields with static `lerp` methods,
/// - Fields with instance `lerp` methods,
/// - `double` and `Duration` fields,
/// - Default conditional interpolation for other types.
Method lerpMethod(ThemeExtensionsConfig config) => Method((m) {
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
    ..body = Block((b) {
      final fields = config.filteredFields;

      b
        ..statements.add(
          ifStatement(
            'other'.ref.isNotA(config.className.ref),
            Block((b) => b.addExpression('this'.ref.returned)),
          ),
        )
        ..addEmptyLine();

      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal('_this'.ref.symbol).assign(
              'this'.ref.asA(config.className.ref),
            ),
          )
          ..addEmptyLine();
      }

      final args = <String, Expression>{};

      for (final field in fields) {
        final tProp = '_this'.ref.prop(field.name);
        final oProp = 'other'.ref.prop(field.name);

        // Handle NoLerpMethod with double field
        if (field.lerp case NoLerpMethod() when field.isDouble) {
          // lerpDouble$(_this.field, other.field, t) or
          // lerpDouble$(_this.field, other.field, t)!
          final expression = r'lerpDouble$'.ref([
            tProp,
            oProp,
            't'.ref,
          ]);

          args[field.name] = field.optional
              ? expression
              : expression.nullChecked;
          continue;
        }

        // Handle NoLerpMethod with duration field
        if (field.lerp case NoLerpMethod() when field.isDuration) {
          // lerpDuration$(_this.field, other.field, t) or
          // lerpDuration$(_this.field, other.field, t)!
          final expression = r'lerpDuration$'.ref([
            tProp,
            oProp,
            't'.ref,
          ]);

          args[field.name] = field.optional
              ? expression
              : expression.nullChecked;
          continue;
        }

        if (field.lerp case NoLerpMethod()) {
          // Default conditional expression

          args[field.name] = 't'.ref
              .lessThan(literalNum(0.5))
              .conditional(
                '_this'.ref.prop(field.name),
                'other'.ref.prop(field.name),
              );

          continue;
        }

        final sLerp = field.baseType.ref.prop('lerp');

        // Handle StaticLerpMethod with non-nullable signature and optional
        // field
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: false,
        ) when field.optional) {
          // _this.side == null
          // ? other.side
          // : other.side == null
          // ? _this.side
          // : Side.lerp(_this.side!, other.side!, t),
          args[field.name] = tProp
              .equalTo(literalNull)
              .conditional(
                oProp,
                oProp
                    .equalTo(literalNull)
                    .conditional(
                      tProp,
                      sLerp([
                        tProp.nullChecked,
                        oProp.nullChecked,
                        't'.ref,
                      ]),
                    ),
              );
          continue;
        }
        // Handle StaticLerpMethod with non-nullable signature and
        // non-optional field
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: false,
        ) when !field.optional) {
          // FieldType.lerp(_this.field, other.field, t)
          args[field.name] = sLerp([tProp, oProp, 't'.ref]);
          continue;
        }

        // Handle StaticLerpMethod with nullable signature and
        // non-optional field
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: true,
        ) when !field.optional) {
          // FieldType.lerp(_this.field!, other.field!, t)!
          args[field.name] = sLerp([tProp, oProp, 't'.ref]).nullChecked;
          continue;
        }

        // Handle StaticLerpMethod with nullable signature and optional
        // field
        if (field.lerp case StaticLerpMethod(
          isNullableSignature: true,
        ) when field.optional) {
          // FieldType.lerp(_this.field, other.field, t)
          args[field.name] = sLerp([tProp, oProp, 't'.ref]);
          continue;
        }

        // Handle InstanceLerpMethod with optional field
        if (field.lerp case InstanceLerpMethod() when field.optional) {
          // _this.field?.lerp(other.field, t) as FieldType?
          args[field.name] = tProp
              .prop('lerp', nullSafe: true)
              .asA(field.baseType.typeRef(optional: field.optional));
          continue;
        }

        // Handle InstanceLerpMethod with non-optional field
        if (field.lerp case InstanceLerpMethod() when !field.optional) {
          // _this.field.lerp(other.field, t) as FieldType
          args[field.name] = tProp
              .prop('lerp')([oProp, 't'.ref])
              .asA(field.baseType.typeRef(optional: field.optional));
          continue;
        }

        throw UnimplementedError(
          'Lerp method not implemented for field: ${field.name}',
        );
      }

      b.addExpression(
        (args.isEmpty && config.constConstructor
                ? InvokeExpression.constOf
                : InvokeExpression.newOf)(
              config.className.ref,
              [],
              args,
              [],
              config.constructor,
            )
            .returned,
      );
    });
});
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
                .prop('of')(['this'.ref])
                .prop('extension')([], {}, [config.className.ref])
                .nullChecked
                .code;
        }),
      );
  });

  return result;
}
