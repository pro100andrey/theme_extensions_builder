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

class _ClassVisitor extends SimpleElementVisitor {
  final Map<String, Field> fields = {};
  final Map<String, List<bool>> hasInternalAnnotations = {};

  final ignoreAnnotationTypeChecker =
      TypeChecker.fromRuntime(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (element.isFinal) {
      fields[element.name] = Field(
        name: element.name,
        typeName: element.type.getDisplayString(withNullability: true),
      );
    }
  }
}
