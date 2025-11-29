part of '../all_optional_fields.dart';

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
      width: lerpDouble$(a.width, b.width, t),
      height: lerpDouble$(a.height, b.height, t),
      animationDuration: lerpDuration$(
        a.animationDuration,
        b.animationDuration,
        t,
      ),
      count: t < 0.5 ? a.count : b.count,
      color: Color.lerp(a.color, b.color, t),
      canMerge: b.canMerge,
    );
  }

  AllOptionalFields copyWith({
    String? title,
    bool Function()? shouldBuild,
    EmptyTheme? emptyTheme,
    double? width,
    double? height,
    Duration? animationDuration,
    int? count,
    Color? color,
    bool? canMerge,
  }) {
    final _this = (this as AllOptionalFields);

    return AllOptionalFields(
      title: title ?? _this.title,
      shouldBuild: shouldBuild ?? _this.shouldBuild,
      emptyTheme: emptyTheme ?? _this.emptyTheme,
      width: width ?? _this.width,
      height: height ?? _this.height,
      animationDuration: animationDuration ?? _this.animationDuration,
      count: count ?? _this.count,
      color: color ?? _this.color,
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
      width: other.width,
      height: other.height,
      animationDuration: other.animationDuration,
      count: other.count,
      color: other.color,
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
        _other.width == _this.width &&
        _other.height == _this.height &&
        _other.animationDuration == _this.animationDuration &&
        _other.count == _this.count &&
        _other.color == _this.color &&
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
      _this.width,
      _this.height,
      _this.animationDuration,
      _this.count,
      _this.color,
      _this.canMerge,
    );
  }
}
