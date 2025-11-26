import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../mock.dart';

part 'merge_case_theme.g.theme.dart';

@themeGen
final class MergeCaseTheme with _$MergeCaseTheme {
  const MergeCaseTheme({
    required this.borderSide,
    required this.hasBorder,
    this.borderSideOptional,
    this.isOptional,
    this.doubleValue = 0.0,
    this.doubleValueOptional,
  });

  final BorderSide borderSide;
  final BorderSide? borderSideOptional;
  final bool hasBorder;
  final bool? isOptional;
  final double doubleValue;
  final double? doubleValueOptional;

  static MergeCaseTheme? lerp(
    MergeCaseTheme? a,
    MergeCaseTheme? b,
    double t,
  ) => _$MergeCaseTheme.lerp(a, b, t);
}
