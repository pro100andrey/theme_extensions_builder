// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'typography_theme.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$TypographyThemeExtension on ThemeExtension<TypographyThemeExtension> {
  @override
  ThemeExtension<TypographyThemeExtension> copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    TextStyle? codeStyle,
  }) {
    final _this = (this as TypographyThemeExtension);

    return TypographyThemeExtension(
      displayLarge: displayLarge ?? _this.displayLarge,
      displayMedium: displayMedium ?? _this.displayMedium,
      displaySmall: displaySmall ?? _this.displaySmall,
      headlineLarge: headlineLarge ?? _this.headlineLarge,
      headlineMedium: headlineMedium ?? _this.headlineMedium,
      headlineSmall: headlineSmall ?? _this.headlineSmall,
      bodyLarge: bodyLarge ?? _this.bodyLarge,
      bodyMedium: bodyMedium ?? _this.bodyMedium,
      bodySmall: bodySmall ?? _this.bodySmall,
      labelLarge: labelLarge ?? _this.labelLarge,
      labelMedium: labelMedium ?? _this.labelMedium,
      labelSmall: labelSmall ?? _this.labelSmall,
      codeStyle: codeStyle ?? _this.codeStyle,
    );
  }

  @override
  ThemeExtension<TypographyThemeExtension> lerp(
    ThemeExtension<TypographyThemeExtension>? other,
    double t,
  ) {
    if (other is! TypographyThemeExtension) {
      return this;
    }

    final _this = (this as TypographyThemeExtension);

    return TypographyThemeExtension(
      displayLarge: TextStyle.lerp(_this.displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(
        _this.displayMedium,
        other.displayMedium,
        t,
      )!,
      displaySmall: TextStyle.lerp(_this.displaySmall, other.displaySmall, t)!,
      headlineLarge: TextStyle.lerp(
        _this.headlineLarge,
        other.headlineLarge,
        t,
      )!,
      headlineMedium: TextStyle.lerp(
        _this.headlineMedium,
        other.headlineMedium,
        t,
      )!,
      headlineSmall: TextStyle.lerp(
        _this.headlineSmall,
        other.headlineSmall,
        t,
      )!,
      bodyLarge: TextStyle.lerp(_this.bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(_this.bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(_this.bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(_this.labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(_this.labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(_this.labelSmall, other.labelSmall, t)!,
      codeStyle: TextStyle.lerp(_this.codeStyle, other.codeStyle, t)!,
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

    final _this = (this as TypographyThemeExtension);
    final _other = (other as TypographyThemeExtension);

    return _other.displayLarge == _this.displayLarge &&
        _other.displayMedium == _this.displayMedium &&
        _other.displaySmall == _this.displaySmall &&
        _other.headlineLarge == _this.headlineLarge &&
        _other.headlineMedium == _this.headlineMedium &&
        _other.headlineSmall == _this.headlineSmall &&
        _other.bodyLarge == _this.bodyLarge &&
        _other.bodyMedium == _this.bodyMedium &&
        _other.bodySmall == _this.bodySmall &&
        _other.labelLarge == _this.labelLarge &&
        _other.labelMedium == _this.labelMedium &&
        _other.labelSmall == _this.labelSmall &&
        _other.codeStyle == _this.codeStyle;
  }

  @override
  int get hashCode {
    final _this = (this as TypographyThemeExtension);

    return Object.hash(
      runtimeType,
      _this.displayLarge,
      _this.displayMedium,
      _this.displaySmall,
      _this.headlineLarge,
      _this.headlineMedium,
      _this.headlineSmall,
      _this.bodyLarge,
      _this.bodyMedium,
      _this.bodySmall,
      _this.labelLarge,
      _this.labelMedium,
      _this.labelSmall,
      _this.codeStyle,
    );
  }
}

extension TypographyThemeExtensionBuildContext on BuildContext {
  TypographyThemeExtension get typographyTheme =>
      Theme.of(this).extension<TypographyThemeExtension>()!;
}
