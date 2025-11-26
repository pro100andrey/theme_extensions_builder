import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../mock.dart';

part 'merge_case_theme.g.theme.dart';

@themeGen
final class MergeCaseTheme with _$MergeCaseTheme {
  const MergeCaseTheme({
    required this.borderSide,
    required this.hasBorder,
  });

  final BorderSide borderSide;
  final bool hasBorder;

  static MergeCaseTheme? lerp(
    MergeCaseTheme? a,
    MergeCaseTheme? b,
    double t,
  ) => _$MergeCaseTheme.lerp(a, b, t);
}
