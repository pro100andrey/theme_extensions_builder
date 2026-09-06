import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../dart_type_extension.dart';
import '../symbols/merge_info.dart';
import '../type_checkers.dart';
import 'method_lookup.dart';

/// Decides how a field of [type] is merged.
///
/// Returns [NoMerge] when the type is not an interface, has no merge method,
/// or declares one whose signature we cannot call.
MergeInfo mergeInfo(DartType type, FieldElement fieldElement) {
  if (type is! InterfaceType) {
    return const NoMerge();
  }

  final method = lookupMethod(type, 'merge');

  if (method == null) {
    return _promisedMerge(type);
  }

  final params = callableParameters(method);

  if (params == null) {
    warnUnsupported('merge', type, fieldElement);

    return const NoMerge();
  }

  final strict = hasStrictSignature(method);

  if (params case [final p1, final p2]
      // Check for static merge method
      // - should have two parameters
      // - both parameters should accept the class type
      // - the result should be usable as the class type
      when method.isStatic &&
          checkSubtype(p1, type, strict: strict) &&
          checkSubtype(p2, type, strict: strict) &&
          isUsableAs(method.returnType, type, type)) {
    return const StaticMerge();
  }

  if (params case [final p1]
      // Check for instance merge method:
      // - should have only one parameter
      // - parameter type should accept the class type
      when !method.isStatic && checkSubtype(p1, type, strict: strict)) {
    // As for lerp: a method declared on a supertype returns that supertype,
    // which the generated code casts back to the field type.
    final needsCast = !isUsableAs(method.returnType, type, type);

    if (needsCast && !isUsableAs(type, method.returnType, type)) {
      warnUnsupported('merge', type, fieldElement);

      return const NoMerge();
    }

    return InstanceMerge(
      isNullableParameter: p1.type.hasNullableSuffix,
      needsCast: needsCast,
    );
  }

  // The type declares a `merge` we don't know how to call.
  warnUnsupported('merge', type, fieldElement);

  return const NoMerge();
}

/// The `merge` a type without one is going to have once its part file is
/// generated.
///
/// A `@ThemeGen` class gets `T merge(T? other)` from its generated mixin,
/// which may not exist yet when this runs. The annotation is taken as the
/// promise that it will. A subclass of the annotated class inherits that
/// method, whose result is the base type and has to be cast back — the same
/// shape the lookup resolves once the mixin exists, so the generated code
/// does not depend on whether the build is clean or incremental.
///
/// A `merge` the class writes itself is found by the lookup before this is
/// reached, so a hand-written signature is never mistaken for the generated
/// one.
MergeInfo _promisedMerge(InterfaceType type) {
  if (themeGenChecker.hasAnnotationOfExact(type.element)) {
    return const InstanceMerge();
  }

  final inheritsThemeGen = type.allSupertypes.any(
    (supertype) => themeGenChecker.hasAnnotationOfExact(supertype.element),
  );

  return inheritsThemeGen
      ? const InstanceMerge(needsCast: true)
      : const NoMerge();
}
