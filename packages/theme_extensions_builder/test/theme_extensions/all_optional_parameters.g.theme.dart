// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'all_optional_parameters.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$AllOptionalParametersExtension
    on ThemeExtension<AllOptionalParametersExtension> {
  @override
  ThemeExtension<AllOptionalParametersExtension> copyWith({
    int? count,
    double? ratio,
    String? title,
    bool? isActive,
    Duration? duration,
  }) {
    final _this = (this as AllOptionalParametersExtension);

    return AllOptionalParametersExtension(
      count: count ?? _this.count,
      ratio: ratio ?? _this.ratio,
      title: title ?? _this.title,
      isActive: isActive ?? _this.isActive,
      duration: duration ?? _this.duration,
    );
  }

  @override
  ThemeExtension<AllOptionalParametersExtension> lerp(
    ThemeExtension<AllOptionalParametersExtension>? other,
    double t,
  ) {
    if (other is! AllOptionalParametersExtension) {
      return this;
    }

    final _this = (this as AllOptionalParametersExtension);

    return AllOptionalParametersExtension(
      count: t < 0.5 ? _this.count : other.count,
      ratio: lerpDouble$(_this.ratio, other.ratio, t),
      title: t < 0.5 ? _this.title : other.title,
      isActive: t < 0.5 ? _this.isActive : other.isActive,
      duration: lerpDuration$(_this.duration, other.duration, t),
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

    final _this = (this as AllOptionalParametersExtension);
    final _other = (other as AllOptionalParametersExtension);

    return _other.count == _this.count &&
        _other.ratio == _this.ratio &&
        _other.title == _this.title &&
        _other.isActive == _this.isActive &&
        _other.duration == _this.duration;
  }

  @override
  int get hashCode {
    final _this = (this as AllOptionalParametersExtension);

    return Object.hash(
      runtimeType,
      _this.count,
      _this.ratio,
      _this.title,
      _this.isActive,
      _this.duration,
    );
  }
}

extension AllOptionalParametersExtensionBuildContext on BuildContext {
  AllOptionalParametersExtension get allOptionalParameters =>
      Theme.of(this).extension<AllOptionalParametersExtension>()!;
}
