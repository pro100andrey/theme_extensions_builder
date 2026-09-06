import 'package:analyzer/dart/element/type.dart';

/// Helpers for reading a [DartType] the way the generators need it.
extension DartTypeExtension on DartType {
  /// The display name of the type without its nullability suffix.
  ///
  /// This is the name the generated code declares variables and writes casts
  /// with, type arguments included.
  String get baseType {
    final displayString = getDisplayString();

    return hasNullableSuffix
        ? displayString.substring(0, displayString.length - 1)
        : displayString;
  }

  /// Whether the type is written with a `?`.
  bool get hasNullableSuffix => nullabilitySuffix == .question;

  /// Whether the type is `Duration` from `dart:core`.
  ///
  /// Checked by element rather than by name, so a user type that happens to
  /// be called `Duration` is not interpolated as one.
  bool get isDuration {
    final typeElement = element;

    return typeElement != null &&
        typeElement.displayName == 'Duration' &&
        (typeElement.library?.isDartCore ?? false);
  }
}
