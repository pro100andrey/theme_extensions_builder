import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'empty_theme.dart';

part 'all_optional_fields.g.theme.dart';

@ShouldGenerate(r'''
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
''')
@themeGen
final class AllOptionalFields with _$AllOptionalFields {
  const AllOptionalFields({
    this.title = 'Default Title',
    this.shouldBuild = _defaultShouldBuild,
    this.emptyTheme = const EmptyTheme(),
    this.canMerge = true,
  });

  final String? title;
  final bool Function()? shouldBuild;
  final EmptyTheme? emptyTheme;

  @override
  final bool canMerge;

  static AllOptionalFields? lerp(
    AllOptionalFields? a,
    AllOptionalFields? b,
    double t,
  ) => _$AllOptionalFields.lerp(a, b, t);
}

bool _defaultShouldBuild() => true;
