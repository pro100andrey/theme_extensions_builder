import 'dart:async';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../model/build_context_config.dart';
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
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement2 || element is Enum) {
      throw InvalidGenerationSourceError(
        'ThemeExtensions can only annotate classes',
        element: element,
        todo: 'Move @ThemeExtensions annotation above `class`',
      );
    }

    final classVisitor = _ClassVisitor();
    element.visitChildren2(classVisitor);

    final buildContext = annotation.read('buildContextExtension').boolValue;

    final generatorBuffer = StringBuffer()
      ..write(
        ThemeMixinTemplate(
          ThemeMixinConfig(
            fields: classVisitor.fields,
            className: element.displayName,
          ),
        ),
      );

    if (buildContext) {
      generatorBuffer.write(
        BuildContextTemplate(
          BuildContextConfig(className: element.displayName),
        ),
      );
    }

    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestShortStyleLanguageVersion,
    );

    final code = generatorBuffer.toString();

    return formatter.format(code);
  }
}

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class _ClassVisitor extends ElementVisitor2<void> {
  final Map<String, FieldSymbol> fields = {};
  final Map<String, List<bool>> hasInternalAnnotations = {};

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  Future<void> visitFieldElement(FieldElement2 element) async {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (element.isFinal) {
      fields[element.displayName] = FieldSymbol(
        lerpInfo: _hasLerp(element),
        name: element.displayName,
        type: element.type.getDisplayString(),
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
