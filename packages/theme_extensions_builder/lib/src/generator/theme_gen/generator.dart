import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/fields_visitor.dart';
import '../../common/validation.dart';
import '../../config/config.dart';
import '../annotation_reader.dart';
import 'code_builder.dart';

/// Code generator for classes annotated with `@ThemeGen`.
///
/// This generator creates mixins for theme data classes that don't extend
/// Flutter's `ThemeExtension`. The generated code includes:
/// - `copyWith` method for creating modified copies
/// - `merge` method for combining theme instances
/// - `lerp` static method for interpolation
/// - `==` operator and `hashCode` for equality comparison
/// - `canMerge` getter indicating merge capability
///
/// Example usage:
/// ```dart
/// @ThemeGen()
/// class MyTheme with _$MyTheme {
///   const MyTheme({required this.color});
///   final Color color;
/// }
/// ```
class ThemeGenGenerator extends GeneratorForAnnotation<ThemeGen> {
  /// Creates a [ThemeGenGenerator].
  const ThemeGenGenerator();

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'ThemeGen can only annotate classes',
        element: element,
        todo: 'Move @ThemeGen annotation above `class`',
      );
    }

    final constructorName = annotation.optionalString('constructor');
    final constructor = resolveConstructor(element, constructorName);

    final fields = collectFields(element);

    checkConstructorParameters(element, constructor, fields);

    final config = ThemeGenConfig(
      fields: fields,
      className: element.displayName,
      constructor: constructorName,
      constConstructor: constructor.isConst,
    );

    return const ThemeGenCodeBuilder().generate(config);
  }
}
