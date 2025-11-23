import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

@ShouldGenerate(r'''
mixin _$EmptyThemeGen {
  bool get canMerge => true;

  static EmptyThemeGen? lerp(EmptyThemeGen? a, EmptyThemeGen? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return EmptyThemeGen();
  }

  EmptyThemeGen copyWith() {
    return EmptyThemeGen();
  }

  EmptyThemeGen merge(EmptyThemeGen? other) {
    final _this = (this as EmptyThemeGen);

    if (other == null) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
''')
@ThemeGen()
class EmptyThemeGen with _$EmptyThemeGen {
  EmptyThemeGen();
}

@ShouldGenerate(r'''
mixin _$EmptyThemeGenWithConst {
  bool get canMerge => true;

  static EmptyThemeGenWithConst? lerp(
    EmptyThemeGenWithConst? a,
    EmptyThemeGenWithConst? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }

    return const EmptyThemeGenWithConst();
  }

  EmptyThemeGenWithConst copyWith() {
    return const EmptyThemeGenWithConst();
  }

  EmptyThemeGenWithConst merge(EmptyThemeGenWithConst? other) {
    final _this = (this as EmptyThemeGenWithConst);

    if (other == null) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
''')
@ThemeGen()
class EmptyThemeGenWithConst with _$EmptyThemeGenWithConst {
  const EmptyThemeGenWithConst();
}
