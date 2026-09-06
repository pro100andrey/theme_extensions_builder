/// Checks on the annotated class that turn a cryptic error in the generated
/// file into an [InvalidGenerationSourceError] pointing at the cause.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'symbols/field_info.dart';

/// Resolves the constructor the generated code instantiates [element] with.
///
/// [name] is the `constructor` option of the annotation; `null` selects the
/// unnamed constructor.
ConstructorElement resolveConstructor(ClassElement element, String? name) {
  final className = element.displayName;
  final constructor = name == null
      ? element.unnamedConstructor
      : element.getNamedConstructor(name);

  if (constructor != null) {
    return constructor;
  }

  if (name == null) {
    throw InvalidGenerationSourceError(
      '`$className` has no unnamed constructor, which the generated code '
      'calls.',
      element: element,
      todo:
          'Declare `$className({...})`, or point `constructor:` at the '
          'constructor to use.',
    );
  }

  throw InvalidGenerationSourceError(
    '`$className` has no constructor named `$name`.',
    element: element,
    todo:
        'Declare `$className.$name({...})`, or point `constructor:` at an '
        'existing constructor.',
  );
}

/// Checks that every one of [fields] can be passed to [constructor] by name.
///
/// The generated `copyWith`, `lerp` and `merge` build a new instance with one
/// named argument per field, so each field needs a named parameter of the
/// same name.
void checkConstructorParameters(
  ClassElement element,
  ConstructorElement constructor,
  List<FieldInfo> fields,
) {
  final named = {
    for (final parameter in constructor.formalParameters)
      if (parameter.isNamed) parameter.displayName,
  };

  final missing = [
    for (final field in fields)
      if (!named.contains(field.name)) field.name,
  ];

  if (missing.isEmpty) {
    return;
  }

  final constructorName = constructor.name == 'new'
      ? element.displayName
      : '${element.displayName}.${constructor.name}';
  final fieldList = missing.map((name) => '`$name`').join(', ');
  final plural = missing.length > 1;

  throw InvalidGenerationSourceError(
    'The constructor `$constructorName` has no named '
    '${plural ? 'parameters' : 'parameter'} for the '
    '${plural ? 'fields' : 'field'} $fieldList, which the generated code '
    'passes to it.',
    element: element,
    todo:
        'Add `this.${missing.first}`${plural ? ' and the others' : ''} to '
        '`$constructorName`, or mark the '
        '${plural ? 'fields' : 'field'} with `@ignore`.',
  );
}

/// Checks that [element] extends `ThemeExtension<Self>`.
///
/// The generated mixin is declared `on ThemeExtension<Self>`, so it cannot be
/// applied to anything else.
void checkExtendsThemeExtension(ClassElement element) {
  final className = element.displayName;

  final themeExtension = element.allSupertypes
      .where((type) => type.element.name == 'ThemeExtension')
      .firstOrNull;

  final typeArguments = themeExtension?.typeArguments;

  if (typeArguments != null &&
      typeArguments.length == 1 &&
      typeArguments.single.element == element) {
    return;
  }

  throw InvalidGenerationSourceError(
    '`$className` must extend `ThemeExtension<$className>` to be annotated '
    'with `@ThemeExtensions`.',
    element: element,
    todo:
        'Declare it as '
        '`class $className extends ThemeExtension<$className> '
        'with _\$$className`, or use `@ThemeGen` for a plain class.',
  );
}

final _identifier = RegExp(r'^[A-Za-z_$][A-Za-z0-9_$]*$');

/// Checks that [value], given as the annotation option [option], can be
/// written into the generated code as a name.
void checkIdentifier(
  String value, {
  required String option,
  required ClassElement element,
}) {
  if (_identifier.hasMatch(value)) {
    return;
  }

  throw InvalidGenerationSourceError(
    '`$value` is not a valid Dart identifier, so it cannot be used as '
    '`$option`.',
    element: element,
    todo:
        r'Use letters, digits, `_` and `$` only, and do not start with a '
        'digit.',
  );
}
