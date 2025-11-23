import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

mixin _$EmptyThemeGen {} 
mixin _$EmptyThemeGenWithConst {}
mixin _$SimpleThemeGen {}

// Empty theme generation
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

// Empty theme generation with const constructor
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


@ShouldGenerate(r'''
mixin _$SimpleThemeGen {
  bool get canMerge => true;

  static SimpleThemeGen? lerp(SimpleThemeGen? a, SimpleThemeGen? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return SimpleThemeGen(
      size: lerpDouble$(a?.size, b?.size, t)!,
      name: t < 0.5 ? a?.name : b?.name,
    );
  }

  SimpleThemeGen copyWith({double? size, String? name}) {
    final _this = (this as SimpleThemeGen);

    return SimpleThemeGen(size: size ?? _this.size, name: name ?? _this.name);
  }

  SimpleThemeGen merge(SimpleThemeGen? other) {
    final _this = (this as SimpleThemeGen);

    if (other == null) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(size: other.size, name: other.name);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as SimpleThemeGen);
    final _other = (other as SimpleThemeGen);

    return _other.size == _this.size && _other.name == _this.name;
  }

  @override
  int get hashCode {
    final _this = (this as SimpleThemeGen);

    return Object.hash(runtimeType, _this.size, _this.name);
  }
}
''')
@ThemeGen()
class SimpleThemeGen with _$SimpleThemeGen {
  SimpleThemeGen({
    required this.size,
    this.name,
  });

  final double size;
  final String? name;
}
