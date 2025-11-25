import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../mock.dart';

part 'merge_case_theme.g.theme.dart';

@themeGen
final class MergeCaseTheme with _$MergeCaseTheme {
  const MergeCaseTheme({
    required this.borderSide,
  });

  final BorderSide borderSide;

  static MergeCaseTheme? lerp(
    MergeCaseTheme? a,
    MergeCaseTheme? b,
    double t,
  ) => _$MergeCaseTheme.lerp(a, b, t);
}
