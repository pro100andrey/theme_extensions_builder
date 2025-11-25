import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'analysis.dart';
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
      final isNullable = element.type.nullabilitySuffix == .question;
      final resultType = element.type.getDisplayString().replaceAll('?', '');

      final symbol = FieldSymbol(
        lerpInfo: lerpInfo(element: element),
        mergeInfo: mergeInfo(element: element),
        name: element.displayName,
        type: resultType,
        isNullable: isNullable,
      );

      fields.add(symbol);
    }
  }
}

extension type FiledV(FieldElement element) {
  /// The name of the field.
  String get name => element.displayName;

  /// The type of the field.
  DartType get _type => element.type;

  /// The display type of the field.
  String get displayType => _type.getDisplayString();

  /// The type of the field without nullability suffix.
  String get type =>
      isNullable ? displayType.replaceFirst('?', '') : displayType;

  /// Whether the field is nullable.
  bool get isNullable => _type.nullabilitySuffix == .question;

  LerpInfo? _lerpInfoForInterface(InterfaceElement element) {
    final method = element.getMethod('lerp');
    if (method == null || !method.isPublic) {
      return null;
    }

    final isStatic = method.isStatic;
    final params = method.formalParameters;
    final expectedCount = isStatic ? 3 : 2;
    // Check parameter count matches expected count based on static or
    // instance method
    if (params.length != expectedCount) {
      return null;
    }

    // Check if the last parameter 't' is double
    if (!params.last.type.isDartCoreDouble) {
      return null;
    }

    final argsToCheck = params.take(expectedCount - 1);
    final hasNullableArgs = argsToCheck.any(
      (p) => p.type.nullabilitySuffix != .none,
    );

    return LerpInfo(
      isStatic: isStatic,
      type: element.displayName,
    );
  }

  LerpInfo? get lerpInfo {
    final type = _type.element;

    if (type is! InterfaceElement) {
      return null;
    }

    // Use followedBy to create a lazy iterable instead of a new List
    final candidates = [type].followedBy(
      type.allSupertypes
          .where((e) => !e.isDartCoreObject)
          .map((e) => e.element),
    );

    final lerps = <LerpInfo>[];

    for (final targetClass in candidates) {
      final method = targetClass.getMethod('lerp');
      if (method == null || !method.isPublic) {
        continue;
      }

      final isStatic = method.isStatic;
      final params = method.formalParameters;
      final expectedCount = isStatic ? 3 : 2;
      // Check parameter count matches expected count based on static or
      // instance method
      if (params.length != expectedCount) {
        continue;
      }

      // Check if the last parameter 't' is double
      if (!params.last.type.isDartCoreDouble) {
        continue;
      }

      final argsToCheck = params.take(expectedCount - 1);
      final hasNullableArgs = argsToCheck.any(
        (p) => p.type.nullabilitySuffix != .none,
      );

      lerps.add(
        LerpInfo(
          isStatic: isStatic,
          type: targetClass.displayName,
        ),
      );
    }

    return lerps.firstOrNull;
  }
}

LerpInfo? lerpInfo({required FieldElement element}) {
  final field = FiledV(element);
  return field.lerpInfo;
}
