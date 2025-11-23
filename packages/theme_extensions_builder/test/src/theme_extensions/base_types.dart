import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'theme_extension.dart';

@ShouldGenerate(r'''
mixin _$SimpleTheme on ThemeExtension<SimpleTheme> {
  @override
  ThemeExtension<SimpleTheme> copyWith({double? size, bool? isEnabled}) {
    final _this = (this as SimpleTheme);

    return SimpleTheme(
      size: size ?? _this.size,
      isEnabled: isEnabled ?? _this.isEnabled,
    );
  }

  @override
  ThemeExtension<SimpleTheme> lerp(
    ThemeExtension<SimpleTheme>? other,
    double t,
  ) {
    if (other is! SimpleTheme) {
      return this;
    }

    final _this = (this as SimpleTheme);

    return SimpleTheme(
      size: lerpDouble$(_this.size, other.size, t)!,
      isEnabled: t < 0.5 ? _this.isEnabled : other.isEnabled,
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

    final _this = (this as SimpleTheme);
    final _other = (other as SimpleTheme);

    return _other.size == _this.size && _other.isEnabled == _this.isEnabled;
  }

  @override
  int get hashCode {
    final _this = (this as SimpleTheme);

    return Object.hash(runtimeType, _this.size, _this.isEnabled);
  }
}

extension SimpleThemeBuildContext on BuildContext {
  SimpleTheme get simpleTheme => Theme.of(this).extension<SimpleTheme>()!;
}
''')
@ThemeExtensions()
class SimpleTheme with _$SimpleTheme {
  SimpleTheme({
    required this.size,
    this.isEnabled,
  });

  final double size;
  final bool isEnabled;
}
