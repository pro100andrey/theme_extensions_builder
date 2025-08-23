import 'package:meta/meta_meta.dart';

/// Fields marked with this annotation will be ignored by generator
const themeExtensions = ThemeExtensions();

/// An annotation used to specify a class to generate code for.
@Target({TargetKind.classType})
class ThemeExtensions {
  const ThemeExtensions({
    this.buildContextExtension = true,
    this.contextAccessorName,
  });

  /// Create getters for the easy access of the theme properties
  final bool buildContextExtension;

  /// The name of the context getter to be generated. By default, it will be
  /// the camelCase version of the class name.
  final String? contextAccessorName;
}
