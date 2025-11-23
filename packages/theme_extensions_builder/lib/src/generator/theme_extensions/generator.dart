import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../common/analysis.dart';
import '../../config/config.dart';
import 'code_builder.dart';
import 'visitor.dart';

/// It's a Dart code generator that generates code for the `@ThemeExtensions`
/// annotation
class ThemeExtensionsGenerator extends GeneratorForAnnotation<ThemeExtensions> {
  ThemeExtensionsGenerator({this.builderOptions});

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

    final contextAccessorName =
        annotation.read('contextAccessorName').literalValue as String?;

    final classVisitor = ThemeExtensionsClassVisitor();
    // Get all supertypes to visit their fields as well
    final allSupertypes = element.allSupertypes;

    for (final supertype in allSupertypes) {
      final superElement = supertype.element;

      if (superElement is ClassElement && !supertype.isDartCoreObject) {
        superElement.visitChildren(classVisitor);
      }
    }

    element.visitChildren(classVisitor);

    final mixinName = getMixinsNames(element: element).firstWhere(
      (m) => m.startsWith(r'_$'),
      orElse: () => '_\$${element.displayName}',
    );

    final generatorConfig = ThemeExtensionsConfig(
      fields: classVisitor.fields,
      className: element.displayName,
      contextAccessorName: contextAccessorName,
      buildContextExtension: buildContextExtension,
      constructor: constructor,
      themeExtensionMixinName: mixinName,
    );

    const generator = ThemeExtensionsCodeBuilder();
    final code = generator.generate(generatorConfig);

    return code;
  }
}
