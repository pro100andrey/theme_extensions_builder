import 'package:meta/meta_meta.dart';

/// Fields marked with this annotation will be ignored by generator
const themeExtensions = ThemeExtensions();

/// An annotation used to specify a class to generate code for.
@Target({TargetKind.classType})
class ThemeExtensions {
  const ThemeExtensions({this.buildContextExtension = true});
  
  /// Create getters for the easy access of the theme properties
  final bool buildContextExtension;
}
