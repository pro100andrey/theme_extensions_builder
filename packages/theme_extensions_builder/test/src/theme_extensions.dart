import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'mock.dart';

mixin _$NullableTheme {}

@ShouldGenerate(r'''
mixin _$NullableTheme on ThemeExtension<NullableTheme> {
  @override
  ThemeExtension<NullableTheme> copyWith({
    double? width,
    double? height,
    String? title,
    Color? color,
  }) {
    final _this = (this as NullableTheme);

    return NullableTheme(
      width: width ?? _this.width,
      height: height ?? _this.height,
      title: title ?? _this.title,
      color: color ?? _this.color,
    );
  }

  @override
  ThemeExtension<NullableTheme> lerp(
    ThemeExtension<NullableTheme>? other,
    double t,
  ) {
    if (other is! NullableTheme) {
      return this;
    }

    final _this = (this as NullableTheme);

    return NullableTheme(
      width: lerpDouble$(_this.width, other.width, t),
      height: lerpDouble$(_this.height, other.height, t),
      title: t < 0.5 ? _this.title : other.title,
      color: Color.lerp(_this.color, other.color, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    final _this = (this as NullableTheme);
    final _other = (other as NullableTheme);

    return _other.width == _this.width &&
        _other.height == _this.height &&
        _other.title == _this.title &&
        _other.color == _this.color;
  }

  @override
  int get hashCode {
    final _this = (this as NullableTheme);

    return Object.hash(
      runtimeType,
      _this.width,
      _this.height,
      _this.title,
      _this.color,
    );
  }
}

extension NullableThemeBuildContext on BuildContext {
  NullableTheme get nullableTheme => Theme.of(this).extension<NullableTheme>()!;
}
''')
@ThemeExtensions()
class NullableTheme extends ThemeExtension<NullableTheme> with _$NullableTheme {
  const NullableTheme({
    this.width,
    this.height,
    this.title,
    this.color,
  });

  final double? width;
  final double? height;
  final String? title;
  final Color? color;
}
