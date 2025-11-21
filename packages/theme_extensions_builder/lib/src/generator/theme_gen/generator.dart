// ignore_for_file: avoid_print

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/analysis.dart';
import '../../common/symbols.dart';
import '../../common/visitors.dart';
import '../../config/config.dart';
import 'code_builder.dart';

/// It's a Dart code generator that generates code for the `@ThemeGen`
/// annotation.
class ThemeGenGenerator extends GeneratorForAnnotation<ThemeGen> {
  ThemeGenGenerator({required this.builderOptions});

  final BuilderOptions builderOptions;

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

    final classVisitor = _ClassVisitor();
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

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class _ClassVisitor extends BaseClassVisitor {
  final List<FieldSymbol> fields = [];
  final Map<String, List<bool>> hasInternalAnnotations = {};

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (element.isFinal) {
      final type = element.type.getDisplayString();
      final isNullable = type.endsWith('?');
      final resultType = isNullable ? type.substring(0, type.length - 1) : type;

      final symbol = FieldSymbol(
        lerpInfo: hasLerp(element),
        mergeInfo: hasMerge(element),
        name: element.displayName,
        type: resultType,
        isNullable: isNullable,
      );

      fields.add(symbol);
    }
  }
}
