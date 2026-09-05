import 'package:code_builder/code_builder.dart';

import '../../common/symbols/lerp_info.dart';
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

    final library = Library(
      (b) => b.body.addAll([
        mix,
        if (config.buildContextExtension) contextExtension(config),
      ]),
    );

    return library.accept(emitter).toString();
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
            ..type = field.typeName.typeRef(isNullable: true),
        ),
      ),
    )
    ..body = Block((b) {
      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal(
              '_this'.ref.symbol,
            ).assign('this'.ref.asA(config.className.ref)),
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
            declareFinal(
              '_this'.ref.symbol,
            ).assign('this'.ref.asA(config.className.ref)),
          )
          ..addEmptyLine();
      }

      final args = <String, Expression>{};

      for (final field in fields) {
        final tProp = '_this'.ref.prop(field.name);
        final oProp = 'other'.ref.prop(field.name);
        final sLerp = field.baseTypeName.ref.prop('lerp');

        switch (field.lerp) {
          // Handle NoLerp with double field
          case NoLerp() when field.isDouble:
            // lerpDouble$(_this.field, other.field, t) or
            // lerpDouble$(_this.field, other.field, t)!
            final expression = r'lerpDouble$'.ref([tProp, oProp, 't'.ref]);

            args[field.name] = field.isNullable
                ? expression
                : expression.nullChecked;

          // Handle NoLerp with duration field
          case NoLerp() when field.isDuration:
            // lerpDuration$(_this.field, other.field, t) or
            // lerpDuration$(_this.field, other.field, t)!
            final expression = r'lerpDuration$'.ref([tProp, oProp, 't'.ref]);

            args[field.name] = field.isNullable
                ? expression
                : expression.nullChecked;

          // Default conditional expression
          case NoLerp():
            // t < 0.5 ? _this.field : other.field
            args[field.name] = 't'.ref
                .lessThan(literalNum(0.5))
                .conditional(tProp, oProp);

          // Handle StaticLerp on a non-optional field, returning an
          // optional result
          case StaticLerp(optionalResult: true) when !field.isNullable:
            // FieldType.lerp(_this.field, other.field, t)!
            args[field.name] = sLerp([tProp, oProp, 't'.ref]).nullChecked;

          // Handle StaticLerp on a non-optional field, returning a
          // non-optional result
          case StaticLerp() when !field.isNullable:
            // FieldType.lerp(_this.field, other.field, t)
            args[field.name] = sLerp([tProp, oProp, 't'.ref]);

          // Handle StaticLerp taking nullable arguments, optional field
          case StaticLerp(isNullableParameter: true):
            // FieldType.lerp(_this.field, other.field, t)
            args[field.name] = sLerp([tProp, oProp, 't'.ref]);

          // Handle StaticLerp taking non-nullable arguments, optional field
          case StaticLerp():
            // _this.side == null || other.side == null
            //     ? (t < 0.5 ? _this.side : other.side)
            //     : Side.lerp(_this.side!, other.side!, t)
            args[field.name] = nullGuardedLerp(
              tProp,
              oProp,
              sLerp([tProp.nullChecked, oProp.nullChecked, 't'.ref]),
            );

          // Handle InstanceLerp with an optional field, returning a supertype
          case InstanceLerp(needsCast: true) when field.isNullable:
            // _this.field == null || other.field == null
            //     ? (t < 0.5 ? _this.field : other.field)
            //     : _this.field!.lerp(other.field!, t) as FieldType?
            args[field.name] = nullGuardedLerp(
              tProp,
              oProp,
              tProp.nullChecked
                  .property('lerp')([oProp.nullChecked, 't'.ref])
                  .asA(field.typeName.typeRef(isNullable: true)),
            );

          // Handle InstanceLerp with an optional field
          case InstanceLerp() when field.isNullable:
            // _this.field == null || other.field == null
            //     ? (t < 0.5 ? _this.field : other.field)
            //     : _this.field!.lerp(other.field!, t)
            args[field.name] = nullGuardedLerp(
              tProp,
              oProp,
              tProp.nullChecked.property('lerp')([oProp.nullChecked, 't'.ref]),
            );

          // Handle InstanceLerp returning a supertype, non-optional field
          case InstanceLerp(needsCast: true):
            // _this.field.lerp(other.field, t) as FieldType
            args[field.name] = tProp
                .prop('lerp')([oProp, 't'.ref])
                .asA(field.typeName.typeRef());

          // Handle InstanceLerp with non-optional field
          case InstanceLerp():
            // _this.field.lerp(other.field, t)
            args[field.name] = tProp.prop('lerp')([oProp, 't'.ref]);

          // Handle WidgetStateProperty lerp with inner lerp function
          case WidgetStatePropertyLerp(
            :final baseTypeName,
            :final genericType,
            :final genericBaseTypeName,
            :final isNullableGeneric,
            :final genericIsDouble,
            :final genericIsDuration,
          ):
            // Get the inner lerp function reference
            final innerLerpFn = genericIsDouble
                ? r'lerpDouble$'.ref
                : genericIsDuration
                ? r'lerpDuration$'.ref
                : genericBaseTypeName.ref.prop('lerp');

            // WidgetStateProperty.lerp<Color?>(
            //   _this.field,
            //   other.field,
            //   t,
            //   Color.lerp
            // )
            final expression = baseTypeName.ref.prop('lerp')(
              [tProp, oProp, 't'.ref, innerLerpFn],
              {},
              [genericType.typeRef(isNullable: isNullableGeneric)],
            );

            args[field.name] = field.isNullable
                ? expression
                : expression.nullChecked;
        }
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
            ..name =
                config.contextAccessorName ??
                config.className.camelCase(suffixToRemove: 'Extension')
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
