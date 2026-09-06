import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/common/symbols/field_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/lerp_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/merge_info.dart';
import 'package:theme_extensions_builder/src/config/config.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/code_builder.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/code_builder.dart';

/// Code paths that cannot be reached through the golden fixtures, either
/// because they need more fields than a readable fixture can hold, or because
/// they need a shape the stub classes don't provide.
void main() {
  group('hashCode strategy', () {
    test('no fields use runtimeType.hashCode', () {
      final code = _generate(const []);

      expect(code, contains('return runtimeType.hashCode;'));
    });

    test('19 fields use Object.hash', () {
      final code = _generate(_fields(19));

      expect(code, contains('Object.hash('));
      expect(code, isNot(contains('Object.hashAll(')));
    });

    test('20 fields use Object.hashAll', () {
      final code = _generate(_fields(20));

      expect(code, contains('Object.hashAll(['));
      expect(code, isNot(contains('Object.hash(')));
    });
  });

  group('constructor', () {
    test('a const constructor is invoked with const without fields', () {
      final code = _generate(const []);

      expect(code, contains('return const Theme();'));
    });

    test('a non-const constructor is invoked without const', () {
      final code = _generate(const [], constConstructor: false);

      expect(code, contains('return Theme();'));
      expect(code, isNot(contains('const Theme()')));
    });

    test('a const constructor is invoked without const with fields', () {
      final code = _generate([_field('value')]);

      expect(code, isNot(contains('const Theme(')));
    });

    test('a named constructor is used for every instantiation', () {
      final code = _generate([_field('value')], constructor: '_internal');

      expect(code, contains('Theme._internal(value: value ?? _this.value)'));
      expect(
        code,
        contains('Theme._internal(value: t < 0.5 ? a.value : b.value)'),
      );
    });
  });

  group('lerp', () {
    test('canMerge field takes the value of b', () {
      final code = _generate([
        _field('canMerge', typeName: 'bool'),
      ]);

      expect(code, contains('canMerge: b.canMerge'));
    });

    test('instance lerp with optional result on a non-nullable field', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          lerp: const InstanceLerp(optionalResult: true, needsCast: true),
        ),
      ]);

      expect(code, contains('(a.value.lerp(b.value, t) as Lerpable)'));
    });

    test('instance lerp with optional result is null checked', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          lerp: const InstanceLerp(optionalResult: true),
        ),
      ]);

      expect(code, contains('value: a.value.lerp(b.value, t)!'));
    });

    test('a result that already has the field type is not cast', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const InstanceLerp(optionalResult: true),
        ),
      ]);

      expect(code, contains('a.value!.lerp(b.value!, t)'));
      expect(code, isNot(contains('as Lerpable?')));
    });

    test('instance lerp on a nullable field keeps the endpoints', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const InstanceLerp(optionalResult: false, needsCast: true),
        ),
      ]);

      expect(
        code,
        contains(
          'a.value == null || b.value == null ? '
          't < 0.5 ? a.value : b.value : '
          '(a.value!.lerp(b.value!, t) as Lerpable?)',
        ),
      );
    });

    test('static lerp with a nullable result is null checked', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          lerp: const StaticLerp(
            optionalResult: true,
            isNullableParameter: false,
          ),
        ),
      ]);

      expect(code, contains('Lerpable.lerp(a.value, b.value, t)!'));
    });

    test('static lerp with a non-nullable result is not null checked', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          lerp: const StaticLerp(
            optionalResult: false,
            isNullableParameter: true,
          ),
        ),
      ]);

      expect(code, contains('value: Lerpable.lerp(a.value, b.value, t)'));
      expect(code, isNot(contains('Lerpable.lerp(a.value, b.value, t)!')));
    });

    test('static lerp taking non-nullable arguments is guarded', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const StaticLerp(
            optionalResult: false,
            isNullableParameter: false,
          ),
        ),
      ]);

      expect(
        code,
        contains(
          'a.value == null || b.value == null ? '
          't < 0.5 ? a.value : b.value : '
          'Lerpable.lerp(a.value!, b.value!, t)',
        ),
      );
    });

    test('the same guard is emitted for a theme extension', () {
      final code = _generateExtension([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const InstanceLerp(optionalResult: false, needsCast: true),
        ),
      ]);

      expect(
        code,
        contains(
          '_this.value == null || other.value == null ? '
          't < 0.5 ? _this.value : other.value : '
          '(_this.value!.lerp(other.value!, t) as Lerpable?)',
        ),
      );
    });

    test('a theme extension does not cast a result of the field type', () {
      final code = _generateExtension([
        _field(
          'value',
          typeName: 'Lerpable',
          lerp: const InstanceLerp(optionalResult: false),
        ),
      ]);

      expect(code, contains('value: _this.value.lerp(other.value, t)'));
      expect(code, isNot(contains('as Lerpable')));
    });

    test('a static call receiver drops the type arguments', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Box<int>',
          lerp: const StaticLerp(
            optionalResult: true,
            isNullableParameter: true,
          ),
        ),
      ]);

      expect(code, contains('Box.lerp(a.value, b.value, t)!'));
      expect(code, contains('Box<int>? value'));
    });

    test('a canMerge field of a theme extension is not special', () {
      final code = _generateExtension([
        _field('canMerge', typeName: 'bool'),
      ]);

      expect(
        code,
        contains('canMerge: t < 0.5 ? _this.canMerge : other.canMerge'),
      );
    });
  });

  group('merge', () {
    test('a static merge on a nullable field is guarded', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Mergeable',
          isNullable: true,
          merge: const StaticMerge(),
        ),
      ]);

      expect(
        code,
        contains(
          'value: _this.value == null ? other.value : '
          'other.value == null ? _this.value : '
          'Mergeable.merge(_this.value!, other.value!)',
        ),
      );
    });

    test('an instance merge returning a supertype is cast back', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Mergeable',
          merge: const InstanceMerge(needsCast: true),
        ),
      ]);

      expect(
        code,
        contains('value: (_this.value.merge(other.value) as Mergeable)'),
      );
    });
  });
}

/// Generates the mixin for [fields] and normalizes the emitter output.
///
/// The code builder emits unformatted code, so whitespace and the trailing
/// commas code_builder adds before a closing paren are collapsed to keep the
/// expectations readable.
String _generate(
  List<FieldInfo> fields, {
  String? constructor,
  bool constConstructor = true,
}) {
  final code = const ThemeGenCodeBuilder().generate(
    ThemeGenConfig(
      fields: fields,
      className: 'Theme',
      constructor: constructor,
      constConstructor: constConstructor,
    ),
  );

  return _normalize(code);
}

/// Collapses whitespace and the trailing commas code_builder adds before a
/// closing paren, so the expectations stay readable.
String _normalize(String code) =>
    code.replaceAll(RegExp(r',\s*\)'), ')').replaceAll(RegExp(r'\s+'), ' ');

/// Generates the mixin for a theme extension and normalizes the output the
/// same way [_generate] does.
String _generateExtension(List<FieldInfo> fields) => _normalize(
  const ThemeExtensionsCodeBuilder().generate(
    ThemeExtensionsConfig(
      fields: fields,
      className: 'Theme',
      constructor: null,
      buildContextExtension: false,
      contextAccessorName: null,
      themeExtensionMixinName: r'_$Theme',
      constConstructor: true,
    ),
  ),
);

List<FieldInfo> _fields(int count) => [
  for (var i = 0; i < count; i++) _field('field$i'),
];

FieldInfo _field(
  String name, {
  String typeName = 'int',
  bool isNullable = false,
  LerpInfo lerp = const NoLerp(),
  MergeInfo merge = const NoMerge(),
}) => FieldInfo(
  name: name,
  typeName: typeName,
  isNullable: isNullable,
  isDouble: false,
  isDuration: false,
  merge: merge,
  lerp: lerp,
);
