// ignore_for_file: avoid_print

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../config/config.dart';
import 'code_builder.dart';
import 'visitor.dart';

/// It's a Dart code generator that generates code for the `@ThemeGen`
/// annotation.
class ThemeGenGenerator extends GeneratorForAnnotation<ThemeGen> {
  ThemeGenGenerator({this.builderOptions});

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

    final classVisitor = ThemeGenClassVisitor();
    // Get all supertypes to visit their fields as well
    final allSupertypes = element.allSupertypes;

    for (final supertype in allSupertypes) {
      final superElement = supertype.element;

      if (superElement is ClassElement && !supertype.isDartCoreObject) {
        superElement.visitChildren(classVisitor);
      }
    }
    // Finally, visit the original class to get its own fields
    element.visitChildren(classVisitor);

    final generatorConfig = ThemeGenConfig(
      fields: classVisitor.fields,
      className: element.displayName,
      constructor: constructor,
    );

    const generator = ThemeGenCodeBuilder();
    final code = generator.generate(generatorConfig);

    return code;
  }
}
