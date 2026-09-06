// Several tests build values without `const` on purpose: two identical const
// expressions are canonicalized into the same object, which would make the
// equality checks trivially true.
// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:theme_extensions_builder/src/common/symbols/field_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/lerp_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/merge_info.dart';
import 'package:theme_extensions_builder/src/common/symbols/parameter_info.dart'
    show ParameterInfo;

void main() {
  group('ParameterInfo', () {
    test('creates ParameterInfo with required properties', () {
      const arg = ParameterInfo(
        name: 'value',
        type: 'String',
        isNullable: true,
      );

      expect(arg.name, 'value');
      expect(arg.type, 'String');
      expect(arg.isNullable, true);
    });

    test('equality works correctly', () {
      const arg1 = ParameterInfo(name: 'a', type: 'int', isNullable: false);
      const arg2 = ParameterInfo(name: 'a', type: 'int', isNullable: false);
      const arg3 = ParameterInfo(name: 'b', type: 'int', isNullable: false);

      expect(arg1, equals(arg2));
      expect(arg1, isNot(equals(arg3)));
    });

    test('hashCode works correctly', () {
      const arg1 = ParameterInfo(name: 'a', type: 'int', isNullable: false);
      const arg2 = ParameterInfo(name: 'a', type: 'int', isNullable: false);

      expect(arg1.hashCode, equals(arg2.hashCode));
    });

    test('toString returns readable format', () {
      const arg = ParameterInfo(name: 'test', type: 'double', isNullable: true);
      expect(
        arg.toString(),
        'ParameterInfo(name: test, type: double, isNullable: true)',
      );
    });
  });

  group('StaticLerp', () {
    test('creates StaticLerp with properties', () {
      const lerp = StaticLerp(
        optionalResult: true,
        args: [
          ParameterInfo(name: 'a', type: 'Color', isNullable: true),
          ParameterInfo(name: 'b', type: 'Color', isNullable: true),
          ParameterInfo(name: 't', type: 'double', isNullable: false),
        ],
      );

      expect(lerp.optionalResult, true);
      expect(lerp.args.length, 3);
    });

    test('isNullableParameter is independent of the result nullability', () {
      const nullableArgs = [
        ParameterInfo(name: 'a', type: 'Color', isNullable: true),
        ParameterInfo(name: 'b', type: 'Color', isNullable: true),
        ParameterInfo(name: 't', type: 'double', isNullable: false),
      ];

      const optional = StaticLerp(optionalResult: true, args: nullableArgs);
      const nonOptional = StaticLerp(optionalResult: false, args: nullableArgs);

      expect(optional.isNullableParameter, true);
      expect(nonOptional.isNullableParameter, true);
    });

    test('isNullableParameter returns false when first arg not nullable', () {
      const lerp = StaticLerp(
        optionalResult: true,
        args: [
          ParameterInfo(name: 'a', type: 'Color', isNullable: false),
          ParameterInfo(name: 'b', type: 'Color', isNullable: true),
          ParameterInfo(name: 't', type: 'double', isNullable: false),
        ],
      );

      expect(lerp.isNullableParameter, false);
    });

    test('isNullableParameter handles empty args safely', () {
      const lerp = StaticLerp(optionalResult: true, args: []);

      expect(lerp.isNullableParameter, false);
    });

    test('isNullableParameter handles single arg safely', () {
      const lerp = StaticLerp(
        optionalResult: true,
        args: [ParameterInfo(name: 'a', type: 'Color', isNullable: true)],
      );

      expect(lerp.isNullableParameter, false);
    });

    test('equality works correctly', () {
      // Built without `const` so the instances are not canonicalized and
      // operator== is actually exercised.
      final lerp1 = StaticLerp(
        optionalResult: true,
        args: [ParameterInfo(name: 'a', type: 'int', isNullable: false)],
      );
      final lerp2 = StaticLerp(
        optionalResult: true,
        args: [ParameterInfo(name: 'a', type: 'int', isNullable: false)],
      );
      final lerp3 = StaticLerp(
        optionalResult: true,
        args: [ParameterInfo(name: 'b', type: 'int', isNullable: false)],
      );
      final lerp4 = StaticLerp(
        optionalResult: false,
        args: [ParameterInfo(name: 'a', type: 'int', isNullable: false)],
      );

      expect(lerp1, equals(lerp2));
      expect(lerp1.hashCode, equals(lerp2.hashCode));
      expect(lerp1, isNot(equals(lerp3)));
      expect(lerp1, isNot(equals(lerp4)));
    });

    test('toString returns correct format', () {
      const lerp = StaticLerp(optionalResult: true, args: []);

      expect(lerp.toString(), 'StaticLerp(optionalResult: true, args: [])');
    });
  });

  group('InstanceLerp', () {
    test('creates InstanceLerp with properties', () {
      const lerp = InstanceLerp(
        optionalResult: true,
        args: [
          ParameterInfo(name: 'other', type: 'Color', isNullable: false),
          ParameterInfo(name: 't', type: 'double', isNullable: false),
        ],
      );

      expect(lerp.optionalResult, true);
      expect(lerp.args.length, 2);
    });

    test('equality works correctly', () {
      final lerp1 = InstanceLerp(
        optionalResult: true,
        args: [ParameterInfo(name: 'a', type: 'int', isNullable: false)],
      );
      final lerp2 = InstanceLerp(
        optionalResult: true,
        args: [ParameterInfo(name: 'a', type: 'int', isNullable: false)],
      );
      final lerp3 = InstanceLerp(
        optionalResult: false,
        args: [ParameterInfo(name: 'a', type: 'int', isNullable: false)],
      );

      expect(lerp1, equals(lerp2));
      expect(lerp1.hashCode, equals(lerp2.hashCode));
      expect(lerp1, isNot(equals(lerp3)));
    });

    test('toString returns correct format', () {
      const lerp = InstanceLerp(optionalResult: false, args: []);

      expect(
        lerp.toString(),
        'InstanceLerp(optionalResult: false, needsCast: false, args: [])',
      );
    });

    test('needsCast takes part in equality', () {
      final plain = InstanceLerp(optionalResult: true, args: []);
      final cast = InstanceLerp(
        optionalResult: true,
        args: [],
        needsCast: true,
      );

      expect(plain, isNot(equals(cast)));
      expect(plain.hashCode, isNot(equals(cast.hashCode)));
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
    test('creates FieldInfo with all properties', () {
      const field = FieldInfo(
        name: 'color',
        typeName: 'Color',
        isNullable: true,
        isDouble: false,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      expect(field.name, 'color');
      expect(field.typeName, 'Color');
      expect(field.isNullable, true);
      expect(field.isDouble, false);
      expect(field.isDuration, false);
      expect(field.merge, isA<NoMerge>());
      expect(field.lerp, isA<NoLerp>());
      expect(field.isStatic, false);
    });

    test('equality works correctly with same properties', () {
      const field1 = FieldInfo(
        name: 'value',
        typeName: 'int',
        isNullable: false,
        isDouble: false,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      const field2 = FieldInfo(
        name: 'value',
        typeName: 'int',
        isNullable: false,
        isDouble: false,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      expect(field1, equals(field2));
    });

    test('equality returns false with different properties', () {
      const field1 = FieldInfo(
        name: 'value',
        typeName: 'int',
        isNullable: false,
        isDouble: false,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      const field2 = FieldInfo(
        name: 'other',
        typeName: 'int',
        isNullable: false,
        isDouble: false,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      expect(field1, isNot(equals(field2)));
    });

    test('hashCode is consistent', () {
      const field1 = FieldInfo(
        name: 'test',
        typeName: 'String',
        isNullable: true,
        isDouble: false,
        isDuration: false,
        merge: StaticMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      const field2 = FieldInfo(
        name: 'test',
        typeName: 'String',
        isNullable: true,
        isDouble: false,
        isDuration: false,
        merge: StaticMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      expect(field1.hashCode, equals(field2.hashCode));
    });

    test('toString returns readable format', () {
      const field = FieldInfo(
        name: 'duration',
        typeName: 'Duration',
        isNullable: false,
        isDouble: false,
        isDuration: true,
        merge: InstanceMerge(),
        lerp: StaticLerp(optionalResult: false, args: []),
        isStatic: false,
      );

      final string = field.toString();
      expect(string, contains('duration'));
      expect(string, contains('Duration'));
      expect(string, contains('isDuration: true'));
    });

    test('works with different lerp methods', () {
      const field1 = FieldInfo(
        name: 'x',
        typeName: 'double',
        isNullable: false,
        isDouble: true,
        isDuration: false,
        merge: NoMerge(),
        lerp: StaticLerp(optionalResult: false, args: []),
        isStatic: false,
      );

      const field2 = FieldInfo(
        name: 'x',
        typeName: 'double',
        isNullable: false,
        isDouble: true,
        isDuration: false,
        merge: NoMerge(),
        lerp: InstanceLerp(optionalResult: false, args: []),
        isStatic: false,
      );

      expect(field1, isNot(equals(field2)));
    });
  });

  group('Edge cases and boundaries', () {
    test('StaticLerp with exactly 2 args works', () {
      const lerp = StaticLerp(
        optionalResult: true,
        args: [
          ParameterInfo(name: 'a', type: 'int', isNullable: true),
          ParameterInfo(name: 'b', type: 'int', isNullable: true),
        ],
      );

      expect(lerp.isNullableParameter, true);
    });

    test('StaticLerp with 3+ args checks first two', () {
      const lerp = StaticLerp(
        optionalResult: true,
        args: [
          ParameterInfo(name: 'a', type: 'int', isNullable: true),
          ParameterInfo(name: 'b', type: 'int', isNullable: true),
          ParameterInfo(name: 'c', type: 'double', isNullable: false),
          ParameterInfo(name: 'd', type: 'String', isNullable: true),
        ],
      );

      expect(lerp.isNullableParameter, true);
    });

    test('FieldInfo with isDouble true', () {
      const field = FieldInfo(
        name: 'opacity',
        typeName: 'double',
        isNullable: false,
        isDouble: true,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      expect(field.isDouble, true);
      expect(field.isDuration, false);
    });

    test('FieldInfo with isDuration true', () {
      const field = FieldInfo(
        name: 'timeout',
        typeName: 'Duration',
        isNullable: false,
        isDouble: false,
        isDuration: true,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: false,
      );

      expect(field.isDouble, false);
      expect(field.isDuration, true);
    });

    test('FieldInfo with isStatic true', () {
      const field = FieldInfo(
        name: 'constant',
        typeName: 'int',
        isNullable: false,
        isDouble: false,
        isDuration: false,
        merge: NoMerge(),
        lerp: NoLerp(),
        isStatic: true,
      );

      expect(field.isStatic, true);
    });
  });
}
