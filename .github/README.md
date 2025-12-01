# theme_extensions_builder

[![pub package](https://img.shields.io/pub/v/theme_extensions_builder.svg)](https://pub.dev/packages/theme_extensions_builder)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> 📖 **Full documentation**: [packages/theme_extensions_builder/README.md](../packages/theme_extensions_builder/README.md)

**theme_extensions_builder** is a powerful code generator for Flutter's `ThemeExtension` classes. It eliminates boilerplate code by automatically generating `copyWith`, `lerp`, `==`, and `hashCode` methods, along with convenient `BuildContext` extensions for easy theme access.

## 🎯 Quick Links

- 📚 [Full Documentation](../packages/theme_extensions_builder/README.md)
- 🎨 [Example Project](../packages/theme_extensions_builder/example)
- 📦 [pub.dev Package](https://pub.dev/packages/theme_extensions_builder)
- 🐛 [Report Issues](https://github.com/pro100andrey/theme_extensions_builder/issues)

## 📦 Installation

Add the packages to your project:

```bash
flutter pub add theme_extensions_builder_annotation
flutter pub add --dev theme_extensions_builder
flutter pub add --dev build_runner
```

Or add to `pubspec.yaml`:

```yaml
dependencies:
  theme_extensions_builder_annotation: ^7.0.0

dev_dependencies:
  build_runner: ^2.10.4
  theme_extensions_builder: ^7.0.0
```

## 🚀 Quick Start

### Using @ThemeExtensions

For classes extending `ThemeExtension`:

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeMixin {
  const AppTheme({
    required this.primaryColor,
    required this.spacing,
  });

  final Color primaryColor;
  final double spacing;
}
```

Generate code:

```bash
dart run build_runner build
```

Use in your app:

```dart
Widget build(BuildContext context) {
  final theme = context.appTheme;
  
  return Container(
    padding: EdgeInsets.all(theme.spacing),
    color: theme.primaryColor,
  );
}
```

### Using @ThemeGen

For standalone theme data classes:

```dart
@ThemeGen()
class ButtonThemeData with _$ButtonThemeData {
  const ButtonThemeData({
    required this.backgroundColor,
    this.borderRadius = 8.0,
  });

  final Color backgroundColor;
  final double borderRadius;

  static ButtonThemeData? lerp(ButtonThemeData? a, ButtonThemeData? b, double t) =>
      _$ButtonThemeData.lerp(a, b, t);
}
```

## 📋 Choose Your Annotation

### @ThemeExtensions (Recommended)

For classes extending Flutter's `ThemeExtension` - ideal for most use cases.

**Perfect for:**

- Full Flutter theme integration
- Automatic theme switching with lerp animations
- Easy access via BuildContext (e.g., `context.appTheme`)

**Generates:**

- Complete `ThemeExtension` implementation with `copyWith` and `lerp`
- BuildContext extension for convenient access
- Equality operators and hashCode

### @ThemeGen

For standalone theme data classes without `ThemeExtension` inheritance.

**Perfect for:**

- Custom theme systems outside standard Flutter themes
- Maximum control over class structure
- Nested theme data objects

**Generates:**

- `copyWith` and `merge` methods
- Static `lerp` method
- Equality operators and hashCode

---

## 📖 Example

Check out the [example project](../packages/theme_extensions_builder/example) for a comprehensive Flutter app with:

- **5 Theme Extensions**: App, Button, Card, Typography, and Spacing themes
- **Theme Switching**: Seamless light/dark mode transitions
- **Custom Components**: Buttons, cards, and typography showcases
- **Best Practices**: Real-world organization patterns

## 📄 License

MIT License - see the [LICENSE](../LICENSE) file for details.
