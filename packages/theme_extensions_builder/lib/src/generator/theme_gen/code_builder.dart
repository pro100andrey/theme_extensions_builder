import 'package:code_builder/code_builder.dart';

import '../../common/symbols/field_info.dart';
import '../../common/symbols/lerp_info.dart';
import '../../common/symbols/merge_info.dart';
import '../../config/config.dart';
import '../common.dart';

/// Generates the mixin for a `@ThemeGen` class.
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
          copyWithMethod(config, returns: config.className.ref),
          merge(config),
          equalOperator(config),
          hashMethod(config),
        ]);
    });

    final library = Library((lib) => lib.body.add(mix));

    return library.accept(partEmitter()).toString();
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
      b
        ..addExpression(declareThis(config))
        ..addEmptyLine()
        // Return `_this` if other is null or identical to `_this`
        ..statements.add(
          ifStatement(
            'other'.ref
                .equalTo(literalNull)
                .or('identical'.ref([thisRef, 'other'.ref])),
            Block((b) => b.addExpression(thisRef.returned)),
          ),
        )
        ..addEmptyLine()
        // Return `other` if it cannot be merged
        ..statements.add(
          ifStatement(
            'other'.ref.negate().property('canMerge'),
            Block((b) => b.addExpression('other'.ref.returned)),
          ),
        )
        ..addEmptyLine();

      final args = {
        for (final field in config.fields)
          field.name: _mergeFieldExpression(
            field,
            thisRef.property(field.name),
            'other'.ref.property(field.name),
          ),
      };

      b.addExpression('copyWith'.ref([], args).returned);
    });
});

/// The expression that merges [other] into [current] for [field].
Expression _mergeFieldExpression(
  FieldInfo field,
  Expression current,
  Expression other,
) {
  final staticMerge = field.baseTypeName.ref.property('merge');

  Expression castIfNeeded(Expression expression, {required bool needsCast}) =>
      needsCast
      ? expression.asA(field.typeName.typeRef(isNullable: field.isNullable))
      : expression;

  // A merge that cannot take a null on either side keeps whichever value is
  // present:
  // _this.field == null
  //     ? other.field
  //     : other.field == null
  //     ? _this.field
  //     : <merge>
  Expression whenBothPresent(Expression merge) => current
      .equalTo(literalNull)
      .conditional(
        other,
        other.equalTo(literalNull).conditional(current, merge),
      );

  return switch (field.merge) {
    // No merge method, just take the other property
    NoMerge() => other,

    // Class.merge(_this.field!, other.field!), guarded
    StaticMerge() when field.isNullable => whenBothPresent(
      staticMerge([current.nullChecked, other.nullChecked]),
    ),

    // Class.merge(_this.field, other.field)
    StaticMerge() => staticMerge([current, other]),

    // _this.field?.merge(other.field) ?? other.field
    InstanceMerge(isNullableParameter: true, :final needsCast)
        when field.isNullable =>
      castIfNeeded(
        current.nullSafeProperty('merge')([other]),
        needsCast: needsCast,
      ).ifNullThen(other),

    // _this.field!.merge(other.field!), guarded
    InstanceMerge(:final needsCast) when field.isNullable => whenBothPresent(
      castIfNeeded(
        current.nullChecked.property('merge')([other.nullChecked]),
        needsCast: needsCast,
      ),
    ),

    // _this.field.merge(other.field)
    InstanceMerge(:final needsCast) => castIfNeeded(
      current.property('merge')([other]),
      needsCast: needsCast,
    ),
  };
}

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
          ..name = 'a'
          ..type = config.className.typeRef(isNullable: true),
      ),
      Parameter(
        (p) => p
          ..name = 'b'
          ..type = config.className.typeRef(isNullable: true),
      ),
      Parameter(
        (p) => p
          ..name = 't'
          ..type = 'double'.ref,
      ),
    ])
    ..body = Block((b) {
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
                tRef
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
                tRef
                    .equalTo(literalNum(0.0))
                    .conditional('a'.ref, literalNull)
                    .returned,
              ),
            ),
          ),
        )
        ..addEmptyLine();

      final args = <String, Expression>{};

      for (final field in config.fields) {
        final aProp = 'a'.ref.property(field.name);
        final bProp = 'b'.ref.property(field.name);

        // A `canMerge` declared as a field rather than a getter is not
        // interpolated: the result takes the value of `b`.
        args[field.name] = field.name == 'canMerge' && field.lerp is NoLerp
            ? bProp
            : lerpFieldExpression(field, aProp, bProp);
      }

      b.addExpression(construct(config, args).returned);
    });
});
