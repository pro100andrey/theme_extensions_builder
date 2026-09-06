part of '../empty_theme_extension.dart';

mixin _$EmptyThemeExtensionNonConst
    on ThemeExtension<EmptyThemeExtensionNonConst> {
  @override
  ThemeExtension<EmptyThemeExtensionNonConst> copyWith() {
    return EmptyThemeExtensionNonConst();
  }

  @override
  ThemeExtension<EmptyThemeExtensionNonConst> lerp(
    ThemeExtension<EmptyThemeExtensionNonConst>? other,
    double t,
  ) {
    if (other is! EmptyThemeExtensionNonConst) {
      return this;
    }

    return EmptyThemeExtensionNonConst();
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

extension EmptyThemeExtensionNonConstBuildContext on BuildContext {
  EmptyThemeExtensionNonConst get emptyThemeExtensionNonConst =>
      Theme.of(this).extension<EmptyThemeExtensionNonConst>()!;
}
