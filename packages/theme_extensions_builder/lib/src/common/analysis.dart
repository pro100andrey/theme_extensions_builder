import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

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
