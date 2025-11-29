import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../mock.dart';

part 'empty_theme_extension.g.theme.dart';

@ShouldGenerateFile(
  'goldens/empty_theme_extension.g.theme.dart',
  partOfCurrent: true,
)
@themeExtensions
final class EmptyThemeExtension extends ThemeExtension<EmptyThemeExtension>
    with _$EmptyThemeExtension {
  const EmptyThemeExtension();
}
