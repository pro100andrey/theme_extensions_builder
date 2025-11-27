import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../mock.dart';

part 'empty_theme_extension.g.theme.dart';

@ShouldGenerate(r'''
mixin _$EmptyThemeExtension on ThemeExtension<EmptyThemeExtension> {
  @override
  ThemeExtension<EmptyThemeExtension> copyWith() {
    return const EmptyThemeExtension();
  }

  @override
  ThemeExtension<EmptyThemeExtension> lerp(
    ThemeExtension<EmptyThemeExtension>? other,
    double t,
  ) {
    if (other is! EmptyThemeExtension) {
      return this;
    }

    return const EmptyThemeExtension();
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

extension EmptyThemeExtensionBuildContext on BuildContext {
  EmptyThemeExtension get emptyTheme =>
      Theme.of(this).extension<EmptyThemeExtension>()!;
}
''')
@themeExtensions
final class EmptyThemeExtension extends ThemeExtension<EmptyThemeExtension>
    with _$EmptyThemeExtension {
  const EmptyThemeExtension();
}
