// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'empty_theme_extension.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

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
