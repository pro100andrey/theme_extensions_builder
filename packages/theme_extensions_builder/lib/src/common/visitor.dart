import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'symbols.dart';
import 'visitors.dart';

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class ThemeClassVisitor extends BaseClassVisitor {
  final List<FieldSymbol> fields = [];

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (!element.isSynthetic) {
      final symbol = FieldSymbol.from(element);
      fields.add(symbol);
    }
  }
}
