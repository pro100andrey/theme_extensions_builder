/// @docImport 'fields_visitor_config.dart';

library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
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

  // A static field is dropped by `BaseConfig.filteredFields`, so looking up
  // how to interpolate or merge it would only produce noise, or fail the
  // build over a field that is never emitted.
  if (element.isStatic) {
    return FieldInfo(
      name: name,
      typeName: baseType,
      isNullable: isNullable,
      isDouble: isDouble,
      isDuration: isDuration,
      isStatic: true,
      merge: const NoMerge(),
      lerp: const NoLerp(),
    );
  }

  return FieldInfo(
    name: name,
    typeName: baseType,
    isNullable: isNullable,
    isDouble: isDouble,
    isDuration: isDuration,
    isStatic: element.isStatic,
    merge: config.includeMergeLookup
        ? _mergeInfo(elementType, element)
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
  if (type is! InterfaceType) {
    return const NoLerp();
  }

  final method = _lookupMethod(type, 'lerp');

  if (method == null) {
    return const NoLerp();
  }

  // A required named parameter cannot be filled in by the generated call.
  if (method.formalParameters.any((p) => p.isRequiredNamed)) {
    _warnUnsupported('lerp', type, fieldElement);

    return const NoLerp();
  }

  // Optional parameters take no part in the signature check: a method stays
  // callable the way we expect when it has extra defaulted parameters.
  final params = method.formalParameters
      .where((p) => p.isRequiredPositional)
      .toList(growable: false);

  // A generic method's parameter types mention its own type parameters, which
  // can't be substituted here, so those are matched on the declaring class
  // only.
  final strictSignature = method.typeParameters.isEmpty;

  // WidgetStateProperty and WidgetStateColor use a different signature for
  // lerp. Check for the 4-parameter version first, as WidgetStateProperty has
  // both 3 and 4 parameter versions
  if (params case [final p1, final p2, final p3, final p4]
      // Check for static lerp method with 4 parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      // - fourth parameter is a lerp function for the inner type
      when method.isStatic &&
          p3.type.isDartCoreDouble &&
          _checkSubtype(p1, type, strict: strictSignature) &&
          _checkSubtype(p2, type, strict: strictSignature)) {
    // The fourth parameter has to be a lerp function itself, with the
    // signature `R Function(T? a, T? b, double t)`.
    //
    // For generic functions like T? Function(T?, T?, double) we can't easily
    // check exact type compatibility without type substitution, so only the
    // structure is verified.
    if (p4.type
        case FunctionType(
          formalParameters: [final f1, final f2, final f3],
        )
        when f1.type.hasNullableSuffix &&
            f2.type.hasNullableSuffix &&
            f3.type.isDartCoreDouble) {
      // The generic is read from the declaring type rather than from the field
      // type, so that a non-generic subclass such as `WidgetStateColor`
      // resolves to `WidgetStateProperty<Color>`.
      final declaringElement = p1.type.element;
      final declaringType = declaringElement is InterfaceElement
          ? type.asInstanceOf(declaringElement)
          : null;

      if (declaringType == null || declaringType.typeArguments.length != 1) {
        _warnUnsupported('lerp', type, fieldElement);

        return const NoLerp();
      }

      final baseTypeName = declaringType.element.displayName;
      final innerType = declaringType.typeArguments.single;

      // Check that the generic type is nullable
      if (!innerType.hasNullableSuffix) {
        final typeName = type.getDisplayString();
        final innerTypeName = innerType.getDisplayString();

        throw InvalidGenerationSourceError(
          '$baseTypeName must have a nullable generic type, because '
          '$baseTypeName.lerp requires a lerp function with nullable '
          'parameters. Found: $typeName',
          element: fieldElement,
          todo:
              'Change the type of ${fieldElement.displayName} to '
              '$baseTypeName<$innerTypeName?>',
        );
      }

      final genericIsDouble = innerType.isDartCoreDouble;
      final genericIsDuration = innerType.isDuration;

      // Anything else is interpolated by a static lerp on the generic itself,
      // which `WidgetStateProperty.lerp` calls with nullable arguments.
      if (!genericIsDouble && !genericIsDuration) {
        final innerLerp = _lerpInfo(innerType, fieldElement);

        if (innerLerp is! StaticLerp ||
            !innerLerp.optionalResult ||
            !innerLerp.isNullableParameter) {
          _warnUnsupported('lerp', innerType, fieldElement);

          return const NoLerp();
        }
      }

      return WidgetStatePropertyLerp(
        baseTypeName: baseTypeName,
        genericType: innerType.baseType,
        isNullableGeneric: innerType.hasNullableSuffix,
        genericIsDouble: genericIsDouble,
        genericIsDuration: genericIsDuration,
      );
    }

    // A four parameter lerp whose last parameter isn't a lerp function is not
    // something we know how to call.
    _warnUnsupported('lerp', type, fieldElement);

    return const NoLerp();
  }

  if (params case [final p1, final p2, final p3]
      // Check for static lerp method
      // - should have three parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      when method.isStatic &&
          p3.type.isDartCoreDouble &&
          _checkSubtype(p1, type, strict: strictSignature) &&
          _checkSubtype(p2, type, strict: strictSignature)) {
    if (!_isUsableAs(method.returnType, type, type)) {
      _warnUnsupported('lerp', type, fieldElement);

      return const NoLerp();
    }

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
          _checkSubtype(p1, type, strict: strictSignature)) {
    // A method declared on a supertype returns that supertype, which the
    // generated code casts back to the field type. Anything else is not a
    // result we can use.
    final needsCast = !_isUsableAs(method.returnType, type, type);

    if (needsCast && !_isUsableAs(type, method.returnType, type)) {
      _warnUnsupported('lerp', type, fieldElement);

      return const NoLerp();
    }

    final args = _mapArgs(params);

    return InstanceLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      args: args,
      needsCast: needsCast,
    );
  }

  // The type declares a `lerp` we don't know how to call.
  _warnUnsupported('lerp', type, fieldElement);

  return const NoLerp();
}

/// Reports a [methodName] method that exists but cannot be called.
///
/// A type is free to declare an unrelated `lerp` or `merge`, so this is not an
/// error, but it is worth saying out loud: without the warning "the type has
/// no such method" and "the method is not one I can call" look the same in the
/// generated code.
void _warnUnsupported(
  String methodName,
  DartType type,
  FieldElement fieldElement,
) {
  final fallback = methodName == 'lerp'
      ? 'switches over at t = 0.5 instead of being interpolated'
      : 'is overwritten instead of being merged';

  log.warning(
    'The `$methodName` method of ${type.baseType} has an '
    'unsupported signature, so the field `${fieldElement.displayName}` '
    '$fallback.',
  );
}

/// Checks that a value of [type] can be passed to [param].
///
/// Nullability is ignored on both sides: a lerp method taking `T?` accepts a
/// non-nullable field, and a nullable field is null checked at the call site.
///
/// When [strict] is `true` the parameter type is compared as written, type
/// arguments included. It has to be `false` for a generic method, whose
/// parameter type mentions type parameters we cannot substitute here; only
/// the declaring class is checked then.
///
/// Returns `false` if either type is not an interface type or if the subtype
/// relationship doesn't hold.
bool _checkSubtype(
  FormalParameterElement param,
  DartType type, {
  required bool strict,
}) {
  final typeElement = type.element;
  if (typeElement is! InterfaceElement) {
    return false;
  }

  final parameterType = param.type;

  final paramTypeElement = parameterType.element;
  if (paramTypeElement is! InterfaceElement) {
    return false;
  }

  final typeSystem = typeElement.library.typeSystem;
  final nonNullType = typeSystem.promoteToNonNull(type);

  if (strict) {
    return typeSystem.isSubtypeOf(
      nonNullType,
      typeSystem.promoteToNonNull(parameterType),
    );
  }

  final supertypeInstance = type.asInstanceOf(paramTypeElement);
  if (supertypeInstance == null) {
    return false;
  }

  return typeSystem.isSubtypeOf(nonNullType, supertypeInstance);
}

/// Checks that a value of [subtype] can be used where [supertype] is expected.
///
/// Nullability is ignored on both sides: a `T? merge(T other)` is still a
/// merge method, the generated code just has to cope with the null.
bool _isUsableAs(DartType subtype, DartType supertype, InterfaceType context) {
  final typeSystem = context.element.library.typeSystem;

  return typeSystem.isSubtypeOf(
    typeSystem.promoteToNonNull(subtype),
    typeSystem.promoteToNonNull(supertype),
  );
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

/// Cache for static method lookups to avoid repeated expensive lookups.
///
/// Only the static lookup is cached: it reads the declaration off the element,
/// which is the same for every instantiation. The instance lookup goes through
/// the [InterfaceType] so that type arguments are substituted, and its result
/// differs between `Box<int>` and `Box<String>`.
///
/// Using Expando to avoid memory leaks - entries are automatically removed
/// when InterfaceElement is garbage collected.
final _staticMethodCache = Expando<Map<String, MethodElement?>>('method_cache');

/// Looks up a method with the given [name] on [type].
///
/// Instance methods are resolved against the instantiated type, including
/// inherited ones, so their parameter and return types have the type
/// arguments of [type] substituted in. Static methods are neither inherited
/// nor substituted, so they are read off the element.
MethodElement? _lookupMethod(InterfaceType type, String name) {
  final instanceMethod = type.lookUpMethod(name, type.element.library);

  if (instanceMethod != null) {
    return instanceMethod;
  }

  final typeElement = type.element;
  final cache = _staticMethodCache[typeElement] ??= <String, MethodElement?>{};

  return cache.putIfAbsent(name, () => typeElement.getMethod(name));
}

/// Gets information about the merge method for the given [type].
///
/// Returns [NoMerge] when the type is not an interface, has no merge method,
/// or declares one whose signature we cannot call.
MergeInfo _mergeInfo(DartType type, FieldElement fieldElement) {
  if (type is! InterfaceType) {
    return const NoMerge();
  }

  final typeElement = type.element;

  // Check if element or its supertypes have @ThemeGen annotation.
  // Using the annotation implies that the merge method exists, as it is
  // impossible to get information about the merge method during the build
  // phase.
  const themeGenChecker = TypeChecker.typeNamed(ThemeGen);
  if (themeGenChecker.hasAnnotationOfExact(typeElement)) {
    // The generated merge method takes a nullable argument.
    return const InstanceMerge();
  }

  final method = _lookupMethod(type, 'merge');
  if (method == null) {
    return const NoMerge();
  }

  // A required named parameter cannot be filled in by the generated call.
  if (method.formalParameters.any((p) => p.isRequiredNamed)) {
    _warnUnsupported('merge', type, fieldElement);

    return const NoMerge();
  }

  final params = method.formalParameters
      .where((p) => p.isRequiredPositional)
      .toList(growable: false);

  // A generic method's parameter types mention its own type parameters, which
  // can't be substituted here, so those are matched on the declaring class
  // only.
  final strictSignature = method.typeParameters.isEmpty;

  if (params case [final p1, final p2]
      // Check for static merge method
      // - should have two parameters
      // - both parameters should accept the class type
      // - the result should be usable as the class type
      when method.isStatic &&
          _checkSubtype(p1, type, strict: strictSignature) &&
          _checkSubtype(p2, type, strict: strictSignature) &&
          _isUsableAs(method.returnType, type, type)) {
    return const StaticMerge();
  }

  if (params case [final p1]
      // Check for instance merge method:
      // - should have only one parameter
      // - parameter type should accept the class type
      // - the result should be usable as the class type
      when !method.isStatic &&
          _checkSubtype(p1, type, strict: strictSignature) &&
          _isUsableAs(method.returnType, type, type)) {
    return InstanceMerge(isNullableParameter: p1.type.hasNullableSuffix);
  }

  // The type declares a `merge` we don't know how to call.
  _warnUnsupported('merge', type, fieldElement);

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
