/// Checks on the annotated class that turn a cryptic error in the generated
/// file into an [InvalidGenerationSourceError] pointing at the cause.
library;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'symbols/field_info.dart';

/// The name of the mixin generated for [element]: `_$ClassName`.
///
/// The mixin is applied by name, so the name is a convention shared with the
/// annotated class.
String generatedMixinName(ClassElement element) => '_\$${element.displayName}';

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

/// Checks that [element] declares no type parameters.
///
/// The generated mixin has none: it names the class without type arguments
/// in its `on` clause, its constructor calls and its `lerp` signature, so a
/// type parameter of the class would be undefined inside it.
void checkNotGeneric(ClassElement element) {
  final typeParameters = element.typeParameters;

  if (typeParameters.isEmpty) {
    return;
  }

  final className = element.displayName;
  final parameters = typeParameters
      .map((parameter) => parameter.displayName)
      .join(', ');

  throw InvalidGenerationSourceError(
    '`$className<$parameters>` is generic, and the generated mixin cannot '
    'be: it instantiates `$className` without type arguments.',
    element: element,
    todo:
        'Remove the type parameters from `$className`, or write its theme '
        'methods by hand.',
  );
}

/// Checks that [fields] and [constructor] agree on what the generated code
/// passes.
///
/// The generated `copyWith`, `lerp` and `merge` build a new instance with one
/// named argument per field, so each field needs a named parameter of the
/// same name, and every required parameter has to be one of those: a
/// parameter the generated code cannot fill in is a missing argument in the
/// generated file.
void checkConstructorParameters(
  ClassElement element,
  ConstructorElement constructor,
  List<FieldInfo> fields,
) {
  final constructorName = constructor.name == 'new'
      ? element.displayName
      : '${element.displayName}.${constructor.name}';

  final named = {
    for (final parameter in constructor.formalParameters)
      if (parameter.isNamed) parameter.displayName,
  };

  final missing = [
    for (final field in fields)
      if (!named.contains(field.name)) field.name,
  ];

  if (missing.isNotEmpty) {
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

  final passed = {for (final field in fields) field.name};

  // A required positional parameter is never passed: the generated code only
  // names its arguments.
  final unfilled = [
    for (final parameter in constructor.formalParameters)
      if (parameter.isRequired &&
          !(parameter.isNamed && passed.contains(parameter.displayName)))
        parameter.displayName,
  ];

  if (unfilled.isEmpty) {
    return;
  }

  final parameterList = unfilled.map((name) => '`$name`').join(', ');
  final plural = unfilled.length > 1;

  throw InvalidGenerationSourceError(
    'The constructor `$constructorName` requires $parameterList, which '
    '${plural ? 'are' : 'is'} not among the fields the generated code passes '
    'to it.',
    element: element,
    todo:
        'Make `${unfilled.first}`${plural ? ' and the others' : ''} optional, '
        'or make ${plural ? 'them fields' : 'it a field'} the generated code '
        'passes: declare ${plural ? 'them' : 'it'} as '
        '`this.${unfilled.first}`, without `@ignore` on the field.',
  );
}

/// Checks that no field in [fields] takes a name in [reserved], the members
/// the generated mixin declares.
///
/// A field is a getter, which cannot override a method the mixin declares,
/// and a static method cannot share a name with an instance member: the class
/// applying the mixin fails to compile with an error that never mentions the
/// generator.
void checkReservedFieldNames(
  ClassElement element,
  List<FieldInfo> fields, {
  required Set<String> reserved,
}) {
  final clashing = fields
      .map((field) => field.name)
      .where(reserved.contains)
      .firstOrNull;

  if (clashing == null) {
    return;
  }

  throw InvalidGenerationSourceError(
    'The generated mixin `${generatedMixinName(element)}` declares '
    '`$clashing`, so `${element.displayName}` cannot have a field of that '
    'name.',
    element: element,
    todo: 'Rename the field `$clashing`.',
  );
}

/// Checks that [element] applies the generated mixin.
///
/// Without it the generated methods exist but are reachable from nowhere:
/// another theme holding a field of this type calls a `merge` the class does
/// not have.
///
/// The mixin lives in the file about to be generated, so on a clean build it
/// does not resolve and leaves no trace in the element model. The clause is
/// read from the parsed declaration instead. A declaration the session cannot
/// produce is not held against the class.
void checkMixinApplied(ClassElement element) {
  final mixinName = generatedMixinName(element);
  final declaration = _declarationOf(element);

  if (declaration == null) {
    return;
  }

  final mixins = declaration.withClause?.mixinTypes ?? const <NamedType>[];

  if (mixins.any((type) => type.name.lexeme == mixinName)) {
    return;
  }

  final className = element.displayName;

  throw InvalidGenerationSourceError(
    '`$className` does not apply the generated mixin `$mixinName`, which '
    'holds the generated methods.',
    element: element,
    todo: 'Add `with $mixinName` to the declaration of `$className`.',
  );
}

/// The parsed declaration of [element], or `null` when the session cannot
/// parse its library.
ClassDeclaration? _declarationOf(ClassElement element) {
  final library = element.library;
  final parsed = library.session.getParsedLibraryByElement(library);

  if (parsed is! ParsedLibraryResult) {
    return null;
  }

  final name = element.displayName;

  for (final unit in parsed.units) {
    for (final declaration in unit.unit.declarations) {
      if (declaration is ClassDeclaration &&
          declaration.namePart.typeName.lexeme == name) {
        return declaration;
      }
    }
  }

  return null;
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

/// Words the language keeps for itself, which the identifier pattern cannot
/// tell from a name.
const _reservedWords = {
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
};

/// Checks that [value], given as the annotation option [option], can be
/// written into the generated code as a name.
void checkIdentifier(
  String value, {
  required String option,
  required ClassElement element,
}) {
  if (_reservedWords.contains(value)) {
    throw InvalidGenerationSourceError(
      '`$value` is a reserved word, so it cannot be used as `$option`.',
      element: element,
      todo: 'Use a name that is not a Dart keyword.',
    );
  }

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
