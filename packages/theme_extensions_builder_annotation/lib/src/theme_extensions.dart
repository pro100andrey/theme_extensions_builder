import 'package:meta/meta_meta.dart';

const themeExtensions = ThemeExtensions();

@Target({TargetKind.classType})
class ThemeExtensions {
  const ThemeExtensions({this.buildContextExtension = true});

  final bool buildContextExtension;
}
