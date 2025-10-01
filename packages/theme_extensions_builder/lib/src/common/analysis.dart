import 'package:analyzer/dart/element/element.dart';

import 'symbols.dart';

LerpInfo? hasLerp(FieldElement field) {
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

          return (isStatic: isStatic, nullableArgs: nullableArgs);
        }
      }
    }
  }

  return null;
}

MergeInfo? hasMerge(FieldElement field) {
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
