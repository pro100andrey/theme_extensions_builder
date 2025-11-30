import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/fields_visiter.dart';
import '../../common/fields_visitor_config.dart';
import '../../config/config.dart';
import 'code_builder.dart';

/// Code generator for classes annotated with `@ThemeExtensions`.
///
/// This generator creates code for custom Flutter theme extensions that
/// extend `ThemeExtension`. The generated code includes:
/// - `copyWith` method for creating modified copies
/// - `lerp` method for smooth theme transitions
/// - `==` operator and `hashCode` for equality comparison
/// - Optional BuildContext extension for convenient theme access
///
/// Example usage:
/// ```dart
/// @ThemeExtensions()
/// class MyTheme extends ThemeExtension<MyTheme> with _$MyTheme {
///   const MyTheme({required this.color});
///   final Color color;
/// }
/// ```
class ThemeExtensionsGenerator extends GeneratorForAnnotation<ThemeExtensions> {
  /// Creates a [ThemeExtensionsGenerator] with optional [builderOptions].
  ThemeExtensionsGenerator({this.builderOptions});

  /// Optional build configuration options.
  final BuilderOptions? builderOptions;

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'ThemeExtensions can only annotate classes',
        element: element,
        todo: 'Move @ThemeExtensions annotation above `class`',
      );
    }

    final buildContextExtension = annotation
        .read('buildContextExtension')
        .boolValue;

    final constructor = annotation.read('constructor').literalValue as String?;
    final constConstructor = element.constructors.any((c) => c.isConst);

    final contextAccessorName =
        annotation.read('contextAccessorName').literalValue as String?;

    // ThemeExtensions needs lerp but doesn't generate merge methods
    final fieldsVisiter = FieldsVisitor(
      config: const FieldsVisitorConfig(includeMergeLookup: false),
    );
    // Get all supertypes to visit their fields as well
    final allSupertypes = element.allSupertypes;

    for (final supertype in allSupertypes) {
      final superElement = supertype.element;

      if (!supertype.isDartCoreObject) {
        superElement.visitChildren(fieldsVisiter);
      }
    }

    element.visitChildren(fieldsVisiter);

    // Use naming convention instead of expensive AST parsing
    // Assume the mixin follows the standard pattern: _$ClassName
    final mixinName = '_\$${element.displayName}';

    final generatorConfig = ThemeExtensionsConfig(
      fields: fieldsVisiter.fields,
      className: element.displayName,
      contextAccessorName: contextAccessorName,
      buildContextExtension: buildContextExtension,
      constructor: constructor,
      themeExtensionMixinName: mixinName,
      constConstructor: constConstructor,
    );

    const generator = ThemeExtensionsCodeBuilder();
    final code = generator.generate(generatorConfig);

    return code;
  }
}
