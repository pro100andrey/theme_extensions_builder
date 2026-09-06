import 'package:code_builder/code_builder.dart';

import '../../config/config.dart';
import '../../extensions/string.dart';
import '../common.dart';

/// Generates the mixin for a `@ThemeExtensions` class, and the `BuildContext`
/// extension that reaches it.
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
        ..on = _themeExtensionRef(config)
        ..methods.addAll([
          copyWithMethod(
            config,
            returns: _themeExtensionRef(config),
            isOverride: true,
          ),
          lerpMethod(config),
          equalOperator(config),
          hashMethod(config),
        ]);
    });

    final library = Library(
      (b) => b.body.addAll([
        mix,
        if (config.buildContextExtension) contextExtension(config),
      ]),
    );

    return library.accept(partEmitter()).toString();
  }
}

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
    ..annotations.add(overrideAnnotation)
    ..returns = _themeExtensionRef(config)
    ..requiredParameters.addAll([
      Parameter(
        (p) => p
          ..name = 'other'
          ..type = _themeExtensionRef(config, isNullable: true),
      ),
      Parameter(
        (p) => p
          ..name = 't'
          ..type = 'double'.ref,
      ),
    ])
    ..body = Block((b) {
      final fields = config.fields;

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
          ..addExpression(declareThis(config))
          ..addEmptyLine();
      }

      final args = {
        for (final field in fields)
          field.name: lerpFieldExpression(
            field,
            thisRef.property(field.name),
            'other'.ref.property(field.name),
          ),
      };

      b.addExpression(construct(config, args).returned);
    });
});

/// A reference to `ThemeExtension<ClassName>`.
TypeReference _themeExtensionRef(
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
Extension contextExtension(ThemeExtensionsConfig config) => Extension((b) {
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
              .property('of')(['this'.ref])
              .property('extension')([], {}, [config.className.ref])
              .nullChecked
              .code;
      }),
    );
});
