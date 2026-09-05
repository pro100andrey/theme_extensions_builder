/// @docImport 'fields_visitor_config.dart';

library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'fields_visitor_config.dart';
import 'symbols/field_info.dart';
import 'symbols/lerp_info.dart';
import 'symbols/merge_info.dart';
import 'symbols/parameter_info.dart';

/// Creates a [FieldInfo] from the given [element].
///
/// When [FieldsVisitorConfig.includeMergeLookup] is `false`, the merge method
/// lookup is skipped, which speeds up generators that don't emit `merge`.
FieldInfo fieldSymbol(
  FieldElement element, {
  FieldsVisitorConfig config = const FieldsVisitorConfig(),
}) {
  final name = element.displayName;
  final elementType = element.type;
  final isNullable = elementType.nullabilitySuffix == .question;
  final baseType = elementType.baseType;
  final isDouble = elementType.isDartCoreDouble;
  final isDuration = elementType.isDuration;

  return FieldInfo(
    name: name,
    typeName: baseType,
    isNullable: isNullable,
    isDouble: isDouble,
    isDuration: isDuration,
    isStatic: element.isStatic,
    merge: config.includeMergeLookup
        ? _mergeInfo(elementType)
        : const NoMerge(),
    lerp: _lerpInfo(elementType, element),
  );
}

/// Gets information about the lerp method for the given [type].
///
/// Returns information about static or instance lerp methods, or [NoLerp] if
/// the type is not an interface, has no lerp method, or has one whose
/// signature we cannot call. A type is free to declare an unrelated `lerp`
/// method, so an unknown signature falls back to [NoLerp] rather than failing
/// the build.
///
/// Throws [InvalidGenerationSourceError] for a `WidgetStateProperty` field
/// with a non-nullable generic, which is a mistake we can point at.
LerpInfo _lerpInfo(DartType type, FieldElement fieldElement) {
  final typeElement = type.element;

  if (typeElement is! InterfaceElement) {
    return const NoLerp();
  }

  final method = _lookupMethod(typeElement, 'lerp');

  if (method == null) {
    return const NoLerp();
  }

  // Optional and named parameters take no part in the signature check: a
  // method stays callable the way we expect when it has extra defaulted
  // parameters.
  final params = method.formalParameters
      .where((p) => p.isRequiredPositional)
      .toList(growable: false);

  // WidgetStateProperty and WidgetStateColor use a different signature for
  // lerp. Check for 4-parameter version first, as WidgetStateProperty has
  //both 3 and 4 parameter versions
  if (params case [final p1, final p2, final p3, final p4]
      // Check for static lerp method with 4 parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      // - fourth parameter is a lerp function for the inner type
      when type is InterfaceType &&
          type.typeArguments.length == 1 &&
          method.isStatic &&
          p3.type.isDartCoreDouble &&
          _checkSubtype(p1, type) &&
          _checkSubtype(p2, type)) {
    // Check p4 is a function type having signature:
    // R Function(T? a, T? b, double t)
    if (p4.type case FunctionType(
      formalParameters: [final f1, final f2, final f3],
    )) {
      // For generic functions like T? Function(T?, T?, double), we can't easily
      // check exact type compatibility without type substitution.
      // Just verify the structure: 3 parameters where the third is double.
      // The first two parameters should be nullable to match the lerp pattern.
      final isValidSignature =
          f1.type.nullabilitySuffix == .question &&
          f2.type.nullabilitySuffix == .question &&
          f3.type.isDartCoreDouble;

      if (!isValidSignature) {
        // Unsupported lerp function signature
        return const NoLerp();
      }
    }

    final innerType = type.typeArguments.single;

    // Check that the generic type is nullable
    if (!innerType.hasNullableSuffix) {
      final typeName = type.getDisplayString();
      final innerTypeName = innerType.getDisplayString();
      final baseName = type.element.displayName;

      throw InvalidGenerationSourceError(
        '$baseName must have a nullable generic type, because '
        '$baseName.lerp requires a lerp function with nullable parameters. '
        'Found: $typeName',
        element: fieldElement,
        todo:
            'Change the type of ${fieldElement.displayName} to '
            '$baseName<$innerTypeName?>',
      );
    }

    final baseTypeName = type.element.displayName;
    final genericType = innerType.baseType;

    return WidgetStatePropertyLerp(
      baseTypeName: baseTypeName,
      genericType: genericType,
      isNullableGeneric: innerType.hasNullableSuffix,
    );
  }

  if (params case [final p1, final p2, final p3]
      // Check for static lerp method
      // - should have three parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      when method.isStatic &&
          p3.type.isDartCoreDouble &&
          _checkSubtype(p1, type) &&
          _checkSubtype(p2, type)) {
    final args = _mapArgs(params);

    return StaticLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      args: args,
    );
  } else if (params case [final p1, final p2]
      // Check for instance lerp method:
      // - should have only two parameters
      // - first parameter type should match the class type
      // - second parameter should be double
      when !method.isStatic &&
          p2.type.isDartCoreDouble &&
          _checkSubtype(p1, type)) {
    final args = _mapArgs(params);

    return InstanceLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      args: args,
    );
  }

  // The type declares a `lerp` we don't know how to call.
  return const NoLerp();
}

/// Checks if a parameter type is a subtype of the given [type].
///
/// This function performs a type compatibility check between a formal parameter
/// and a target type. It handles nullability by promoting the type to non-null
/// before checking subtype relationships.
///
/// Returns `true` if:
/// - Both [FormalParameterElement.type] and [type] are interface types
/// - [type] can be used as an instance of the parameter's type
/// - The non-null version of [type] is a subtype of that instance
///
/// Returns `false` if either type is not an interface type or if the subtype
/// relationship doesn't hold.
///
/// This is primarily used to validate lerp method signatures, ensuring that
/// parameters accept the correct types for interpolation.
bool _checkSubtype(FormalParameterElement param, DartType type) {
  final typeElement = type.element;
  if (typeElement is! InterfaceElement) {
    return false;
  }

  final parameterType = param.type;

  final paramTypeElement = parameterType.element;
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

/// Maps a list of [parameters] to a list of [ParameterInfo] symbols.
List<ParameterInfo> _mapArgs(List<FormalParameterElement> parameters) =>
    parameters.map(_mapArg).toList(growable: false);

/// Creates an [ParameterInfo] from the given [parameter].
ParameterInfo _mapArg(FormalParameterElement parameter) {
  final name = parameter.displayName;
  final type = parameter.type.getDisplayString();
  final isNullable = parameter.type.nullabilitySuffix == .question;

  return ParameterInfo(name: name, type: type, isNullable: isNullable);
}

/// Cache for method lookups to avoid repeated expensive lookups.
/// Using Expando to avoid memory leaks - entries are automatically removed
/// when InterfaceElement is garbage collected.
final _methodCache = Expando<Map<String, MethodElement?>>('method_cache');

/// Looks up a method with the given [name] in the [typeElement].
/// If the method is not found directly on the type, it looks up
/// inherited methods as well.
/// Results are cached to avoid repeated expensive lookups.
MethodElement? _lookupMethod(InterfaceElement typeElement, String name) {
  var cache = _methodCache[typeElement];
  if (cache == null) {
    cache = <String, MethodElement?>{};
    _methodCache[typeElement] = cache;
  }

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

/// Gets information about the merge method for the given [type].
///
/// Returns [NoMerge] when the type is not an interface, has no merge method,
/// or declares one whose signature we cannot call.
MergeInfo _mergeInfo(DartType type) {
  final typeElement = type.element;

  if (typeElement is! InterfaceElement) {
    return const NoMerge();
  }

  // Check if element or its supertypes have @ThemeGen annotation.
  // Using the annotation implies that the merge method exists, as it is
  // impossible to get information about the merge method during the build
  // phase.
  const themeGenChecker = TypeChecker.typeNamed(ThemeGen);
  if (themeGenChecker.hasAnnotationOfExact(typeElement)) {
    // The generated merge method takes a nullable argument.
    return const InstanceMerge();
  }

  final method = _lookupMethod(typeElement, 'merge');
  if (method == null) {
    return const NoMerge();
  }

  final params = method.formalParameters
      .where((p) => p.isRequiredPositional)
      .toList(growable: false);

  if (params case [final p1, final p2]
      // Check for static merge method
      // - should have two parameters
      // - both parameters should have the same type as the class type
      when method.isStatic && p1.type.baseType == p2.type.baseType) {
    return const StaticMerge();
  }

  if (params case [final p1]
      // Check for instance merge method:
      // - should have only one parameter
      // - parameter type should match the class type
      when !method.isStatic && p1.type.baseType == type.baseType) {
    return InstanceMerge(isNullableParameter: p1.type.hasNullableSuffix);
  }

  // The type declares a `merge` we don't know how to call.
  return const NoMerge();
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

  /// Returns true if the type is `Duration` from `dart:core`.
  bool get isDuration {
    final typeElement = element;

    return typeElement != null &&
        typeElement.displayName == 'Duration' &&
        (typeElement.library?.isDartCore ?? false);
  }
}
