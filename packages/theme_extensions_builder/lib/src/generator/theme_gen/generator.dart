// ignore_for_file: avoid_print

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/fields_visiter.dart';
import '../../config/config.dart';
import 'code_builder.dart';

/// Code generator for classes annotated with `@ThemeGen`.
///
/// This generator creates mixins for theme data classes that don't extend
/// Flutter's `ThemeExtension`. The generated code includes:
/// - `copyWith` method for creating modified copies
/// - `merge` method for combining theme instances
/// - `lerp` static method for interpolation
/// - `==` operator and `hashCode` for equality comparison
/// - `canMerge` getter indicating merge capability
///
/// Example usage:
/// ```dart
/// @ThemeGen()
/// class MyTheme with _$MyTheme {
///   const MyTheme({required this.color});
///   final Color color;
/// }
/// ```
class ThemeGenGenerator extends GeneratorForAnnotation<ThemeGen> {
  /// Creates a [ThemeGenGenerator] with optional [builderOptions].
  ThemeGenGenerator({this.builderOptions});

  /// Optional build configuration options.
  final BuilderOptions? builderOptions;

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'ThemeGen can only annotate classes',
        element: element,
        todo: 'Move @ThemeGen annotation above `class`',
      );
    }

    final constructor = annotation.read('constructor').literalValue as String?;
    final constConstructor = element.constructors.any((c) => c.isConst);

    final fieldsVisiter = FieldsVisitor();
    // Get all supertypes to visit their fields as well
    final allSupertypes = element.allSupertypes;

    for (final supertype in allSupertypes) {
      final superElement = supertype.element;

      if (!supertype.isDartCoreObject) {
        superElement.visitChildren(fieldsVisiter);
      }
    }
    // Finally, visit the original class to get its own fields
    element.visitChildren(fieldsVisiter);

    final generatorConfig = ThemeGenConfig(
      fields: fieldsVisiter.fields,
      className: element.displayName,
      constructor: constructor,
      constConstructor: constConstructor,
    );

    const generator = ThemeGenCodeBuilder();
    final code = generator.generate(generatorConfig);

    return code;
  }
}
