import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'analysis.dart';
import 'base_class_visiter.dart';
import 'symbols/field.dart';

/// A visitor that collects field symbols from a class element,
/// ignoring those annotated with `@ignore`.
class FieldsVisitor extends BaseClassVisitor {
  final List<FieldSymbol> fields = [];
  final _seenFieldNames = <String>{};

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (!element.isSynthetic) {
      final field = fieldSymbol(element);
      // Add field only if not already seen (prevents duplicates)
      if (_seenFieldNames.add(field.name)) {
        fields.add(field);
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
