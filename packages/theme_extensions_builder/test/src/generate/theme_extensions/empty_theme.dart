import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../mock.dart';

part 'empty_theme.g.theme.dart';

@themeExtensions
final class EmptyThemeExtension extends ThemeExtension<EmptyThemeExtension>
    with _$EmptyThemeExtension {
  const EmptyThemeExtension({
    required this.property,
  });

  final String property;
}
