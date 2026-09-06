import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor2.dart';

import 'field_symbol.dart';
import 'symbols/field_info.dart';
import 'type_checkers.dart';

/// Collects the fields of [element] together with the fields it inherits.
///
/// Only the superclass chain and the applied mixins contribute: an interface
/// reached through `implements` has to be satisfied by [element] itself, so
/// its declarations would shadow nothing and cannot be constructed.
///
/// Types are visited in Dart's own resolution order — the class first, then
/// its mixins from last applied to first, then the superclass chain — and the
/// first declaration of a name wins, so the declaration actually in effect is
/// the one that is collected.
///
/// When [includeMergeLookup] is `false`, no merge method is looked up; see
/// [fieldSymbol].
List<FieldInfo> collectFields(
  ClassElement element, {
  bool includeMergeLookup = true,
}) {
  final visitor = FieldsVisitor(includeMergeLookup: includeMergeLookup);

  element.visitChildren(visitor);

  for (final inherited in _inheritedTypes(element.thisType)) {
    inherited.element.visitChildren(visitor);
  }

  return visitor.fields;
}

/// Yields the types [type] inherits members from, nearest first.
Iterable<InterfaceType> _inheritedTypes(InterfaceType type) sync* {
  // A mixin is applied on top of the superclass, so a member it declares wins
  // over the same member further up the chain. The last mixin applied wins
  // over the ones before it.
  yield* type.mixins.reversed;

  final superclass = type.superclass;

  if (superclass != null && !superclass.isDartCoreObject) {
    yield superclass;
    yield* _inheritedTypes(superclass);
  }
}

/// A visitor that collects field information from a class element.
///
/// Only fields the generated code can pass to a constructor are collected:
/// explicitly declared instance fields that are public and not annotated with
/// `@ignore`.
class FieldsVisitor extends SimpleElementVisitor2<void> {
  /// Creates a [FieldsVisitor].
  ///
  /// When [includeMergeLookup] is `false`, no merge method is looked up.
  FieldsVisitor({this.includeMergeLookup = true});

  /// Whether to look up merge methods on field types.
  final bool includeMergeLookup;

  /// Collected field information, keyed by field name.
  ///
  /// Keying by name means a redeclared field is collected once. The first
  /// declaration seen wins; see [collectFields] for the visiting order that
  /// makes the nearest declaration the first one.
  final Map<String, FieldInfo> _fields = {};

  /// Names already decided on, including the ones that were skipped.
  ///
  /// An `@ignore` on a redeclaration has to suppress the inherited
  /// declaration too, so a skipped name still claims its place.
  final Set<String> _claimed = {};

  /// The collected fields, in the order they were visited.
  List<FieldInfo> get fields => _fields.values.toList(growable: false);

  @override
  void visitFieldElement(FieldElement element) {
    // Only explicitly declared fields: a synthetic field backs a getter or
    // setter, and cannot be passed to a constructor.
    if (!element.isOriginDeclaration) {
      return;
    }

    // A static field is not part of an instance. Dart forbids a static and an
    // instance member of the same name in one hierarchy, so it cannot shadow
    // an inherited field either.
    if (element.isStatic) {
      return;
    }

    // A private field cannot be passed to a generated constructor call, and a
    // private name is not a valid named parameter either.
    if (element.isPrivate) {
      return;
    }

    final name = element.displayName;

    if (!_claimed.add(name)) {
      return;
    }

    if (ignoreChecker.hasAnnotationOf(element)) {
      return;
    }

    _fields[name] = fieldSymbol(
      element,
      includeMergeLookup: includeMergeLookup,
    );
  }
}
