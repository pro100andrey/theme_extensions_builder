import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'empty_theme.dart';
import 'empty_theme_extension.dart';
import 'mock.dart';

part 'merge_case_theme.g.theme.dart';

@ShouldGenerateFile(
  'goldens/merge_case_theme.g.theme.dart',
  partOfCurrent: true,
)
@themeGen
final class MergeCaseTheme with _$MergeCaseTheme {
  const MergeCaseTheme({
    required this.borderSide,
    required this.hasBorder,
    required this.borderSideOptional,
    required this.theme,
    required this.optionalTheme,
    required this.themeExtension,
    required this.optionalThemeExtension,
    required this.isOptional,
    required this.doubleValue,
    required this.doubleValueOptional,
    required this.duration,
  });

  final BorderSide borderSide;
  final BorderSide? borderSideOptional;
  final EmptyTheme theme;
  final EmptyTheme? optionalTheme;
  final EmptyThemeExtension themeExtension;
  final EmptyThemeExtension? optionalThemeExtension;
  final bool hasBorder;
  final bool? isOptional;
  final double doubleValue;
  final double? doubleValueOptional;
  final Duration duration;

  static MergeCaseTheme? lerp(
    MergeCaseTheme? a,
    MergeCaseTheme? b,
    double t,
  ) => _$MergeCaseTheme.lerp(a, b, t);
}
