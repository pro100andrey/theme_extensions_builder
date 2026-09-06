import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/fields_visitor.dart';
import '../../common/validation.dart';
import '../../config/config.dart';
import '../annotation_reader.dart';
import 'code_builder.dart';

/// Code generator for classes annotated with `@ThemeExtensions`.
///
/// This generator creates code for custom Flutter theme extensions that
/// extend `ThemeExtension`. The generated code includes:
/// - `copyWith` method for creating modified copies
/// - `lerp` method for smooth theme transitions
/// - `==` operator and `hashCode` for equality comparison
/// - Optional BuildContext extension for convenient theme access
///
/// Example usage:
/// ```dart
/// @ThemeExtensions()
/// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme {
///   const MyTheme({required this.color});
///   final Color color;
/// }
/// ```
class ThemeExtensionsGenerator extends GeneratorForAnnotation<ThemeExtensions> {
  /// Creates a [ThemeExtensionsGenerator].
  const ThemeExtensionsGenerator();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'ThemeExtensions can only annotate classes',
        element: element,
        todo: 'Move @ThemeExtensions annotation above `class`',
      );
    }

    checkExtendsThemeExtension(element);

    final buildContextExtension = annotation
        .read('buildContextExtension')
        .boolValue;

    final contextAccessorName = annotation.optionalString(
      'contextAccessorName',
    );

    if (contextAccessorName != null) {
      checkIdentifier(
        contextAccessorName,
        option: 'contextAccessorName',
        element: element,
      );
    }

    final constructorName = annotation.optionalString('constructor');
    final constructor = resolveConstructor(element, constructorName);

    // ThemeExtensions needs lerp but doesn't generate merge methods
    final fields = collectFields(element, includeMergeLookup: false);

    checkConstructorParameters(element, constructor, fields);

    final config = ThemeExtensionsConfig(
      fields: fields,
      className: element.displayName,
      contextAccessorName: contextAccessorName,
      buildContextExtension: buildContextExtension,
      constructor: constructorName,
      // The mixin is applied by name, so the name is a convention.
      themeExtensionMixinName: '_\$${element.displayName}',
      constConstructor: constructor.isConst,
    );

    return const ThemeExtensionsCodeBuilder().generate(config);
  }
}
