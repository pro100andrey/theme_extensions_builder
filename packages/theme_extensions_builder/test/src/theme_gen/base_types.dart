import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

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
