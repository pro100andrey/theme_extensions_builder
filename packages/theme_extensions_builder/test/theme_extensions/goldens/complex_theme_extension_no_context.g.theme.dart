part of '../complex_theme_extension.dart';

mixin _$ComplexThemeExtensionNoContext
    on ThemeExtension<ComplexThemeExtensionNoContext> {
  @override
  ThemeExtension<ComplexThemeExtensionNoContext> copyWith({
    int? count,
    double? ratio,
    String? title,
    bool? isEnabled,
    Duration? duration,
    Color? color,
    BorderSide? borderSide,
    InvalidType? theme,
  }) {
    final _this = (this as ComplexThemeExtensionNoContext);

    return ComplexThemeExtensionNoContext._internal(
      count: count ?? _this.count,
      ratio: ratio ?? _this.ratio,
      title: title ?? _this.title,
      isEnabled: isEnabled ?? _this.isEnabled,
      duration: duration ?? _this.duration,
      color: color ?? _this.color,
      borderSide: borderSide ?? _this.borderSide,
      theme: theme ?? _this.theme,
    );
  }

  @override
  ThemeExtension<ComplexThemeExtensionNoContext> lerp(
    ThemeExtension<ComplexThemeExtensionNoContext>? other,
    double t,
  ) {
    if (other is! ComplexThemeExtensionNoContext) {
      return this;
    }

    final _this = (this as ComplexThemeExtensionNoContext);

    return ComplexThemeExtensionNoContext._internal(
      count: t < 0.5 ? _this.count : other.count,
      ratio: lerpDouble$(_this.ratio, other.ratio, t)!,
      title: t < 0.5 ? _this.title : other.title,
      isEnabled: t < 0.5 ? _this.isEnabled : other.isEnabled,
      duration: lerpDuration$(_this.duration, other.duration, t)!,
      color: Color.lerp(_this.color, other.color, t)!,
      borderSide: BorderSide.lerp(_this.borderSide, other.borderSide, t),
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

    final _this = (this as ComplexThemeExtensionNoContext);
    final _other = (other as ComplexThemeExtensionNoContext);

    return _other.count == _this.count &&
        _other.ratio == _this.ratio &&
        _other.title == _this.title &&
        _other.isEnabled == _this.isEnabled &&
        _other.duration == _this.duration &&
        _other.color == _this.color &&
        _other.borderSide == _this.borderSide &&
        _other.theme == _this.theme;
  }

  @override
  int get hashCode {
    final _this = (this as ComplexThemeExtensionNoContext);

    return Object.hash(
      runtimeType,
      _this.count,
      _this.ratio,
      _this.title,
      _this.isEnabled,
      _this.duration,
      _this.color,
      _this.borderSide,
      _this.theme,
    );
  }
}
