import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

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
      methodParams.write('${value.type.asNullableType()} $key,');
      classParams.write('$key: $key ?? object.$key,');
    });

    return '''
    @override
    ThemeExtension<$returnType> copyWith({
      $methodParams
    }) {

      final object = this as $returnType;

      return $returnType(
        $classParams
      );
    }
    ''';
  }

  String _lerpMethod() {
    final returnType = config.className;
    final classParams = StringBuffer();

    config.fields.forEach((key, value) {
      if (value.hasLerp && value.lerpInfo!.isStatic) {
        classParams.write(
          '$key: ${value.type.asType()}'
          '.lerp(value.$key, otherValue.$key, t,)'
          '${value.isNullable ? '' : '!'},',
        );
      } else {
        classParams.write('$key: otherValue.$key,');
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
        $classParams
      );
    }
    ''';
  }

  String _equalOperator() {
    String equality(FieldSymbol field) {
      final name = field.name;
      return 'identical(value.$name, other.$name)';
    }

    final comparisons = [
      'other.runtimeType == runtimeType',
      'other is ${config.className}',
      for (final field in config.fields.values) equality(field),
    ];

    return '''
@override bool operator ==(Object other) {
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
    String hashMethod(String result, {bool convert = true}) =>
        '''

      @override int get hashCode {
        ${_castThisAsClassName()}

        return $result;
      }
    ''';

    final hashedProps = [
      'runtimeType',
      for (final field in config.fields.values) 'value.${field.name}',
    ];

    if (hashedProps.length == 1) {
      return hashMethod('${hashedProps.first}.hashCode', convert: false);
    }

    if (hashedProps.length <= 20) {
      return hashMethod('Object.hash(${hashedProps.join(',')},)');
    }

    return hashMethod('Object.hashAll([${hashedProps.join(',')}])');
  }

  TypeReference themeExtensionRef({bool isNullable = false}) => TypeReference(
    (t) => t
      ..symbol = 'ThemeExtension'
      ..types.add(refer(config.className))
      ..isNullable = isNullable,
  );

  Method copyWith(ThemeMixinConfig config) {
    final fields = config.fields;

    final parameters = fields.entries
        .map((e) {
          final name = e.key;
          final typeName = e.value.type.asNullableType();

          return Parameter(
            (p) => p
              ..name = name
              ..named = true
              ..type = refer(typeName),
          );
        })
        .toList(growable: false);

    final body = BlockBuilder()
      ..addExpression(
        declareFinal('object').assign(
          refer('this').asA(refer(config.className)),
        ),
      )
      ..statements.add(const Code(''))
      ..addExpression(
        refer(config.className).newInstance([], {
          for (final e in fields.entries)
            e.key: refer(e.key).ifNullThen(
              refer('object').property(e.key),
            ),
        }).returned,
      );

    final result = Method((m) {
      m
        ..name = 'copyWith'
        ..annotations.add(refer('override'))
        ..returns = themeExtensionRef()
        ..requiredParameters.addAll(parameters)
        ..body = body.build();
    });

    return result;
  }

  Method lerpMethod(ThemeMixinConfig config) {
    final body = BlockBuilder();
    final fields = config.fields;

    body
      ..addExpression(
        declareFinal('otherValue').assign(
          refer('other'),
        ),
      )
      ..statements.add(
        ifCode(
          refer('otherValue').isNotA(refer(config.className)).code,
          [
            refer('this').returned.statement,
          ],
        ),
      )
      ..statements.add(const Code(''))
      ..addExpression(
        declareFinal('value').assign(
          refer('this').asA(refer(config.className)),
        ),
      )
      ..statements.add(const Code(''))
      ..addExpression(() {
        final args = <String, Expression>{};

        for (final e in fields.entries) {
          final field = e.value;

          if (field.hasLerp && field.lerpInfo!.isStatic) {
            args[e.key] = refer(field.type).property('lerp').call([
              refer('value').property(field.name),
              refer('otherValue').property(field.name),
              refer('t'),
            ]).nullChecked;
          } else {
            args[e.key] = refer('otherValue').property(field.name);
          }
        }

        final v = refer(config.className).newInstance([], args).returned;

        return v;
      }());

    final result = Method((m) {
      m
        ..name = 'lerp'
        ..annotations.add(refer('override'))
        ..returns = themeExtensionRef()
        ..requiredParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'other'
              ..type = themeExtensionRef(isNullable: true),
          ),
          Parameter(
            (p) => p
              ..name = 't'
              ..type = refer('double'),
          ),
        ])
        ..body = body.build();
    });

    return result;
  }

  Method equalOperator(ThemeMixinConfig config) {
    // String equality(FieldSymbol field) {
    //   final name = field.name;
    //   return 'identical(value.$name, other.$name)';
    // }

    // final comparisons = [
    //   'other.runtimeType == runtimeType',
    //   'other is ${config.className}',
    //   for (final field in config.fields.values) equality(field),
    // ];

    // final body = Block(
    //   (b) => b.statements.addAll([
    //     if (config.fields.isNotEmpty)
    //       Code('final value = this as ${config.className};'),
    //     Code('return identical(this, other) || (${comparisons.join('&&')});'),
    //   ]),
    // );

    final body = BlockBuilder();
    final fields = config.fields;

    body.addExpression(
      declareFinal('value').assign(
        refer('this').asA(refer(config.className)),
      ),
    );

    final result = Method((m) {
      m
        ..name = 'operator =='
        ..annotations.add(refer('override'))
        ..returns = refer('bool')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'other'
              ..type = refer('Object'),
          ),
        )
        ..body = body.build();
    });

    return result;
  }

  @override
  String toString() {
    final themeExtensionRef = TypeReference(
      (t) => t
        ..symbol = 'ThemeExtension'
        ..types.add(refer(config.className)),
    );

    final mix = Mixin((m) {
      m
        ..name = r'_$ThemeExtensionMixin'
        ..on = themeExtensionRef;

      m.methods.addAll([
        copyWith(config),
        lerpMethod(config),
        equalOperator(config),
      ]);
    });

    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      useNullSafetySyntax: true,
      orderDirectives: true,
    );

    final formatter = DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
      pageWidth: DartFormatter.defaultPageWidth,
      trailingCommas: TrailingCommas.automate,
    );

    final dartCode = mix.accept(emitter).toString();
    final formattedCode = formatter.format(dartCode);

    print(formattedCode);

    // return dartCode;

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
    if (this == 'dynamic') {
      return this;
    }

    if (endsWith('?')) {
      return this;
    }

    return '$this?';
  }

  String asType() {
    if (this == 'dynamic') {
      return this;
    }

    if (endsWith('?')) {
      return replaceAll('?', '');
    }

    return this;
  }
}

Code ifCode(
  Code condition,
  List<Code> thenBody, [
  List<Code>? elseBody,
]) {
  final buf = StringBuffer();
  final conditionStr = condition.accept(DartEmitter());

  buf.writeln('if ($conditionStr) {');

  for (final c in thenBody) {
    buf.writeln('  ${c.accept(DartEmitter())}');
  }

  buf.write('}');

  if (elseBody != null && elseBody.isNotEmpty) {
    buf.writeln(' else {');
    for (final c in elseBody) {
      buf.writeln('  ${c.accept(DartEmitter())}');
    }
    buf.write('}');
  }

  return Code(buf.toString());
}
