import 'package:code_builder/code_builder.dart';

import '../../common/symbols/field_info.dart';
import '../../common/symbols/lerp_info.dart';
import '../../common/symbols/merge_info.dart';
import '../../config/config.dart';
import '../common.dart';

/// Generates code for theme extensions based on a given configuration.
class ThemeGenCodeBuilder {
  const ThemeGenCodeBuilder();

  /// Generates Dart code for the provided [config].
  ///
  /// The generated code includes methods such as `copyWith`, `merge`,
  /// `lerp`, equality operators, and hashCode.
  String generate(ThemeGenConfig config) {
    final mix = Mixin((m) {
      m
        ..name = '_\$${config.className}'
        ..methods.addAll([
          canMerge(config),
          staticLerp(config),
          copyWith(config),
          merge(config),
          equalOperator(config),
          hashMethod(config),
        ]);
    });

    // Set up the Dart code emitter
    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      useNullSafetySyntax: true,
      orderDirectives: true,
    );

    final mixinLibrary = Library((lib) => lib.body.addAll([mix]));
    return mixinLibrary.accept(emitter).toString();
  }
}

/// Generates a getter `canMerge` which always returns true.
Method canMerge(ThemeGenConfig config) => Method((m) {
  m
    ..name = 'canMerge'
    ..returns = 'bool'.ref
    ..type = MethodType.getter
    ..lambda = true
    ..body = literalTrue.code;
});

/// Generates a `copyWith` method for the theme class.
Method copyWith(ThemeGenConfig config) => Method((m) {
  final fields = config.filteredFields;

  m
    ..name = 'copyWith'
    ..returns = config.className.ref
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
      // If there are fields, create a _this variable for easier access
      if (fields.isNotEmpty) {
        b
          ..addExpression(
            declareFinal('_this').assign('this'.ref.asA(config.className.ref)),
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

/// Generates a `merge` method for the theme class.
Method merge(ThemeGenConfig config) => Method((m) {
  m
    ..name = 'merge'
    ..returns = config.className.ref
    ..requiredParameters.add(
      Parameter(
        (p) => p
          ..name = 'other'
          ..type = config.className.typeRef(isNullable: true),
      ),
    )
    ..body = Block((b) {
      final fields = config.filteredFields;

      b
        // Create a _this variable for easier access to the current instance
        ..addExpression(
          declareFinal(
            '_this'.ref.symbol,
          ).assign('this'.ref.asA(config.className.ref)),
        )
        ..addEmptyLine()
        // Return `_this` if other is null or identical to `_this`
        ..statements.add(
          ifStatement(
            'other'.ref
                .equalTo(literalNull)
                .or('identical'.ref(['_this'.ref, 'other'.ref])),
            Block((b) => b.addExpression('_this'.ref.returned)),
          ),
        )
        ..addEmptyLine()
        // Return `other` if it cannot be merged
        ..statements.add(
          ifStatement(
            'other'.ref.negate().prop('canMerge'),
            Block((b) => b.addExpression('other'.ref.returned)),
          ),
        )
        ..addEmptyLine();

      final args = <String, Expression>{};
      for (final field in fields) {
        final thisProp = '_this'.ref.prop(field.name);
        final otherProp = 'other'.ref.prop(field.name);

        final staticMerge = field.typeName.ref.prop('merge');
        final instanceMerge = thisProp.prop('merge');

        // Handle different merge strategies based on field configuration

        // No merge method, just take the other property
        // `property: other.property`
        if (field.merge case NoMerge()) {
          args[field.name] = otherProp;
          continue;
        }

        // Static merge method with optional field
        if (field.merge case StaticMerge() when field.isNullable) {
          args[field.name] = thisProp
              .notEqualTo(literalNull)
              .and(otherProp.notEqualTo(literalNull))
              .conditional(
                staticMerge([thisProp.nullChecked, otherProp.nullChecked]),
                otherProp,
              );
          continue;
        }

        // Static merge method with non-optional field
        if (field.merge case StaticMerge() when !field.isNullable) {
          args[field.name] = staticMerge([thisProp, otherProp]);
          continue;
        }

        // Instance merge method with optional field
        if (field.merge case InstanceMerge() when field.isNullable) {
          args[field.name] = thisProp
              .nullSafeProperty('merge')([otherProp])
              .ifNullThen(otherProp);
          continue;
        }

        // Instance merge method with non-optional field
        if (field.merge case InstanceMerge() when !field.isNullable) {
          args[field.name] = instanceMerge([otherProp]);
          continue;
        }

        throw StateError('Unsupported merge info for field ${field.name}');
      }

      b.addExpression('copyWith'.ref([], args).returned);
    });
});

/// Generates a static `lerp` method for interpolating between two theme
/// instances.
///
/// Supports fields with custom static or instance `lerp` methods, as well as
/// `double` and `Duration` fields.
Method staticLerp(ThemeGenConfig config) => Method((m) {
  m
    ..name = 'lerp'
    ..static = true
    ..returns = config.className.typeRef(isNullable: true)
    ..requiredParameters.addAll([
      Parameter(
        (p) => p
          ..name = 'a'.ref.symbol
          ..type = config.className.typeRef(isNullable: true),
      ),
      Parameter(
        (p) => p
          ..name = 'b'.ref.symbol
          ..type = config.className.typeRef(isNullable: true),
      ),
      Parameter(
        (p) => p
          ..name = 't'.ref.symbol
          ..type = 'double'.ref,
      ),
    ])
    ..body = Block((b) {
      final fields = config.filteredFields;

      b
        // If a and b are identical, return a
        ..statements.add(
          ifStatement(
            'identical'.ref(['a'.ref, 'b'.ref]),
            Block((b) => b.addExpression('a'.ref.returned)),
          ),
        )
        ..addEmptyLine()
        // If a is null, return b if t is 1.0, else null
        ..statements.add(
          ifStatement(
            'a'.ref.equalTo(literalNull),
            Block(
              (b) => b.addExpression(
                't'.ref
                    .equalTo(literalNum(1.0))
                    .conditional('b'.ref, literalNull)
                    .returned,
              ),
            ),
          ),
        )
        ..addEmptyLine()
        // If b is null, return a if t is 0.0, else null
        ..statements.add(
          ifStatement(
            'b'.ref.equalTo(literalNull),
            Block(
              (b) => b.addExpression(
                't'.ref
                    .equalTo(literalNum(0.0))
                    .conditional('a'.ref, literalNull)
                    .returned,
              ),
            ),
          ),
        )
        ..addEmptyLine();

      final argsResult = <String, Expression>{};

      for (final field in fields) {
        final aProp = 'a'.ref.prop(field.name);
        final bProp = 'b'.ref.prop(field.name);
        final lerp = field.typeName.ref.prop('lerp');

        // Handle different lerp strategies based on field configuration

        // Non-nullable field with non-nullable lerp signature
        if (field.lerp case StaticLerp(
          isNullableSignature: false,
        ) when !field.isNullable) {
          // value: Class.lerp(a.field, b.field, t)
          argsResult[field.name] = lerp([aProp, bProp, 't'.ref]);

          continue;
        }

        // Non-nullable field with nullable lerp signature
        if (field.lerp case StaticLerp(
          isNullableSignature: true,
        ) when !field.isNullable) {
          // value: Class.lerp(a.field, b.field, t)!
          argsResult[field.name] = lerp([aProp, bProp, 't'.ref]).nullChecked;
          continue;
        }

        // Nullable field with non-nullable lerp signature
        if (field.lerp case StaticLerp(
          isNullableSignature: false,
        ) when field.isNullable) {
          // value: a.field == null
          //     ? b.field
          //     : b.field == null
          //         ? a.field
          //         : Class.lerp(a.field!, b.field!, t)
          argsResult[field.name] = aProp
              .equalTo(literalNull)
              .conditional(
                bProp,
                bProp
                    .equalTo(literalNull)
                    .conditional(
                      aProp,
                      lerp([aProp.nullChecked, bProp.nullChecked, 't'.ref]),
                    ),
              );

          continue;
        }

        // Nullable field with nullable lerp signature
        if (field.lerp case StaticLerp(
          isNullableSignature: true,
        ) when field.isNullable) {
          // value: Class.lerp(a.field, b.field, t)
          argsResult[field.name] = lerp([aProp, bProp, 't'.ref]);

          continue;
        }

        // Instance lerp method with optional result
        if (field.lerp case InstanceLerp(
          optionalResult: true,
        ) when field.isNullable) {
          // value: a.field?.lerp(b.field, t)
          argsResult[field.name] = aProp.prop('lerp', nullSafe: true)([
            bProp,
            't'.ref,
          ]);

          continue;
        }
        // Instance lerp method with non-optional result
        if (field.lerp case InstanceLerp(
          optionalResult: false,
        ) when !field.isNullable) {
          // value: a.field.lerp(b.field, t)
          argsResult[field.name] = aProp
              .prop('lerp')([bProp, 't'.ref])
              .asA(field.typeName.typeRef());

          continue;
        }

        // WidgetStateProperty lerp with inner lerp function
        if (field.lerp case WidgetStatePropertyLerp(
          :final baseTypeName,
          :final genericType,
          :final isNullableGeneric,
          :final genericIsDouble,
          :final genericIsDuration,
        )) {
          // Get the inner lerp function reference
          final innerLerpFn = genericIsDouble
              ? r'lerpDouble$'.ref
              : genericIsDuration
              ? r'lerpDuration$'.ref
              : genericType.ref.prop('lerp');

          // WidgetStateProperty.lerp<Color?>(
          // a.field,
          // b.field,
          // t,
          // Color.lerp
          // )
          argsResult[field.name] = baseTypeName.ref.prop('lerp')(
            [aProp, bProp, 't'.ref, innerLerpFn],
            {},
            [genericType.typeRef(isNullable: isNullableGeneric)],
          );

          continue;
        }

        // When the field is of type double
        if (field case FieldInfo(isDouble: true) when field.lerp is NoLerp) {
          final expression = r'lerpDouble$'.ref([aProp, bProp, 't'.ref]);

          argsResult[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

          continue;
        }

        // When the field is of type Duration
        if (field case FieldInfo(isDuration: true) when field.lerp is NoLerp) {
          final expression = r'lerpDuration$'.ref([aProp, bProp, 't'.ref]);

          argsResult[field.name] = field.isNullable
              ? expression
              : expression.nullChecked;

          continue;
        }

        // Special case for canMerge field
        if (field.name == 'canMerge') {
          argsResult[field.name] = bProp;
          continue;
        }
        // Fallback to a simple conditional expression:
        // t < 0.5 ? a.field : b.field
        argsResult[field.name] = 't'.ref
            .lessThan(literalNum(0.5))
            .conditional(aProp, bProp);
      }

      b.addExpression(
        (argsResult.isEmpty && config.constConstructor
                ? InvokeExpression.constOf
                : InvokeExpression.newOf)(
              config.className.ref,
              [],
              argsResult,
              [],
              config.constructor,
            )
            .returned,
      );
    });
});
