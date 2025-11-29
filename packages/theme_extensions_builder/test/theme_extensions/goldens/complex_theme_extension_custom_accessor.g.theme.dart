part of '../complex_theme_extension.dart';

mixin _$ComplexThemeExtensionCustomAccessor
    on ThemeExtension<ComplexThemeExtensionCustomAccessor> {
  @override
  ThemeExtension<ComplexThemeExtensionCustomAccessor> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    double? spacing,
  }) {
    final _this = (this as ComplexThemeExtensionCustomAccessor);

    return ComplexThemeExtensionCustomAccessor(
      primaryColor: primaryColor ?? _this.primaryColor,
      secondaryColor: secondaryColor ?? _this.secondaryColor,
      spacing: spacing ?? _this.spacing,
    );
  }

  @override
  ThemeExtension<ComplexThemeExtensionCustomAccessor> lerp(
    ThemeExtension<ComplexThemeExtensionCustomAccessor>? other,
    double t,
  ) {
    if (other is! ComplexThemeExtensionCustomAccessor) {
      return this;
    }

    final _this = (this as ComplexThemeExtensionCustomAccessor);

    return ComplexThemeExtensionCustomAccessor(
      primaryColor: Color.lerp(_this.primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(_this.secondaryColor, other.secondaryColor, t),
      spacing: lerpDouble$(_this.spacing, other.spacing, t)!,
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

    final _this = (this as ComplexThemeExtensionCustomAccessor);
    final _other = (other as ComplexThemeExtensionCustomAccessor);

    return _other.primaryColor == _this.primaryColor &&
        _other.secondaryColor == _this.secondaryColor &&
        _other.spacing == _this.spacing;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeExtensionCustomAccessor);

    return Object.hash(
      runtimeType,
      _this.primaryColor,
      _this.secondaryColor,
      _this.spacing,
    );
  }
}

extension ComplexThemeExtensionCustomAccessorBuildContext on BuildContext {
  ComplexThemeExtensionCustomAccessor get myCustomTheme =>
      Theme.of(this).extension<ComplexThemeExtensionCustomAccessor>()!;
}
