import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

extension type const LerpInfo._(MethodElement element) {
  /// Whether the lerp method is static.
  bool get isStatic => element.isStatic;

  /// Whether the lerp method returns a nullable type.
  bool get returnTypeIsNullable =>
      element.returnType.nullabilitySuffix == .question;
}

sealed class MergeInfo {
  const MergeInfo();

  bool get isStatic => this is MergeInfoStatic;
  bool get isInstance => this is MergeInfoInstance;
  bool get isNone => this is MergeInfoNone;
}

final class MergeInfoNone extends MergeInfo {
  const MergeInfoNone();
}

final class MergeInfoStatic extends MergeInfo {
  const MergeInfoStatic();
}

final class MergeInfoInstance extends MergeInfo {
  const MergeInfoInstance();
}

extension type FieldSymbol(FieldElement element) {
  /// The name of the field.
  String get name => element.displayName;

  /// The type of the field.
  DartType get _type => element.type;

  /// The display type of the field.
  String get displayType => _type.getDisplayString();

  /// The type of the field without nullability suffix.
  String get type =>
      isNullable ? displayType.replaceFirst('?', '') : displayType;

  /// Whether the field is nullable.
  bool get isNullable => _type.nullabilitySuffix == .question;

  bool get isDouble => _type.isDartCoreDouble;

  bool get isDuration => type == 'Duration';

  LerpInfo? get lerpInfo {
    final typeElement = _type.element;

    if (typeElement is! InterfaceElement) {
      return null;
    }

    final method = typeElement.getMethod('lerp');
    if (method == null || !method.isPublic) {
      return null;
    }

    // Check if the last parameter 't' is double
    if (!method.formalParameters.last.type.isDartCoreDouble) {
      return null;
    }

    return LerpInfo._(method);
  }

  MergeInfo get mergeInfo => _mergeInfo(_type);
}

MergeInfo _mergeInfo(DartType type) {
  final typeElement = type.element;

  if (typeElement is! ClassElement) {
    return const MergeInfoNone();
  }

  // Check if element or its supertypes have @ThemeGen annotation.
  // Using the annotation implies that the merge method exists, as it is
  // impossible to get information about the merge method during the build
  // phase.
  const themeGenChecker = TypeChecker.typeNamed(ThemeGen);
  if (themeGenChecker.hasAnnotationOfExact(typeElement)) {
    return const MergeInfoStatic();
  }

  final method = typeElement.getMethod('merge');
  if (method == null || !method.isPublic) {
    return const MergeInfoNone();
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

        if (method.formalParameters case [
          FormalParameterElement(type: final t1),
          FormalParameterElement(type: final t2),
        ] when isStatic && t1.getDisplayString() == t2.getDisplayString()) {
          return const MergeInfoStatic();
        }

        if (method.children case [
          FormalParameterElement(),
        ] when !isStatic) {
          return const MergeInfoInstance();
        }
      }
    }
  }

  throw StateError('Merge method not found');
}
