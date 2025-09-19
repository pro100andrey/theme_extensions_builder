// ignore_for_file: avoid_print

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/symbols.dart';
import '../../common/visitors.dart';
import 'code_builder.dart';
import 'config.dart';

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

    final classVisitor = _ClassVisitor();
    element.visitChildren(classVisitor);

    final generatorConfig = ThemeGenConfig(
      fields: classVisitor.fields,
      className: element.displayName,
    );

    const generator = ThemeGenCodeBuilder();
    final code = generator.generate(generatorConfig);

    return code;
  }
}

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class _ClassVisitor extends BaseClassVisitor {
  final Map<String, FieldSymbol> fields = {};
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

      fields[element.displayName] = FieldSymbol(
        lerpInfo: _hasLerp(element),
        name: element.displayName,
        type: resultType,
        isNullable: isNullable,
      );
    }
  }

  LerpInfo? _hasLerp(FieldElement field) {
    final element = field.type.element;

    if (element is! ClassElement) {
      return null;
    }

    final types = [
      element,
      ...element.allSupertypes
          .where((e) => !e.isDartCoreObject)
          .map((e) => e.element),
    ];

    for (final type in types) {
      for (final method in type.methods) {
        if (method case MethodElement(displayName: 'lerp', isPublic: true)) {
          if (method.children.last case FormalParameterElement(
            :final type,
          ) when type.isDartCoreDouble) {
            return (isStatic: method.isStatic);
          }
        }
      }
    }

    return null;
  }
}
