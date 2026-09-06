import 'package:analyzer/dart/element/element.dart';

import 'dart_type_extension.dart';
import 'lookup/lerp_lookup.dart';
import 'lookup/merge_lookup.dart';
import 'symbols/field_info.dart';
import 'symbols/merge_info.dart';

/// Creates a [FieldInfo] from the given [element].
///
/// When [includeMergeLookup] is `false`, the merge method lookup is skipped
/// and the field is reported as [NoMerge]. Use it for generators that don't
/// emit a `merge` method.
FieldInfo fieldSymbol(FieldElement element, {bool includeMergeLookup = true}) {
  final type = element.type;

  return FieldInfo(
    name: element.displayName,
    typeName: type.baseType,
    isNullable: type.hasNullableSuffix,
    isDouble: type.isDartCoreDouble,
    isDuration: type.isDuration,
    merge: includeMergeLookup ? mergeInfo(type, element) : const NoMerge(),
    lerp: lerpInfo(type, element),
  );
}
