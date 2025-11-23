import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'symbols.dart';

/// Checks if the [element] type has a `lerp` method.
///
/// Returns [LerpInfo] if a valid `lerp` method is found, otherwise returns
/// `null`.
///
/// The `lerp` method can be:
/// - Static: `static T lerp(T a, T b, double t)`
/// - Instance: `T lerp(T other, double t)`
LerpInfo? lerpInfo({required FieldElement element}) {
  final typeElement = element.type.element;

  if (typeElement is! ClassElement) {
    return null;
  }

  final types = [
    typeElement,
    ...typeElement.allSupertypes
        .where((e) => !e.isDartCoreObject)
        .map((e) => e.element),
  ];

  for (final type in types) {
    for (final method in type.methods) {
      // Check type is List<T> with T being a valid type for lerp.

      if (method case MethodElement(
        displayName: 'lerp',
        isPublic: true,
      )) {
        final length = method.children.length;
        final isStatic = method.isStatic;

        if (method.children.last case FormalParameterElement(:final type)
            when type.isDartCoreDouble && (length == 3 && isStatic) ||
                (length == 2 && !isStatic)) {
          final nullableArgs = isStatic
              ? method.children
                    .whereType<FormalParameterElement>()
                    .take(2)
                    .any((e) => e.type.nullabilitySuffix.name != 'none')
              : method.children
                    .whereType<FormalParameterElement>()
                    .take(1)
                    .any((e) => e.type.nullabilitySuffix.name != 'none');

          return (
            isStatic: isStatic,
            nullableArgs: nullableArgs,
            methodName: method.displayName,
          );
        }
      }
    }
  }

  return null;
}

/// Checks if the [element] type has a `merge` method.
///
/// Returns [MergeInfo] if a valid `merge` method is found, otherwise returns
/// `null`.
///
/// The `merge` method can be:
/// - Static: `static T merge(T a, T b)`
/// - Instance: `T merge(T other)`
///
/// Also checks if the class is annotated with `@ThemeGen`, which implies
/// the existence of a `merge` method.
MergeInfo? mergeInfo({required FieldElement element}) {
  final typeElement = element.type.element;

  if (typeElement is! ClassElement) {
    return null;
  }

  // Check if element or its supertypes have @ThemeGen annotation.
  // Using the annotation implies that the merge method exists, as it is
  // impossible to get information about the merge method during the build
  // phase.
  const themeGenChecker = TypeChecker.typeNamed(ThemeGen);
  if (themeGenChecker.hasAnnotationOfExact(element)) {
    return (isStatic: false);
  }

  final types = [
    typeElement,
    ...typeElement.allSupertypes
        .where((e) => !e.isDartCoreObject)
        .map((e) => e.element),
  ];

  for (final type in types) {
    for (final method in type.methods) {
      if (method case MethodElement(displayName: 'merge', isPublic: true)) {
        final isStatic = method.isStatic;

        if (method.children case [
          FormalParameterElement(type: final t1),
          FormalParameterElement(type: final t2),
        ] when isStatic && t1.getDisplayString() == t2.getDisplayString()) {
          return (isStatic: isStatic);
        }

        if (method.children case [
          FormalParameterElement(),
        ] when !isStatic) {
          return (isStatic: isStatic);
        }
      }
    }
  }
  return null;
}

/// Gets the names of mixins applied to the given [element].
List<String> getMixinsNames({required ClassElement element}) {
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
    throw StateError(
      'Mixin clause is missing for class ${element.displayName}. '
      'Try adding "with _\$${element.displayName}" to the class declaration.',
    );
  }

  final result = withClause.mixinTypes
      .map((e) => e.name.lexeme)
      .toList(growable: false);

  return result;
}
