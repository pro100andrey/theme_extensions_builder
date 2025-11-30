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

  @override
  String toString() => 'Arg(name: $name, type: $type, isNullable: $isNullable)';
}

sealed class LerpMethod {
  const LerpMethod();
}

final class StaticLerpMethod extends LerpMethod {
  const StaticLerpMethod({
    required this.optionalResult,
    required this.args,
  });

  final List<Arg> args;
  final bool optionalResult;

  bool get isNullableSignature =>
      optionalResult && args[0].isNullable && args[1].isNullable;

  @override
  String toString() =>
      'StaticLerpMethod(optionalResult: $optionalResult, args: $args)';
}

final class InstanceLerpMethod extends LerpMethod {
  const InstanceLerpMethod({
    required this.optionalResult,
    required this.args,
  });

  final List<Arg> args;
  final bool optionalResult;

  bool get isNullableSignature => optionalResult && args[0].isNullable;

  @override
  String toString() =>
      'InstanceLerpMethod(optionalResult: $optionalResult, args: $args)';
}

final class NoLerpMethod extends LerpMethod {
  const NoLerpMethod();

  @override
  String toString() => 'NoLerpMethod()';
}

sealed class MergeMethod {
  const MergeMethod();

  @override
  String toString() => 'MergeMethod()';
}

final class NoMergeMethod extends MergeMethod {
  const NoMergeMethod();

  @override
  String toString() => 'NoMergeMethod()';
}

final class StaticMergeMethod extends MergeMethod {
  const StaticMergeMethod();

  @override
  String toString() => 'StaticMergeMethod()';
}

final class InstanceMergeMethod extends MergeMethod {
  const InstanceMergeMethod();

  @override
  String toString() => 'InstanceMergeMethod()';
}

final class FieldSymbol {
  factory FieldSymbol.from(FieldElement element) => _fieldSymbol(element);

  FieldSymbol._({
    required this.name,
    required this.baseType,
    required this.optional,
    required this.isDouble,
    required this.isDuration,
    required this.merge,
    required this.lerp,
    required this.isStatic,
  });

  /// The name of the field.
  final String name;

  /// The base type name of the field without nullability suffix.
  final String baseType;

  /// True if the field type is nullable.
  final bool optional;

  /// True if the field type is double.
  final bool isDouble;

  /// True if the field type is Duration.
  final bool isDuration;

  /// Information about the merge method for the field type.
  final MergeMethod merge;

  /// Information about the lerp method for the field type.
  final LerpMethod lerp;

  /// True if the field is static.
  final bool isStatic;

  @override
  String toString() =>
      'FieldSymbol(name: $name, '
      'baseType: $baseType, '
      'optional: $optional, '
      'isDouble: $isDouble, '
      'isDuration: $isDuration, '
      'isStatic: $isStatic, '
      'merge: $merge, '
      'lerp: $lerp)';
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
    optional: isNullable,
    isDouble: isDouble,
    isDuration: isDuration,
    isStatic: element.isStatic,
    merge: _mergeInfo(elementType),
    lerp: _lerpInfo(elementType, element),
  );
}

/// Gets information about the lerp method for the given [type].
LerpMethod _lerpInfo(DartType type, FieldElement fieldElement) {
  final typeElement = type.element;

  if (typeElement is! InterfaceElement) {
    return const NoLerpMethod();
  }

  final method = _lookupMethod(typeElement, 'lerp');

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
          _checkSubtype(p1, type) &&
          _checkSubtype(p2, type)) {
    return StaticLerpMethod(
      optionalResult: method.returnType.hasNullableSuffix,
      args: _mapArgumentsSymbols(params),
    );
  } else if (params case [final p1, final p2]
      // Check for instance lerp method:
      // - should have only two parameters
      // - first parameter type should match the class type
      // - second parameter should be double
      when !method.isStatic &&
          p2.type.isDartCoreDouble &&
          _checkSubtype(p1, type)) {
    return InstanceLerpMethod(
      optionalResult: method.returnType.hasNullableSuffix,
      args: _mapArgumentsSymbols(params),
    );
  }

  throw StateError(
    'Lerp method has invalid signature for type '
    '${type.getDisplayString()} of field ${fieldElement.name} '
    'method: ${method.displayName} isStatic: ${method.isStatic} ',
  );
}

bool _checkSubtype(
  FormalParameterElement param,
  DartType type,
) {
  final typeElement = type.element;
  if (typeElement is! InterfaceElement) {
    return false;
  }

  final paramTypeElement = param.type.element;
  if (paramTypeElement is! InterfaceElement) {
    return false;
  }

  final supertypeInstance = type.asInstanceOf(paramTypeElement);
  if (supertypeInstance == null) {
    return false;
  }

  final typeSystem = typeElement.library.typeSystem;
  final nonNullType = typeSystem.promoteToNonNull(type);

  return typeSystem.isSubtypeOf(nonNullType, supertypeInstance);
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

/// Cache for method lookups to avoid repeated expensive lookups
final _methodCache = <InterfaceElement, Map<String, MethodElement?>>{};

/// Looks up a method with the given [name] in the [typeElement].
/// If the method is not found directly on the type, it looks up
/// inherited methods as well.
/// Results are cached to avoid repeated expensive lookups.
MethodElement? _lookupMethod(
  InterfaceElement typeElement,
  String name,
) {
  final cache = _methodCache.putIfAbsent(typeElement, () => {});

  if (cache.containsKey(name)) {
    return cache[name];
  }

  final method = typeElement.getMethod(name);

  if (method != null) {
    cache[name] = method;
    return method;
  }

  final inheritedMethod = typeElement.lookUpInheritedMethod(
    methodName: name,
    library: typeElement.library,
  );

  cache[name] = inheritedMethod;
  return inheritedMethod;
}

MergeMethod _mergeInfo(DartType type) {
  final typeElement = type.element;

  if (typeElement is! InterfaceElement) {
    return const NoMergeMethod();
  }

  // Check if element or its supertypes have @ThemeGen annotation.
  // Using the annotation implies that the merge method exists, as it is
  // impossible to get information about the merge method during the build
  // phase.
  const themeGenChecker = TypeChecker.typeNamed(ThemeGen);
  if (themeGenChecker.hasAnnotationOfExact(typeElement)) {
    return const InstanceMergeMethod();
  }

  final method = _lookupMethod(typeElement, 'merge');
  if (method == null) {
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
        ? displayString.replaceFirst(RegExp(r'\?$'), '')
        : displayString;

    return result;
  }

  /// Returns true if the type has a nullable suffix.
  bool get hasNullableSuffix => nullabilitySuffix == .question;

  /// Returns true if the type is Duration.
  bool get isDuration => baseType == 'Duration';
}
