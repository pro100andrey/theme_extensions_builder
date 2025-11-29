import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../theme_gen/empty_theme.dart';
import 'mock.dart';

part 'all_optional_parameters.g.theme.dart';

@ShouldGenerateFile(
  'goldens/all_optional_parameters.g.theme.dart',
  partOfCurrent: true,
)
@themeExtensions
final class AllOptionalParametersExtension
    extends ThemeExtension<AllOptionalParametersExtension>
    with _$AllOptionalParametersExtension {
  const AllOptionalParametersExtension({
    required this.count,
    required this.ratio,
    required this.title,
    required this.isActive,
    required this.duration,
    required this.theme,
  });

  final int? count;
  final double? ratio;
  final String? title;
  final bool? isActive;
  final Duration? duration;
  final EmptyTheme? theme;
}
