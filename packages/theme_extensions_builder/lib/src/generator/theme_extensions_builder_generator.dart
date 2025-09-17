// ignore_for_file: avoid_print

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../models/generator_config.dart';
import '../models/symbols.dart';
import 'code_generator.dart';

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
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'ThemeExtensions can only annotate classes',
        element: element,
        todo: 'Move @ThemeExtensions annotation above `class`',
      );
    }

    final mixins = _getMixinsNames(element);
    final isDeprecatedMixin = mixins.any(
      (m) => m.contains(r'_$ThemeExtensionMixin'),
    );

    final classVisitor = _ClassVisitor();
    element.visitChildren(classVisitor);

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
      isDeprecatedMixin: isDeprecatedMixin,
    );

    const generator = CodeGenerator();
    final code = generator.generate(generatorConfig);

    return code;
  }

  List<String> _getMixinsNames(ClassElement element) {
    final library = element.library.session.getParsedLibraryByElement(
      element.library,
    );

    if (library is! ParsedLibraryResult) {
      throw StateError('Could not get parsed library for element');
    }

    final compilationUnit = library.units.single.unit;

    final classDeclaration = compilationUnit.declarations.firstWhere(
      (decl) =>
          decl is ClassDeclaration && decl.name.lexeme == element.displayName,
    );

    if (classDeclaration is! ClassDeclaration) {
      throw StateError('Class declaration not found ');
    }

    final withClause = classDeclaration.withClause;

    if (withClause == null) {
      throw StateError('Mixin clause is missing');
    }

    final result = withClause.mixinTypes
        .map((e) => e.name.lexeme)
        .toList(growable: false);

    return result;
  }
}

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class _ClassVisitor extends ElementVisitor2<void> {
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

  @override
  void visitClassElement(ClassElement element) {}

  @override
  void visitConstructorElement(ConstructorElement element) {}

  @override
  void visitEnumElement(EnumElement element) {}

  @override
  void visitExtensionElement(ExtensionElement element) {}

  @override
  void visitExtensionTypeElement(ExtensionTypeElement element) {}

  @override
  void visitFieldFormalParameterElement(FieldFormalParameterElement element) {}

  @override
  void visitFormalParameterElement(FormalParameterElement element) {}

  @override
  void visitGenericFunctionTypeElement(GenericFunctionTypeElement element) {}

  @override
  void visitGetterElement(GetterElement element) {}

  @override
  void visitLabelElement(LabelElement element) {}

  @override
  void visitLibraryElement(LibraryElement element) {}

  @override
  void visitLocalFunctionElement(LocalFunctionElement element) {}

  @override
  void visitLocalVariableElement(LocalVariableElement element) {}

  @override
  void visitMethodElement(MethodElement element) {}

  @override
  void visitMixinElement(MixinElement element) {}

  @override
  void visitMultiplyDefinedElement(MultiplyDefinedElement element) {}

  @override
  void visitPrefixElement(PrefixElement element) {}

  @override
  void visitSetterElement(SetterElement element) {}

  @override
  void visitSuperFormalParameterElement(SuperFormalParameterElement element) {}

  @override
  void visitTopLevelFunctionElement(TopLevelFunctionElement element) {}

  @override
  void visitTopLevelVariableElement(TopLevelVariableElement element) {}

  @override
  void visitTypeAliasElement(TypeAliasElement element) {}

  @override
  void visitTypeParameterElement(TypeParameterElement element) {}
}
