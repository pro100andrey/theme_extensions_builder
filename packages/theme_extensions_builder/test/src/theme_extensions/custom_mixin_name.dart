import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'theme_extension.dart';

@ShouldGenerate(r'''
mixin _$Custom on ThemeExtension<CustomMixinName> {
  @override
  ThemeExtension<CustomMixinName> copyWith({double? size, bool? isEnabled}) {
    final _this = (this as CustomMixinName);

    return CustomMixinName(
      size: size ?? _this.size,
      isEnabled: isEnabled ?? _this.isEnabled,
    );
  }

  @override
  ThemeExtension<CustomMixinName> lerp(
    ThemeExtension<CustomMixinName>? other,
    double t,
  ) {
    if (other is! CustomMixinName) {
      return this;
    }

    final _this = (this as CustomMixinName);

    return CustomMixinName(
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

    final _this = (this as CustomMixinName);
    final _other = (other as CustomMixinName);

    return _other.size == _this.size && _other.isEnabled == _this.isEnabled;
  }

  @override
  int get hashCode {
    final _this = (this as CustomMixinName);

    return Object.hash(runtimeType, _this.size, _this.isEnabled);
  }
}

extension CustomMixinNameBuildContext on BuildContext {
  CustomMixinName get customMixinName =>
      Theme.of(this).extension<CustomMixinName>()!;
}
''')
@ThemeExtensions()
class CustomMixinName with _$Custom {
  const CustomMixinName({
    required this.size,
    this.isEnabled,
  });

  final double size;
  final bool isEnabled;
}
