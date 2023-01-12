import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder/src/model/build_context_config.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../model/field.dart';
import '../model/theme_mixin_config.dart';
import '../templates/build_context_template.dart';
import '../templates/theme_mixin_template.dart';

/// It's a Dart code generator that generates code for the `@ThemeExtensions`
/// annotation
class ThemeExtensionsGenerator extends GeneratorForAnnotation<ThemeExtensions> {
  ThemeExtensionsGenerator({required this.builderOptions});

  final BuilderOptions builderOptions;

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement || element is Enum) {
      throw InvalidGenerationSourceError(
        'ThemeExtensions can only annotate classes',
        element: element,
        todo: 'Move @ThemeExtensions annotation above `class`',
      );
    }

    final classVisitor = _ClassVisitor();
    element.visitChildren(classVisitor);

    final buildContext = annotation.read('buildContextExtension').boolValue;

    final generatorBuffer = StringBuffer()
      ..write(
        ThemeMixinTemplate(
          ThemeMixinConfig(
            fields: classVisitor.fields,
            className: element.name,
          ),
        ),
      );

    if (buildContext) {
      generatorBuffer.write(
        BuildContextTemplate(
          BuildContextConfig(
            className: element.name,
          ),
        ),
      );
    }

    return generatorBuffer.toString();
  }
}

/// It's a class that extends the SimpleElementVisitor class, and it overrides the
/// visitClassElement method
class _ClassVisitor extends SimpleElementVisitor<void> {
  final Map<String, Field> fields = {};
  final Map<String, List<bool>> hasInternalAnnotations = {};

  final ignoreAnnotationTypeChecker =
      TypeChecker.fromRuntime(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) async {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (element.isFinal) {
      fields[element.name] = Field(
        hasLerp: _hasLerp(element),
        name: element.name,
        typeName: element.type.getDisplayString(withNullability: true),
      );
    }
  }

  bool _hasLerp(FieldElement field) {
    // ignore: deprecated_member_use
    final element = field.type.element2;

    if (element is! ClassElement) {
      return false;
    }

    for (final type in [
      element,
      ...element.allSupertypes
          .where((e) => !e.isDartCoreObject)
          // ignore: deprecated_member_use
          .map((e) => e.element2)
    ]) {
      for (final method in type.methods) {
        if (method.name == 'lerp' &&
            method.isStatic &&
            method.isPublic &&
            method.parameters.length == 3 &&
            method.parameters.last.type.isDartCoreDouble) {
          return true;
        }
      }
    }

    return false;
  }
}
