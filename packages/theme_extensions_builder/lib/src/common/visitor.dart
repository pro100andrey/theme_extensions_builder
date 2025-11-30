import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'symbols/symbols.dart';
import 'visitors.dart';

/// It's a class that extends the SimpleElementVisitor class, and it overrides
/// the visitClassElement method
class ThemeClassVisitor extends BaseClassVisitor {
  final List<FieldSymbol> fields = [];
  final _seenFieldNames = <String>{};

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (!element.isSynthetic) {
      final symbol = FieldSymbol.from(element);
      // Add field only if not already seen (prevents duplicates)
      if (_seenFieldNames.add(symbol.name)) {
        fields.add(symbol);
      }
    }
  }

  /// Removes duplicate fields based on field name.
  /// This is a fallback in case fields were added multiple times.
  void removeDuplicates() {
    if (fields.length == _seenFieldNames.length) {
      return;
    }

    final seen = <String>{};
    fields.retainWhere((field) => seen.add(field.name));
  }
}
