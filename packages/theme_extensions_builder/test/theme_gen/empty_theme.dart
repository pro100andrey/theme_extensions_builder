import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'empty_theme.g.theme.dart';

/// Empty Theme - testing edge case with no fields
@ShouldGenerateFile('goldens/empty_theme.g.theme.dart', partOfCurrent: true)
@themeGen
final class EmptyTheme with _$EmptyTheme {
  const EmptyTheme();

  @override
  bool get canMerge => true;

  static EmptyTheme? lerp(EmptyTheme? a, EmptyTheme? b, double t) =>
      _$EmptyTheme.lerp(a, b, t);
}

/// Empty Theme - testing edge case with no fields
/// (non-const constructor)
@ShouldGenerateFile(
  'goldens/empty_theme_non_const.g.theme.dart',
  partOfCurrent: true,
)
@themeGen
final class EmptyThemeNonConst with _$EmptyThemeNonConst {
  const EmptyThemeNonConst();

  @override
  bool get canMerge => true;

  static EmptyThemeNonConst? lerp(
    EmptyThemeNonConst? a,
    EmptyThemeNonConst? b,
    double t,
  ) => _$EmptyThemeNonConst.lerp(a, b, t);
}
