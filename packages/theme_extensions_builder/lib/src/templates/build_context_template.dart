import 'package:theme_extensions_builder/src/model/build_context_config.dart';

/// A template for generate BuildContext extension.
class BuildContextTemplate {
  const BuildContextTemplate(this.config);

  final BuildContextConfig config;

  @override
  String toString() {
    return '''
    extension ${config.className}BuildContext on BuildContext {
      ${config.className} get ${config.className.snake} => Theme.of(this).extension<${config.className}>()!; 
    }
    ''';
  }
}

extension GetterHelper on String {
  String get snake {
    if (isEmpty) {
      return '';
    }

    var property = this[0].toLowerCase() + substring(1);

    if (property.endsWith('Extension')) {
      property = property.substring(0, property.length - 'Extension'.length);
    }

    return property;
  }
}
