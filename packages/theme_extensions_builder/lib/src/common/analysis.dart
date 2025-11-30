/// @docImport 'fields_visitor_config.dart';

library;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
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
/// The [config] parameter controls what information should be collected:
/// - When [FieldsVisitorConfig.includeLerpLookup] is `false`, lerp method
///   lookups are skipped
/// - When [FieldsVisitorConfig.includeMergeLookup] is `false`, merge method
///   lookups are skipped
///
/// Skipping unnecessary lookups can significantly improve performance.
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
    lerp: config.includeLerpLookup
        ? _lerpInfo(elementType, element)
        : const NoLerp(),
  );
}

/// Gets information about the lerp method for the given [type].
///
/// This can improve performance when lerp details aren't needed.
LerpInfo _lerpInfo(DartType type, FieldElement fieldElement) {
  final typeElement = type.element;

  if (typeElement is! InterfaceElement) {
    return const NoLerp();
  }

  final method = _lookupMethod(typeElement, 'lerp');

  if (method == null) {
    return const NoLerp();
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
    return StaticLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      args: _mapArgs(params),
    );
  } else if (params case [final p1, final p2]
      // Check for instance lerp method:
      // - should have only two parameters
      // - first parameter type should match the class type
      // - second parameter should be double
      when !method.isStatic &&
          p2.type.isDartCoreDouble &&
          _checkSubtype(p1, type)) {
    return InstanceLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      args: _mapArgs(params),
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

/// Maps a list of [parameters] to a list of [ParameterInfo] symbols.
List<ParameterInfo> _mapArgs(List<FormalParameterElement> parameters) =>
    parameters.map(_mapArg).toList(growable: false);

/// Creates an [ParameterInfo] from the given [parameter].
ParameterInfo _mapArg(FormalParameterElement parameter) {
  final name = parameter.displayName;
  final type = parameter.type.getDisplayString();
  final isNullable = parameter.type.nullabilitySuffix == .question;

  return ParameterInfo(
    name: name,
    type: type,
    isNullable: isNullable,
  );
}

/// Cache for method lookups to avoid repeated expensive lookups.
/// Using Expando to avoid memory leaks - entries are automatically removed
/// when InterfaceElement is garbage collected.
final _methodCache = Expando<Map<String, MethodElement?>>('method_cache');

/// Looks up a method with the given [name] in the [typeElement].
/// If the method is not found directly on the type, it looks up
/// inherited methods as well.
/// Results are cached to avoid repeated expensive lookups.
MethodElement? _lookupMethod(
  InterfaceElement typeElement,
  String name,
) {
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
/// This can improve performance when merge details aren't needed.
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
    return const InstanceMerge();
  }

  final method = _lookupMethod(typeElement, 'merge');
  if (method == null) {
    return const NoMerge();
  }

  final params = method.formalParameters;

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
    return const InstanceMerge();
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

/// Gets the names of mixins applied to the given [element].
List<String> getMixinsNames({required ClassElement element}) {
  final library = element.library.session.getParsedLibraryByElement(
    element.library,
  );

  if (library is! ParsedLibraryResult) {
    throw StateError('Could not get parsed library for element');
  }

  ClassDeclaration? classDeclaration;

  outerLoop:
  for (final unit in library.units) {
    for (final decl in unit.unit.declarations) {
      if (decl is ClassDeclaration && decl.name.lexeme == element.displayName) {
        classDeclaration = decl;
        break outerLoop;
      }
    }
  }

  final withClause = classDeclaration?.withClause;

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
