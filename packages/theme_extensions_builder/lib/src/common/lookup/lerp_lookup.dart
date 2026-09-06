import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../dart_type_extension.dart';
import '../symbols/lerp_info.dart';
import 'method_lookup.dart';

/// Decides how a field of [type] is interpolated.
///
/// Returns information about static or instance lerp methods, or [NoLerp] if
/// the type is not an interface, has no lerp method, or has one whose
/// signature we cannot call. A type is free to declare an unrelated `lerp`
/// method, so an unknown signature falls back to [NoLerp] rather than failing
/// the build.
///
/// Throws [InvalidGenerationSourceError] for a `WidgetStateProperty` field
/// with a non-nullable generic, which is a mistake we can point at.
LerpInfo lerpInfo(DartType type, FieldElement fieldElement) {
  if (type is! InterfaceType) {
    return const NoLerp();
  }

  final method = lookupMethod(type, 'lerp');

  if (method == null) {
    return const NoLerp();
  }

  final params = callableParameters(method);

  if (params == null) {
    warnUnsupported('lerp', type, fieldElement);

    return const NoLerp();
  }

  final strict = hasStrictSignature(method);

  // WidgetStateProperty and WidgetStateColor use a different signature for
  // lerp. Check for the 4-parameter version first, as WidgetStateProperty has
  // both 3 and 4 parameter versions.
  if (params case [final p1, final p2, final p3, final p4]
      // Check for static lerp method with 4 parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      // - fourth parameter is a lerp function for the inner type
      when method.isStatic &&
          p3.type.isDartCoreDouble &&
          checkSubtype(p1, type, strict: strict) &&
          checkSubtype(p2, type, strict: strict)) {
    return _widgetStatePropertyLerp(type, p1, p4, fieldElement);
  }

  if (params case [final p1, final p2, final p3]
      // Check for static lerp method
      // - should have three parameters
      // - first two parameters should have the same type as the class type
      // - third parameter should be double
      when method.isStatic &&
          p3.type.isDartCoreDouble &&
          checkSubtype(p1, type, strict: strict) &&
          checkSubtype(p2, type, strict: strict)) {
    if (!isUsableAs(method.returnType, type, type)) {
      warnUnsupported('lerp', type, fieldElement);

      return const NoLerp();
    }

    return StaticLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      isNullableParameter:
          p1.type.hasNullableSuffix && p2.type.hasNullableSuffix,
    );
  }

  if (params case [final p1, final p2]
      // Check for instance lerp method:
      // - should have only two parameters
      // - first parameter type should match the class type
      // - second parameter should be double
      when !method.isStatic &&
          p2.type.isDartCoreDouble &&
          checkSubtype(p1, type, strict: strict)) {
    // A method declared on a supertype returns that supertype, which the
    // generated code casts back to the field type. Anything else is not a
    // result we can use.
    final needsCast = !isUsableAs(method.returnType, type, type);

    if (needsCast && !isUsableAs(type, method.returnType, type)) {
      warnUnsupported('lerp', type, fieldElement);

      return const NoLerp();
    }

    return InstanceLerp(
      optionalResult: method.returnType.hasNullableSuffix,
      needsCast: needsCast,
    );
  }

  // The type declares a `lerp` we don't know how to call.
  warnUnsupported('lerp', type, fieldElement);

  return const NoLerp();
}

/// Decides how a `WidgetStateProperty` shaped [type] is interpolated.
///
/// [p1] is the first parameter of the four parameter `lerp`, which names the
/// declaring type, and [lerpFunction] is its last parameter.
LerpInfo _widgetStatePropertyLerp(
  InterfaceType type,
  FormalParameterElement p1,
  FormalParameterElement lerpFunction,
  FieldElement fieldElement,
) {
  // The fourth parameter has to be a lerp function itself, with the
  // signature `R Function(T? a, T? b, double t)`.
  //
  // For generic functions like T? Function(T?, T?, double) we can't easily
  // check exact type compatibility without type substitution, so only the
  // structure is verified.
  if (lerpFunction.type
      case FunctionType(formalParameters: [final f1, final f2, final f3])
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
      warnUnsupported('lerp', type, fieldElement);

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
      final innerLerp = lerpInfo(innerType, fieldElement);

      if (innerLerp is! StaticLerp ||
          !innerLerp.optionalResult ||
          !innerLerp.isNullableParameter) {
        warnUnsupported('lerp', innerType, fieldElement);

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
  warnUnsupported('lerp', type, fieldElement);

  return const NoLerp();
}
