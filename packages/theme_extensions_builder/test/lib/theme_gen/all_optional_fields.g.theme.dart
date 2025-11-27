// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'all_optional_fields.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$AllOptionalFields {
  bool get canMerge => true;

  static AllOptionalFields? lerp(
    AllOptionalFields? a,
    AllOptionalFields? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null && b == null) {
      return null;
    }

    if (a == null) {
      return t == 1.0 ? b : null;
    }

    if (b == null) {
      return t == 0.0 ? a : null;
    }

    return AllOptionalFields(
      title: t < 0.5 ? a.title : b.title,
      shouldBuild: t < 0.5 ? a.shouldBuild : b.shouldBuild,
      emptyTheme: EmptyTheme.lerp(a.emptyTheme, b.emptyTheme, t),
      canMerge: b.canMerge,
    );
  }

  AllOptionalFields copyWith({
    String? title,
    bool Function()? shouldBuild,
    EmptyTheme? emptyTheme,
    bool? canMerge,
  }) {
    final _this = (this as AllOptionalFields);

    return AllOptionalFields(
      title: title ?? _this.title,
      shouldBuild: shouldBuild ?? _this.shouldBuild,
      emptyTheme: emptyTheme ?? _this.emptyTheme,
      canMerge: canMerge ?? _this.canMerge,
    );
  }

  AllOptionalFields merge(AllOptionalFields? other) {
    final _this = (this as AllOptionalFields);

    if (other == null || identical(_this, other)) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      title: other.title,
      shouldBuild: other.shouldBuild,
      emptyTheme: _this.emptyTheme?.merge(other.emptyTheme) ?? other.emptyTheme,
      canMerge: other.canMerge,
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

    final _this = (this as AllOptionalFields);
    final _other = (other as AllOptionalFields);

    return _other.title == _this.title &&
        _other.shouldBuild == _this.shouldBuild &&
        _other.emptyTheme == _this.emptyTheme &&
        _other.canMerge == _this.canMerge;
  }

  @override
  int get hashCode {
    final _this = (this as AllOptionalFields);

    return Object.hash(
      runtimeType,
      _this.title,
      _this.shouldBuild,
      _this.emptyTheme,
      _this.canMerge,
    );
  }
}
