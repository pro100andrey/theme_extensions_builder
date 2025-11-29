import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'empty_theme.g.theme.dart';

@ShouldGenerateFile(
  'goldens/empty_theme.g.theme.dart',
  partOfCurrent: true,
)
@themeGen
final class EmptyTheme with _$EmptyTheme {
  const EmptyTheme();

  @override
  bool get canMerge => true;

  static EmptyTheme? lerp(
    EmptyTheme? a,
    EmptyTheme? b,
    double t,
  ) => _$EmptyTheme.lerp(a, b, t);
}
