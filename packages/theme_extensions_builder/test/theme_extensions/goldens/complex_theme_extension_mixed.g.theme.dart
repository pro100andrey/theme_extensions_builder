part of '../complex_theme_extension.dart';

mixin _$ComplexThemeExtensionMixed
    on ThemeExtension<ComplexThemeExtensionMixed> {
  @override
  ThemeExtension<ComplexThemeExtensionMixed> copyWith({
    String? title,
    int? count,
    double? ratio,
    bool? isActive,
    Duration? duration,
    InvalidType? theme,
  }) {
    final _this = (this as ComplexThemeExtensionMixed);

    return ComplexThemeExtensionMixed(
      title: title ?? _this.title,
      count: count ?? _this.count,
      ratio: ratio ?? _this.ratio,
      isActive: isActive ?? _this.isActive,
      duration: duration ?? _this.duration,
      theme: theme ?? _this.theme,
    );
  }

  @override
  ThemeExtension<ComplexThemeExtensionMixed> lerp(
    ThemeExtension<ComplexThemeExtensionMixed>? other,
    double t,
  ) {
    if (other is! ComplexThemeExtensionMixed) {
      return this;
    }

    final _this = (this as ComplexThemeExtensionMixed);

    return ComplexThemeExtensionMixed(
      title: t < 0.5 ? _this.title : other.title,
      count: t < 0.5 ? _this.count : other.count,
      ratio: lerpDouble$(_this.ratio, other.ratio, t)!,
      isActive: t < 0.5 ? _this.isActive : other.isActive,
      duration: lerpDuration$(_this.duration, other.duration, t)!,
      theme: t < 0.5 ? _this.theme : other.theme,
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

    final _this = (this as ComplexThemeExtensionMixed);
    final _other = (other as ComplexThemeExtensionMixed);

    return _other.title == _this.title &&
        _other.count == _this.count &&
        _other.ratio == _this.ratio &&
        _other.isActive == _this.isActive &&
        _other.duration == _this.duration &&
        _other.theme == _this.theme;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeExtensionMixed);

    return Object.hash(
      runtimeType,
      _this.title,
      _this.count,
      _this.ratio,
      _this.isActive,
      _this.duration,
      _this.theme,
    );
  }
}

extension ComplexThemeExtensionMixedBuildContext on BuildContext {
  ComplexThemeExtensionMixed get complexThemeExtensionMixed =>
      Theme.of(this).extension<ComplexThemeExtensionMixed>()!;
}
