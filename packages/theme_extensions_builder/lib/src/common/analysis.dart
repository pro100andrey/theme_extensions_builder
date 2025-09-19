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

bool hasMerge(FieldElement field) {
  final element = field.type.element;

  if (element is! ClassElement) {
    return false;
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
        return true;
      }
    }
  }

  return false;
}
