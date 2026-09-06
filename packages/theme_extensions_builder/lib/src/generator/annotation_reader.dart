import 'package:source_gen/source_gen.dart';

/// Reads the optional string options of an annotation.
extension AnnotationReader on ConstantReader {
  /// The value of the string field [name], or `null` when it is null or
  /// empty.
  ///
  /// An empty string means the same as leaving the option out, so that
  /// `constructor: ''` selects the unnamed constructor rather than emitting
  /// `ClassName.()`.
  String? optionalString(String name) {
    final value = read(name);

    if (value.isNull) {
      return null;
    }

    final string = value.stringValue;

    return string.isEmpty ? null : string;
  }
}
