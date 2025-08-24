import 'dart:async';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../models/field_symbol.dart';
import '../models/generator_config.dart';
import 'code_generator.dart';

/// It's a Dart code generator that generates code for the `@ThemeExtensions`
/// annotation
class ThemeExtensionsGenerator extends GeneratorForAnnotation<ThemeExtensions> {
  ThemeExtensionsGenerator({required this.builderOptions});

  final BuilderOptions builderOptions;

  @override
  Future<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        'ThemeExtensions can only annotate classes',
        element: element,
        todo: 'Move @ThemeExtensions annotation above `class`',
      );
    }

    final classVisitor = _ClassVisitor();
    element.visitChildren2(classVisitor);

    final buildContextExtension = annotation
        .read('buildContextExtension')
        .boolValue;

    final contextAccessorName =
        annotation.read('contextAccessorName').literalValue as String?;

    final generatorConfig = GeneratorConfig(
      fields: classVisitor.fields,
      className: element.displayName,
      contextAccessorName: contextAccessorName,
      buildContextExtension: buildContextExtension,
    );

    const generator = CodeGenerator();
    final code = generator.generate(generatorConfig);

    return code;
  }
}

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class _ClassVisitor extends ElementVisitor2<void> {
  final Map<String, FieldSymbol> fields = {};
  final Map<String, List<bool>> hasInternalAnnotations = {};

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement2 element) {
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

  LerpInfo? _hasLerp(FieldElement2 field) {
    final element = field.type.element3;

    if (element is! ClassElement2) {
      return null;
    }

    final types = [
      element,
      ...element.allSupertypes
          .where((e) => !e.isDartCoreObject)
          .map((e) => e.element3),
    ];

    for (final type in types) {
      for (final method in type.methods2) {
        if (method case MethodElement2(displayName: 'lerp', isPublic: true)) {
          if (method.children2.last case FormalParameterElement(
            :final type,
          ) when type.isDartCoreDouble) {
            return (isStatic: method.isStatic);
          }
        }
      }
    }

    return null;
  }

  @override
  void visitClassElement(ClassElement2 element) {}

  @override
  void visitConstructorElement(ConstructorElement2 element) {}

  @override
  void visitEnumElement(EnumElement2 element) {}

  @override
  void visitExtensionElement(ExtensionElement2 element) {}

  @override
  void visitExtensionTypeElement(ExtensionTypeElement2 element) {}

  @override
  void visitFieldFormalParameterElement(FieldFormalParameterElement2 element) {}

  @override
  void visitFormalParameterElement(FormalParameterElement element) {}

  @override
  void visitGenericFunctionTypeElement(GenericFunctionTypeElement2 element) {}

  @override
  void visitGetterElement(GetterElement element) {}

  @override
  void visitLabelElement(LabelElement2 element) {}

  @override
  void visitLibraryElement(LibraryElement2 element) {}

  @override
  void visitLocalFunctionElement(LocalFunctionElement element) {}

  @override
  void visitLocalVariableElement(LocalVariableElement2 element) {}

  @override
  void visitMethodElement(MethodElement2 element) {}

  @override
  void visitMixinElement(MixinElement2 element) {}

  @override
  void visitMultiplyDefinedElement(MultiplyDefinedElement2 element) {}

  @override
  void visitPrefixElement(PrefixElement2 element) {}

  @override
  void visitSetterElement(SetterElement element) {}

  @override
  void visitSuperFormalParameterElement(SuperFormalParameterElement2 element) {}

  @override
  void visitTopLevelFunctionElement(TopLevelFunctionElement element) {}

  @override
  void visitTopLevelVariableElement(TopLevelVariableElement2 element) {}

  @override
  void visitTypeAliasElement(TypeAliasElement2 element) {}

  @override
  void visitTypeParameterElement(TypeParameterElement2 element) {}
}
