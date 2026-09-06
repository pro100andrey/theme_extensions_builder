import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'dart_type_extension.dart';
import 'lookup/lerp_lookup.dart';
import 'lookup/merge_lookup.dart';
import 'symbols/field_info.dart';
import 'symbols/merge_info.dart';

/// Creates a [FieldInfo] for [element], a field of [type].
///
/// [type] is passed separately because it is not always `element.type`: a
/// field inherited from a generic superclass has the type arguments of the
/// inheriting class substituted in.
///
/// When [includeMergeLookup] is `false`, the merge method lookup is skipped
/// and the field is reported as [NoMerge]. Use it for generators that don't
/// emit a `merge` method.
FieldInfo fieldSymbol(
  FieldElement element,
  DartType type, {
  bool includeMergeLookup = true,
}) => FieldInfo(
  name: element.displayName,
  typeName: type.baseType,
  isNullable: type.hasNullableSuffix,
  isDouble: type.isDartCoreDouble,
  isDuration: type.isDuration,
  merge: includeMergeLookup ? mergeInfo(type, element) : const NoMerge(),
  lerp: lerpInfo(type, element),
);
