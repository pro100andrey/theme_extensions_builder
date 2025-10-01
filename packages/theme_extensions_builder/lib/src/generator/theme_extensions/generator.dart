// ignore_for_file: avoid_print

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/analysis.dart';
import '../../common/symbols.dart';
import '../../common/visitors.dart';
import '../../config/config.dart';
import 'code_builder.dart';

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

    final generatorConfig = ThemeExtensionsConfig(
      fields: classVisitor.fields,
      className: element.displayName,
      contextAccessorName: contextAccessorName,
      buildContextExtension: buildContextExtension,
      isDeprecatedMixin: isDeprecatedMixin,
    );

    const generator = ThemeExtensionsCodeBuilder();
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
        mergeInfo: null,
        name: element.displayName,
        type: resultType,
        isNullable: isNullable,
      );

      fields.add(symbol);
    }
  }
}
