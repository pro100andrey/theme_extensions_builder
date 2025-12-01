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

## 🚀 Quick Start

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

## ✨ Features

- ✅ Automatic code generation for `ThemeExtension` classes
- ✅ BuildContext extensions for convenient theme access
- ✅ Type-safe theme management with full IDE support
- ✅ Supports complex types: Colors, TextStyles, EdgeInsets, Durations, enums, and custom types
- ✅ Smart lerp implementation with proper null handling

## 📖 Full Example

Check out the [example project](../packages/theme_extensions_builder/example) for a comprehensive Flutter app with:

- **5 Theme Extensions**: App, Button, Card, Typography, and Spacing themes
- **Theme Switching**: Seamless light/dark mode transitions
- **Custom Components**: Buttons, cards, and typography showcases
- **Best Practices**: Real-world organization patterns

## 📄 License

MIT License - see the [LICENSE](../LICENSE) file for details.
