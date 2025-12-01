import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'mock.dart';

part 'empty_theme_extension.g.theme.dart';

@themeExtensions
final class EmptyThemeExtension extends ThemeExtension<EmptyThemeExtension>
    with _$EmptyThemeExtension {
  const EmptyThemeExtension();
}
