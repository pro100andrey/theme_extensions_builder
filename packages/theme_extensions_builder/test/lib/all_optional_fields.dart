import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import 'empty_theme.dart';
import 'mock.dart';

part 'all_optional_fields.g.theme.dart';

@ShouldGenerateFile(
  'goldens/all_optional_fields.g.theme.dart',
  partOfCurrent: true,
)
@themeGen
final class AllOptionalFields with _$AllOptionalFields {
  const AllOptionalFields({
    this.title,
    this.shouldBuild,
    this.emptyTheme,
    this.width,
    this.height,
    this.canMerge = true,
    this.animationDuration,
    this.count,
    this.color,
  });

  final String? title;
  final bool Function()? shouldBuild;
  final EmptyTheme? emptyTheme;
  final double? width;
  final double? height;
  final Duration? animationDuration;
  final int? count;
  final Color? color;

  @override
  final bool canMerge;

  static AllOptionalFields? lerp(
    AllOptionalFields? a,
    AllOptionalFields? b,
    double t,
  ) => _$AllOptionalFields.lerp(a, b, t);
}
