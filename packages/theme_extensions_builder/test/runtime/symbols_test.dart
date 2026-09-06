// Several tests build values without `const` on purpose: two identical const
// expressions are canonicalized into the same object, which would make the
// equality checks trivially true.
// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/common/symbols/field_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/lerp_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/merge_info.dart';

void main() {
  group('StaticLerp', () {
    test('creates StaticLerp with properties', () {
      const lerp = StaticLerp(optionalResult: true, isNullableParameter: true);

      expect(lerp.optionalResult, true);
      expect(lerp.isNullableParameter, true);
    });

    test('equality works correctly', () {
      final lerp1 = StaticLerp(optionalResult: true, isNullableParameter: true);
      final lerp2 = StaticLerp(optionalResult: true, isNullableParameter: true);
      final lerp3 = StaticLerp(
        optionalResult: true,
        isNullableParameter: false,
      );
      final lerp4 = StaticLerp(
        optionalResult: false,
        isNullableParameter: true,
      );

      expect(lerp1, equals(lerp2));
      expect(lerp1.hashCode, equals(lerp2.hashCode));
      expect(lerp1, isNot(equals(lerp3)));
      expect(lerp1, isNot(equals(lerp4)));
    });

    test('toString returns correct format', () {
      const lerp = StaticLerp(optionalResult: true, isNullableParameter: false);

      expect(
        lerp.toString(),
        'StaticLerp(optionalResult: true, isNullableParameter: false)',
      );
    });
  });

  group('InstanceLerp', () {
    test('creates InstanceLerp with properties', () {
      const lerp = InstanceLerp(optionalResult: true);

      expect(lerp.optionalResult, true);
      expect(lerp.needsCast, false);
    });

    test('equality works correctly', () {
      final lerp1 = InstanceLerp(optionalResult: true);
      final lerp2 = InstanceLerp(optionalResult: true);
      final lerp3 = InstanceLerp(optionalResult: false);

      expect(lerp1, equals(lerp2));
      expect(lerp1.hashCode, equals(lerp2.hashCode));
      expect(lerp1, isNot(equals(lerp3)));
    });

    test('needsCast takes part in equality', () {
      final plain = InstanceLerp(optionalResult: true);
      final cast = InstanceLerp(optionalResult: true, needsCast: true);

      expect(plain, isNot(equals(cast)));
      expect(plain.hashCode, isNot(equals(cast.hashCode)));
    });

    test('toString returns correct format', () {
      const lerp = InstanceLerp(optionalResult: false);

      expect(
        lerp.toString(),
        'InstanceLerp(optionalResult: false, needsCast: false)',
      );
    });
  });

  group('WidgetStatePropertyLerp', () {
    WidgetStatePropertyLerp build({
      String genericType = 'Color',
      bool isNullableGeneric = true,
      bool genericIsDouble = false,
      bool genericIsDuration = false,
    }) => WidgetStatePropertyLerp(
      baseTypeName: 'WidgetStateProperty',
      genericType: genericType,
      isNullableGeneric: isNullableGeneric,
      genericIsDouble: genericIsDouble,
      genericIsDuration: genericIsDuration,
    );

    test('reports the generic type', () {
      expect(build().genericIsDouble, isFalse);
      expect(build().genericIsDuration, isFalse);
      expect(build(genericIsDouble: true).genericIsDouble, isTrue);
      expect(build(genericIsDuration: true).genericIsDuration, isTrue);
    });

    test('the inner lerp receiver drops the type arguments', () {
      expect(build().genericBaseTypeName, 'Color');
      expect(build(genericType: 'Box<int>').genericBaseTypeName, 'Box');
    });

    test('equality works correctly', () {
      expect(build(), equals(build()));
      expect(build().hashCode, equals(build().hashCode));
      expect(build(), isNot(equals(build(genericType: 'double'))));
      expect(build(), isNot(equals(build(isNullableGeneric: false))));
    });

    test('toString returns correct format', () {
      expect(
        build().toString(),
        'WidgetStatePropertyLerp('
        'baseTypeName: WidgetStateProperty, '
        'genericType: Color, '
        'isNullableGeneric: true)',
      );
    });
  });

  group('NoLerp', () {
    test('creates NoLerp', () {
      const lerp = NoLerp();
      expect(lerp, isA<LerpInfo>());
    });

    test('equality works correctly', () {
      final lerp1 = NoLerp();
      final lerp2 = NoLerp();

      expect(lerp1, equals(lerp2));
      expect(lerp1.hashCode, equals(lerp2.hashCode));
    });

    test('toString returns correct format', () {
      const lerp = NoLerp();
      expect(lerp.toString(), 'NoLerp()');
    });
  });

  group('MergeInfo', () {
    test('NoMerge equality works', () {
      final merge1 = NoMerge();
      final merge2 = NoMerge();

      expect(merge1, equals(merge2));
      expect(merge1.hashCode, equals(merge2.hashCode));
    });

    test('StaticMerge equality works', () {
      final merge1 = StaticMerge();
      final merge2 = StaticMerge();

      expect(merge1, equals(merge2));
      expect(merge1.hashCode, equals(merge2.hashCode));
    });

    test('InstanceMerge equality works', () {
      final merge1 = InstanceMerge();
      final merge2 = InstanceMerge();
      const merge3 = InstanceMerge(isNullableParameter: false);
      const merge4 = InstanceMerge(needsCast: true);

      expect(merge1, equals(merge2));
      expect(merge1.hashCode, equals(merge2.hashCode));
      expect(merge1, isNot(equals(merge3)));
      expect(merge1, isNot(equals(merge4)));
    });

    test('different merge methods are not equal', () {
      const noMerge = NoMerge();
      const staticMerge = StaticMerge();
      const instanceMerge = InstanceMerge();

      expect(noMerge, isNot(equals(staticMerge)));
      expect(staticMerge, isNot(equals(instanceMerge)));
      expect(noMerge, isNot(equals(instanceMerge)));
    });

    test('toString returns correct format', () {
      const noMerge = NoMerge();
      const staticMerge = StaticMerge();
      const instanceMerge = InstanceMerge();

      expect(noMerge.toString(), 'NoMerge()');
      expect(staticMerge.toString(), 'StaticMerge()');
      expect(
        instanceMerge.toString(),
        'InstanceMerge(isNullableParameter: true, needsCast: false)',
      );
    });
  });

  group('FieldInfo', () {
    FieldInfo build({
      String name = 'value',
      String typeName = 'int',
      bool isNullable = false,
      bool isDouble = false,
      bool isDuration = false,
      MergeInfo merge = const NoMerge(),
      LerpInfo lerp = const NoLerp(),
    }) => FieldInfo(
      name: name,
      typeName: typeName,
      isNullable: isNullable,
      isDouble: isDouble,
      isDuration: isDuration,
      merge: merge,
      lerp: lerp,
    );

    test('creates FieldInfo with all properties', () {
      final field = build(name: 'color', typeName: 'Color', isNullable: true);

      expect(field.name, 'color');
      expect(field.typeName, 'Color');
      expect(field.isNullable, true);
      expect(field.isDouble, false);
      expect(field.isDuration, false);
      expect(field.merge, isA<NoMerge>());
      expect(field.lerp, isA<NoLerp>());
    });

    test('the static call receiver drops the type arguments', () {
      expect(build(typeName: 'Box<int>').baseTypeName, 'Box');
      expect(build(typeName: 'Color').baseTypeName, 'Color');
    });

    test('equality works correctly with same properties', () {
      expect(build(), equals(build()));
      expect(build().hashCode, equals(build().hashCode));
    });

    test('equality returns false with different properties', () {
      expect(build(), isNot(equals(build(name: 'other'))));
      expect(build(), isNot(equals(build(typeName: 'double'))));
      expect(build(), isNot(equals(build(isNullable: true))));
      expect(build(), isNot(equals(build(isDouble: true))));
      expect(build(), isNot(equals(build(isDuration: true))));
      expect(build(), isNot(equals(build(merge: const StaticMerge()))));
      expect(
        build(),
        isNot(
          equals(
            build(
              lerp: const StaticLerp(
                optionalResult: true,
                isNullableParameter: true,
              ),
            ),
          ),
        ),
      );
    });

    test('toString returns readable format', () {
      expect(
        build().toString(),
        'FieldInfo(name: value, '
        'typeName: int, '
        'isNullable: false, '
        'isDouble: false, '
        'isDuration: false, '
        'merge: NoMerge(), '
        'lerp: NoLerp())',
      );
    });
  });
}
