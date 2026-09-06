/// Shared pieces of the `lerp` and `merge` lookups.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';

import '../dart_type_extension.dart';

/// Looks up a method with the given [name] on [type].
///
/// Instance methods are resolved against the instantiated type, including
/// inherited ones, so their parameter and return types have the type
/// arguments of [type] substituted in. Static methods are neither inherited
/// nor substituted, so they are read off the element.
MethodElement? lookupMethod(InterfaceType type, String name) =>
    type.lookUpMethod(name, type.element.library) ??
    type.element.getMethod(name);

/// The parameters the generated code has to fill in to call [method].
///
/// Optional parameters take no part in a signature check: a method stays
/// callable the way we expect when it has extra defaulted parameters. A
/// required named parameter cannot be filled in at all, which is reported as
/// `null`.
List<FormalParameterElement>? callableParameters(MethodElement method) {
  if (method.formalParameters.any((p) => p.isRequiredNamed)) {
    return null;
  }

  return method.formalParameters
      .where((p) => p.isRequiredPositional)
      .toList(growable: false);
}

/// Whether the parameter types of [method] can be compared as written.
///
/// A generic method's parameter types mention its own type parameters, which
/// can't be substituted here, so those are matched on the declaring class
/// only.
bool hasStrictSignature(MethodElement method) => method.typeParameters.isEmpty;

/// Checks that a value of [type] can be passed to [param].
///
/// Nullability is ignored on both sides: a lerp method taking `T?` accepts a
/// non-nullable field, and a nullable field is null checked at the call site.
///
/// When [strict] is `true` the parameter type is compared as written, type
/// arguments included. It has to be `false` for a generic method, whose
/// parameter type mentions type parameters we cannot substitute here; only
/// the declaring class is checked then.
bool checkSubtype(
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
bool isUsableAs(DartType subtype, DartType supertype, InterfaceType context) {
  final typeSystem = context.element.library.typeSystem;

  return typeSystem.isSubtypeOf(
    typeSystem.promoteToNonNull(subtype),
    typeSystem.promoteToNonNull(supertype),
  );
}

/// Reports a [methodName] method that exists but cannot be called.
///
/// A type is free to declare an unrelated `lerp` or `merge`, so this is not an
/// error, but it is worth saying out loud: without the warning "the type has
/// no such method" and "the method is not one I can call" look the same in the
/// generated code.
void warnUnsupported(
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
