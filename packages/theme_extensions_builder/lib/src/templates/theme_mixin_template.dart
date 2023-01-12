import '../model/field.dart';
import '../model/theme_mixin_config.dart';

/// A template for generate _$ThemeExtensionMixin.
class ThemeMixinTemplate {
  const ThemeMixinTemplate(this.config);

  final ThemeMixinConfig config;

  String _copyWithMethod() {
    final returnType = config.className;
    if (config.fields.isEmpty) {
      return '''
      @override
      ThemeExtension<$returnType> copyWith() => $returnType();
      ''';
    }

    final methodParams = StringBuffer();
    final classParams = StringBuffer();

    config.fields.forEach((key, value) {
      methodParams.write('${value.typeName.asNullableType()} $key,');
      classParams.write('$key: $key ?? object.$key,');
    });

    return '''
    @override
    ThemeExtension<$returnType> copyWith({
      ${methodParams.toString()}
    }) {

      final object = this as $returnType;

      return $returnType(
        ${classParams.toString()}
      );
    }
    ''';
  }

  String _lerpMethod() {
    final returnType = config.className;
    final classParams = StringBuffer();

    config.fields.forEach((key, value) {
      if (value.hasLerp) {
        classParams.write(
          '$key: ${value.typeName.asType()}.lerp(value.$key, otherValue.$key, t,)${value.isNullable ? '' : '!'},',
        );
      } else {
        classParams.write(
          '$key: otherValue.$key,',
        );
      }
    });

    return '''
    @override
    ThemeExtension<$returnType> lerp(ThemeExtension<$returnType>? other, double t,) {

      final otherValue = other;

      if (otherValue is! $returnType) {
        return this;
      }

      ${!config.fields.values.any((e) => e.hasLerp) ? '' : _castThisAsClassName()}

      return $returnType(
        ${classParams.toString()}
      );
    }
    ''';
  }

  String _equalOperator() {
    String equality(Field field) {
      final name = field.name;
      return 'identical(value.$name, other.$name)';
    }

    final comparisons = [
      'other.runtimeType == runtimeType',
      'other is ${config.className}',
      for (final field in config.fields.values) equality(field)
    ];

    return '''@override bool operator ==(Object other) {
      ${_castThisAsClassName()}

      return identical(this, other) || (${comparisons.join('&&')});
    }
    ''';
  }

  String _castThisAsClassName() {
    if (config.fields.isEmpty) {
      return '';
    }

    return 'final value = this as ${config.className};';
  }

  String _hashCodeMethod() {
    String hashMethod(String result, [bool convert = true]) => '''

      @override int get hashCode {
        ${_castThisAsClassName()}
        
        return $result;
      }
    ''';

    final hashedProps = [
      'runtimeType',
      for (final field in config.fields.values) 'value.${field.name}'
    ];

    if (hashedProps.length == 1) {
      return hashMethod('${hashedProps.first}.hashCode', false);
    }

    if (hashedProps.length <= 20) {
      return hashMethod('Object.hash(${hashedProps.join(',')},)');
    }

    return hashMethod('Object.hashAll([${hashedProps.join(',')}])');
  }

  @override
  String toString() {
    const name = r'_$ThemeExtensionMixin';

    return '''
    mixin $name on ThemeExtension<${config.className}> {
      ${_copyWithMethod()}
      ${_lerpMethod()}
      ${_equalOperator()}
      ${_hashCodeMethod()}
      }
    ''';
  }
}

extension _StringExt on String {
  String asNullableType() {
    if (this == 'dynamic') return this;
    if (endsWith('?')) return this;

    return '$this?';
  }

  String asType() {
    if (this == 'dynamic') return this;
    if (endsWith('?')) {
      return replaceAll('?', '');
    }

    return this;
  }
}
