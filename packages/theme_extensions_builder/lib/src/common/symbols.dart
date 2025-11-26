import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

final class Arg {
  const Arg({
    required this.name,
    required this.type,
    required this.isNullable,
  });

  final String name;
  final String type;
  final bool isNullable;
}

sealed class LerpMethod {
  const LerpMethod({required this.returnTypeIsNullable});
  final bool returnTypeIsNullable;
}

final class StaticLerpMethod extends LerpMethod {
  const StaticLerpMethod({
    required super.returnTypeIsNullable,
    required this.args,
  });

  final List<Arg> args;
}

final class InstanceLerpMethod extends LerpMethod {
  const InstanceLerpMethod({
    required super.returnTypeIsNullable,
    required this.args,
  });

  final List<Arg> args;
}

final class NoLerpMethod extends LerpMethod {
  const NoLerpMethod() : super(returnTypeIsNullable: false);
}

sealed class MergeMethod {
  const MergeMethod();
}

final class NoMergeMethod extends MergeMethod {
  const NoMergeMethod();
}

final class StaticMergeMethod extends MergeMethod {
  const StaticMergeMethod();
}

final class InstanceMergeMethod extends MergeMethod {
  const InstanceMergeMethod();
}

final class FieldSymbol {
  factory FieldSymbol.from(FieldElement element) => _fieldSymbol(element);

  FieldSymbol._({
    required this.name,
    required this.baseType,
    required this.isNullable,
    required this.isDouble,
    required this.isDuration,
    required this.merge,
    required this.lerp,
  });

  /// The name of the field.
  final String name;

  /// The base type name of the field without nullability suffix.
  final String baseType;

  /// True if the field type is nullable.
  final bool isNullable;

  /// True if the field type is double.
  final bool isDouble;

  /// True if the field type is Duration.
  final bool isDuration;

  /// Information about the merge method for the field type.
  final MergeMethod merge;

  /// Information about the lerp method for the field type.
  final LerpMethod lerp;
}

/// Creates a [FieldSymbol] from the given [element].
FieldSymbol _fieldSymbol(FieldElement element) {
  final name = element.displayName;
  final elementType = element.type;
  final isNullable = elementType.nullabilitySuffix == .question;
  final baseType = elementType.baseType;
  final isDouble = elementType.isDartCoreDouble;
  final isDuration = elementType.isDuration;

  return FieldSymbol._(
    name: name,
    baseType: baseType,
    isNullable: isNullable,
    isDouble: isDouble,
    isDuration: isDuration,
    merge: _mergeInfo(elementType),
    lerp: _lerpInfo(elementType),
  );
}

/// Gets information about the lerp method for the given [type].
LerpMethod _lerpInfo(DartType type) {
  final typeElement = type.element;

  if (typeElement is! ClassElement) {
    return const NoLerpMethod();
  }

  final method = typeElement.getMethod('lerp');
  if (method == null) {
    return const NoLerpMethod();
  }

  final params = method.formalParameters;

  if (params case [final p1, final p2, final p3]
      // Check for static lerp method
      // - should have three parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      when method.isStatic &&
          p3.type.isDartCoreDouble &&
          p1.type.baseType == p2.type.baseType) {
    return StaticLerpMethod(
      returnTypeIsNullable: method.returnType.hasNullableSuffix,
      args: _mapArgumentsSymbols(params),
    );
  } else if (params case [final p1, final p2]
      // Check for instance lerp method:
      // - should have only two parameters
      // - first parameter type should match the class type
      // - second parameter should be double
      when !method.isStatic &&
          p2.type.isDartCoreDouble &&
          p1.type.baseType == type.baseType) {
    return InstanceLerpMethod(
      returnTypeIsNullable: method.returnType.hasNullableSuffix,
      args: _mapArgumentsSymbols(params),
    );
  }

  throw StateError('Lerp method has invalid signature');
}

/// Maps a list of [parameters] to a list of [Arg] symbols.
List<Arg> _mapArgumentsSymbols(List<FormalParameterElement> parameters) =>
    parameters.map(_mapArgumentSymbol).toList(growable: false);

/// Creates an [Arg] from the given [parameter].
Arg _mapArgumentSymbol(FormalParameterElement parameter) {
  final name = parameter.displayName;
  final type = parameter.type.getDisplayString();
  final isNullable = parameter.type.nullabilitySuffix == .question;

  return Arg(
    name: name,
    type: type,
    isNullable: isNullable,
  );
}

MergeMethod _mergeInfo(DartType type) {
  final typeElement = type.element;

  if (typeElement is! ClassElement) {
    return const NoMergeMethod();
  }

  // Check if element or its supertypes have @ThemeGen annotation.
  // Using the annotation implies that the merge method exists, as it is
  // impossible to get information about the merge method during the build
  // phase.
  const themeGenChecker = TypeChecker.typeNamed(ThemeGen);
  if (themeGenChecker.hasAnnotationOfExact(typeElement)) {
    return const StaticMergeMethod();
  }

  final method = typeElement.getMethod('merge');
  if (method == null || !method.isPublic) {
    return const NoMergeMethod();
  }

  final params = method.formalParameters;

  if (params case [final p1, final p2]
      // Check for static merge method
      // - should have two parameters
      // - both parameters should have the same type as the class type
      when method.isStatic && p1.type.baseType == p2.type.baseType) {
    return const StaticMergeMethod();
  }

  if (params case [final p1]
      // Check for instance merge method:
      // - should have only one parameter
      // - parameter type should match the class type
      when !method.isStatic && p1.type.baseType == type.baseType) {
    return const InstanceMergeMethod();
  }

  throw StateError('Merge method not found');
}

extension DartTypeExtension on DartType {
  /// Returns the base type name without nullability suffix.
  String get baseType {
    final displayString = getDisplayString();
    final result = nullabilitySuffix == .question
        ? displayString.replaceFirst('?', '')
        : displayString;

    return result;
  }

  /// Returns true if the type has a nullable suffix.
  bool get hasNullableSuffix => nullabilitySuffix == .question;

  /// Returns true if the type is Duration.
  bool get isDuration => baseType == 'Duration';
}
