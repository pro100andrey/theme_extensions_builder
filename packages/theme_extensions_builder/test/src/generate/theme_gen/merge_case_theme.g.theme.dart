// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'merge_case_theme.dart';

// **************************************************************************
// ThemeGenGenerator
// **************************************************************************

mixin _$MergeCaseTheme {
  bool get canMerge => true;

  static MergeCaseTheme? lerp(MergeCaseTheme? a, MergeCaseTheme? b, double t) {
    if (a == null && b == null) {
      return null;
    }

    return MergeCaseTheme(
      borderSide: BorderSide.lerp(
        a?.borderSide ?? b!.borderSide,
        b?.borderSide ?? a!.borderSide,
        t,
      ),
      hasBorder:
          (t < 0.5 ? a?.hasBorder : b?.hasBorder) ??
          (t < 0.5 ? b!.hasBorder : a!.hasBorder),
    );
  }

  MergeCaseTheme copyWith({BorderSide? borderSide, bool? hasBorder}) {
    final _this = (this as MergeCaseTheme);

    return MergeCaseTheme(
      borderSide: borderSide ?? _this.borderSide,
      hasBorder: hasBorder ?? _this.hasBorder,
    );
  }

  MergeCaseTheme merge(MergeCaseTheme? other) {
    final _this = (this as MergeCaseTheme);

    if (other == null) {
      return _this;
    }

    if (!other.canMerge) {
      return other;
    }

    return copyWith(
      borderSide: BorderSide.merge(_this.borderSide, other.borderSide),
      hasBorder: other.hasBorder,
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

    final _this = (this as MergeCaseTheme);
    final _other = (other as MergeCaseTheme);

    return _other.borderSide == _this.borderSide &&
        _other.hasBorder == _this.hasBorder;
  }

  @override
  int get hashCode {
    final _this = (this as MergeCaseTheme);

    return Object.hash(runtimeType, _this.borderSide, _this.hasBorder);
  }
}
