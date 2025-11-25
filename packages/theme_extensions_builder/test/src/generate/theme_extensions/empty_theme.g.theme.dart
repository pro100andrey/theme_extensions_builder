// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'empty_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$EmptyThemeExtension on ThemeExtension<EmptyThemeExtension> {
  @override
  ThemeExtension<EmptyThemeExtension> copyWith({String? property}) {
    final _this = (this as EmptyThemeExtension);

    return EmptyThemeExtension(property: property ?? _this.property);
  }

  @override
  ThemeExtension<EmptyThemeExtension> lerp(
    ThemeExtension<EmptyThemeExtension>? other,
    double t,
  ) {
    if (other is! EmptyThemeExtension) {
      return this;
    }

    final _this = (this as EmptyThemeExtension);

    return EmptyThemeExtension(
      property: t < 0.5 ? _this.property : other.property,
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

    final _this = (this as EmptyThemeExtension);
    final _other = (other as EmptyThemeExtension);

    return _other.property == _this.property;
  }

  @override
  int get hashCode {
    final _this = (this as EmptyThemeExtension);

    return Object.hash(runtimeType, _this.property);
  }
}

extension EmptyThemeExtensionBuildContext on BuildContext {
  EmptyThemeExtension get emptyTheme =>
      Theme.of(this).extension<EmptyThemeExtension>()!;
}
