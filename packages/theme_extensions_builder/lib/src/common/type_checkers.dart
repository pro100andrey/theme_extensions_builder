import 'package:source_gen/source_gen.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

/// The package the annotations come from.
///
/// Every checker is restricted to it: a user class that happens to be called
/// `ThemeGen` must not be mistaken for the annotation.
const annotationPackage = 'theme_extensions_builder_annotation';

/// Matches the `@ThemeGen` annotation.
const themeGenChecker = TypeChecker.typeNamed(
  ThemeGen,
  inPackage: annotationPackage,
);

/// Matches the `@ignore` annotation.
///
/// The annotation class is private, so it is reached through the constant.
final ignoreChecker = TypeChecker.typeNamed(
  ignore.runtimeType,
  inPackage: annotationPackage,
);
