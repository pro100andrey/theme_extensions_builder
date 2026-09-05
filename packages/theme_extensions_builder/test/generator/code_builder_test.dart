import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/common/symbols/field_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/lerp_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/merge_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/parameter_info.dart';
import 'package:theme_extensions_builder/src/config/config.dart';
import 'package:theme_extensions_builder/src/generator/theme_extensions/code_builder.dart';
import 'package:theme_extensions_builder/src/generator/theme_gen/code_builder.dart';

/// Code paths that cannot be reached through the golden fixtures, either
/// because they need more fields than a readable fixture can hold, or because
/// they need a shape the mock classes don't provide.
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
          lerp: const InstanceLerp(optionalResult: true, args: [_nullableArg]),
        ),
      ]);

      expect(code, contains('(a.value.lerp(b.value, t) as Lerpable)'));
    });

    test('instance lerp with non-optional result on a nullable field', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const InstanceLerp(optionalResult: false, args: [_nullableArg]),
        ),
      ]);

      expect(code, contains('(a.value?.lerp(b.value, t) as Lerpable?)'));
    });

    test('instance lerp taking a non-nullable argument is guarded', () {
      final code = _generate([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const InstanceLerp(
            optionalResult: false,
            args: [_nonNullableArg],
          ),
        ),
      ]);

      expect(
        code,
        contains(
          'a.value == null ? b.value : b.value == null ? a.value : '
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
            args: [_nonNullableArg, _nonNullableArg],
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
            args: [_nullableArg, _nullableArg],
          ),
        ),
      ]);

      expect(code, contains('value: Lerpable.lerp(a.value, b.value, t)'));
      expect(code, isNot(contains('Lerpable.lerp(a.value, b.value, t)!')));
    });

    test('the same guard is emitted for a theme extension', () {
      final code = _generateExtension([
        _field(
          'value',
          typeName: 'Lerpable',
          isNullable: true,
          lerp: const InstanceLerp(
            optionalResult: false,
            args: [_nonNullableArg],
          ),
        ),
      ]);

      expect(
        code,
        contains(
          '_this.value == null ? other.value : other.value == null ? '
          '_this.value : (_this.value!.lerp(other.value!, t) as Lerpable?)',
        ),
      );
    });
  });
}

const _nullableArg = ParameterInfo(
  name: 'other',
  type: 'Lerpable',
  isNullable: true,
);

const _nonNullableArg = ParameterInfo(
  name: 'other',
  type: 'Lerpable',
  isNullable: false,
);

/// Generates the mixin for [fields] and normalizes the emitter output.
///
/// The code builder emits unformatted code, so whitespace and the trailing
/// commas code_builder adds before a closing paren are collapsed to keep the
/// expectations readable.
String _generate(List<FieldInfo> fields) {
  final code = const ThemeGenCodeBuilder().generate(
    ThemeGenConfig(
      fields: fields,
      className: 'Theme',
      constructor: null,
      constConstructor: true,
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
}) => FieldInfo(
  name: name,
  typeName: typeName,
  isNullable: isNullable,
  isDouble: false,
  isDuration: false,
  merge: const NoMerge(),
  lerp: lerp,
  isStatic: false,
);
