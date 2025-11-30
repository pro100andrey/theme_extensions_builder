import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'analysis.dart';
import 'base_class_visiter.dart';
import 'symbols/field.dart';

/// A visitor that collects field symbols from a class element,
/// ignoring those annotated with `@ignore`.
class FieldsVisitor extends BaseClassVisitor {
  final Set<FieldSymbol> _fields = {};
  List<FieldSymbol> get fields => _fields.toList(growable: false);

  final ignoreAnnotationTypeChecker = TypeChecker.typeNamed(ignore.runtimeType);

  @override
  void visitFieldElement(FieldElement element) {
    if (ignoreAnnotationTypeChecker.hasAnnotationOf(element)) {
      return;
    }

    if (!element.isSynthetic) {
      final field = fieldSymbol(element);
      _fields.add(field);
    }
  }
}
