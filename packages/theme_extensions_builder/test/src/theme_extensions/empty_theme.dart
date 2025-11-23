import 'package:source_gen_test/annotations.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'theme_extension.dart';

@ShouldGenerate(r'''
mixin _$EmptyTheme on ThemeExtension<EmptyTheme> {
  @override
  ThemeExtension<EmptyTheme> copyWith() {
    return EmptyTheme();
  }

  @override
  ThemeExtension<EmptyTheme> lerp(ThemeExtension<EmptyTheme>? other, double t) {
    if (other is! EmptyTheme) {
      return this;
    }

    return EmptyTheme();
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

extension EmptyThemeBuildContext on BuildContext {
  EmptyTheme get emptyTheme => Theme.of(this).extension<EmptyTheme>()!;
}
''')
@ThemeExtensions()
class EmptyTheme with _$EmptyTheme {
  EmptyTheme();
}

@ShouldGenerate(r'''
mixin _$EmptyThemeWithConst on ThemeExtension<EmptyThemeWithConst> {
  @override
  ThemeExtension<EmptyThemeWithConst> copyWith() {
    return const EmptyThemeWithConst();
  }

  @override
  ThemeExtension<EmptyThemeWithConst> lerp(
    ThemeExtension<EmptyThemeWithConst>? other,
    double t,
  ) {
    if (other is! EmptyThemeWithConst) {
      return this;
    }

    return const EmptyThemeWithConst();
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

extension EmptyThemeWithConstBuildContext on BuildContext {
  EmptyThemeWithConst get emptyThemeWithConst =>
      Theme.of(this).extension<EmptyThemeWithConst>()!;
}
''')
@ThemeExtensions()
class EmptyThemeWithConst with _$EmptyThemeWithConst {
  const EmptyThemeWithConst();
}

@ShouldGenerate(r'''
mixin _$EmptyThemeNoExtension on ThemeExtension<EmptyThemeNoExtension> {
  @override
  ThemeExtension<EmptyThemeNoExtension> copyWith() {
    return EmptyThemeNoExtension();
  }

  @override
  ThemeExtension<EmptyThemeNoExtension> lerp(
    ThemeExtension<EmptyThemeNoExtension>? other,
    double t,
  ) {
    if (other is! EmptyThemeNoExtension) {
      return this;
    }

    return EmptyThemeNoExtension();
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
@ThemeExtensions(buildContextExtension: false)
class EmptyThemeNoExtension with _$EmptyThemeNoExtension {
  EmptyThemeNoExtension();
}
