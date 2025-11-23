import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'theme_extension.dart';

@ShouldGenerate(r'''
mixin _$NullableTheme on ThemeExtension<NullableTheme> {
  @override
  ThemeExtension<NullableTheme> copyWith({
    double? width,
    double? height,
    String? title,
  }) {
    final _this = (this as NullableTheme);

    return NullableTheme(
      width: width ?? _this.width,
      height: height ?? _this.height,
      title: title ?? _this.title,
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
        _other.title == _this.title;
  }

  @override
  int get hashCode {
    final _this = (this as NullableTheme);

    return Object.hash(runtimeType, _this.width, _this.height, _this.title);
  }
}

extension NullableThemeBuildContext on BuildContext {
  NullableTheme get nullableTheme => Theme.of(this).extension<NullableTheme>()!;
}
''')
@ThemeExtensions()
class NullableTheme with _$NullableTheme {
  const NullableTheme({
    this.width,
    this.height,
    this.title,
  });

  final double? width;
  final double? height;
  final String? title;
}
