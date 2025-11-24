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

    if (element.isFinal) {
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
    // else {
    //   throw InvalidGenerationSourceError(
    //     'All fields in ThemeExtension classes must be final',
    //     element: element,
    //   );
    // }
  }
}

extension type Filed(FieldElement element) {
  String get name => element.displayName;
  DartType get _type => element.type;

  String get displayType => _type.getDisplayString();

  bool get isNullable => _type.nullabilitySuffix == .question;

  String get type =>
      isNullable ? displayType.replaceFirst('?', '') : displayType;
}

// /// It's a class that represents a field
// class FieldSymbol {
//   const FieldSymbol({
//     required this.name,
//     required this.type,
//     required this.lerpInfo,
//     required this.isNullable,
//     required this.mergeInfo,
//   });

//   final String name;
//   final String type;
//   final LerpInfo? lerpInfo;
//   final MergeInfo? mergeInfo;
//   final bool isNullable;

//   bool get hasLerp => lerpInfo != null;
//   bool get hasMerge => mergeInfo != null;

//   bool get isDouble => type == 'double';
//   bool get isDuration => type == 'Duration';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }

//     return other is FieldSymbol &&
//         other.name == name &&
//         other.type == type &&
//         other.lerpInfo == lerpInfo &&
//         other.isNullable == isNullable &&
//         other.mergeInfo == mergeInfo;
//   }

//   @override
//   int get hashCode => Object.hash(
//     name,
//     type,
//     lerpInfo,
//     isNullable,
//     mergeInfo,
//   );
// }
