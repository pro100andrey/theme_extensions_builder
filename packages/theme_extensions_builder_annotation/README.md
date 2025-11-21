# theme_extensions_builder_annotation

[![pub package](https://img.shields.io/pub/v/theme_extensions_builder_annotation.svg)](https://pub.dev/packages/theme_extensions_builder_annotation)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Annotations for [theme_extensions_builder](https://pub.dev/packages/theme_extensions_builder)** - a code generator for Flutter's `ThemeExtension` classes.

## 📦 Overview

This package provides annotations that work with `theme_extensions_builder` to automatically generate boilerplate code for Flutter theme extensions. It contains no logic itself and must be used together with the `theme_extensions_builder` package.

## 🚀 Installation

Add this package to your dependencies:

```bash
flutter pub add theme_extensions_builder_annotation
```

Or manually in `pubspec.yaml`:

```yaml
dependencies:
  theme_extensions_builder_annotation: ^7.0.0
```

**Note**: You also need to add `theme_extensions_builder` as a dev dependency. See the [theme_extensions_builder documentation](https://pub.dev/packages/theme_extensions_builder) for complete setup instructions.

## 📚 Available Annotations

### @ThemeExtensions

The main annotation for generating `ThemeExtension` classes with full functionality.

**Usage:**

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'my_theme.g.theme.dart';

@ThemeExtensions()
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeMixin {
  const MyTheme({
    required this.primaryColor,
    required this.spacing,
  });

  final Color primaryColor;
  final double spacing;
}
```

**Parameters:**

- `buildContextExtension` (bool, default: `true`) - Generate a BuildContext extension for easy theme access
- `contextAccessorName` (String?, default: `null`) - Custom name for the context accessor
- `constructor` (String?, default: `null`) - Name of the constructor to use

**Examples:**

```dart
// Custom context accessor name
@ThemeExtensions(contextAccessorName: 'customTheme')
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeMixin {
  // Access via: context.customTheme
}

// Disable BuildContext extension
@ThemeExtensions(buildContextExtension: false)
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeMixin {
  // Manual access: Theme.of(context).extension<MyTheme>()!
}

// Custom constructor
@ThemeExtensions(constructor: '_internal')
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeMixin {
  const MyTheme._internal({required this.primaryColor});
  
  final Color primaryColor;
  
  factory MyTheme({required Color primaryColor}) = MyTheme._internal;
}
```

### @ThemeGen

Alternative annotation for theme data classes that don't extend `ThemeExtension`.

**Usage:**

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'alert_theme.g.theme.dart';

@ThemeGen()
class AlertThemeData with _$AlertThemeData {
  const AlertThemeData({
    this.duration = const Duration(milliseconds: 300),
    this.padding,
    this.textStyle,
  });

  final Duration duration;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  static AlertThemeData lerp(AlertThemeData? a, AlertThemeData? b, double t) =>
      _$AlertThemeData.lerp(a, b, t);
}
```

**Parameters:**

- `constructor` (String?, default: `null`) - Name of the constructor to use

### Constants

For convenience, you can use the constant annotation:

```dart
// Instead of @ThemeExtensions()
@themeExtensions
class MyTheme extends ThemeExtension<MyTheme> with _$MyThemeMixin {
  // ...
}

// Instead of @ThemeGen()
@themeGen
class MyThemeData with _$MyThemeData {
  // ...
}
```

## 🔗 Related Packages

- [theme_extensions_builder](https://pub.dev/packages/theme_extensions_builder) - The code generator (dev dependency)
- [build_runner](https://pub.dev/packages/build_runner) - Required to run the code generation

## 📖 Full Documentation

For complete documentation, examples, and advanced usage, see:

- [theme_extensions_builder README](https://pub.dev/packages/theme_extensions_builder)
- [GitHub Repository](https://github.com/pro100andrey/theme_extensions_builder)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Visit the [GitHub repository](https://github.com/pro100andrey/theme_extensions_builder) to contribute.
