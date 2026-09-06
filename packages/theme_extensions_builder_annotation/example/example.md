# Example

The annotations do nothing on their own: `theme_extensions_builder` reads them
and writes the `copyWith`, `lerp`, `merge`, `==` and `hashCode` members into a
`.g.theme.dart` part file.

## A theme extension

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

@themeExtensions
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
  const AppTheme({
    required this.primaryColor,
    required this.spacing,
    this.borderRadius,
  });

  final Color primaryColor;
  final double spacing;
  final BorderRadius? borderRadius;
}

// Generated alongside the mixin:
// final theme = context.appTheme;
```

## A plain theme data class

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'button_theme_data.g.theme.dart';

@themeGen
class ButtonThemeData with _$ButtonThemeData {
  const ButtonThemeData({
    required this.backgroundColor,
    this.elevation = 2.0,
    this.debugLabel = '',
  });

  final Color backgroundColor;
  final double elevation;

  /// Left out of every generated member.
  @ignore
  final String debugLabel;

  static ButtonThemeData? lerp(
    ButtonThemeData? a,
    ButtonThemeData? b,
    double t,
  ) => _$ButtonThemeData.lerp(a, b, t);
}
```

See the [package README](https://github.com/pro100andrey/theme_extensions_builder/blob/main/packages/theme_extensions_builder/README.md)
for the generator setup and the full list of options.
