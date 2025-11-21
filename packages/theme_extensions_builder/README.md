# theme_extensions_builder

[![pub package](https://img.shields.io/pub/v/theme_extensions_builder.svg)](https://pub.dev/packages/theme_extensions_builder)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**theme_extensions_builder** is a powerful code generator for Flutter's `ThemeExtension` classes. It eliminates boilerplate code by automatically generating `copyWith`, `lerp`, `==`, and `hashCode` methods, along with convenient `BuildContext` extensions for easy theme access.

## 🎯 Features

- ✅ **Automatic code generation** for `ThemeExtension` classes
- ✅ **BuildContext extensions** for convenient theme access
- ✅ **Type-safe theme management** with full IDE support
- ✅ **Supports complex types**: Colors, TextStyles, EdgeInsets, Durations, enums, and custom types
- ✅ **Customizable constructor names** for advanced use cases
- ✅ **Smart lerp implementation** with proper null handling
- ✅ **Two annotation types**: `@ThemeExtensions` and `@ThemeGen`

## 📦 Installation

Add these packages to your project:

```bash
flutter pub add --dev build_runner
flutter pub add --dev theme_extensions_builder
flutter pub add theme_extensions_builder_annotation
```

Or add manually to `pubspec.yaml`:

```yaml
dependencies:
  theme_extensions_builder_annotation: ^7.0.0

dev_dependencies:
  build_runner: ^2.4.0
  theme_extensions_builder: ^7.0.0
```

## 🚀 Quick Start

### 1. Import and Setup

Create a Dart file with the necessary imports and part directive:

```dart
// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';
```

> **Important**: The part file must follow the pattern `<filename>.g.theme.dart`

### 2. Define Your Theme Extension

```dart
@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeMixin {
  const AppTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.spacing,
    this.borderRadius,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final double spacing;
  final BorderRadius? borderRadius;
}
```

### 3. Generate Code

Run the build runner:

```bash
# One-time generation
dart run build_runner build

# Watch mode (rebuilds on file changes)
dart run build_runner watch
```

### 4. Use Your Theme

Add the extension to your `ThemeData`:

```dart
final lightTheme = ThemeData.light().copyWith(
  extensions: [
    AppTheme(
      primaryColor: Colors.blue,
      secondaryColor: Colors.green,
      spacing: 16.0,
      borderRadius: BorderRadius.circular(8.0),
    ),
  ],
);

final darkTheme = ThemeData.dark().copyWith(
  extensions: [
    AppTheme(
      primaryColor: Colors.indigo,
      secondaryColor: Colors.teal,
      spacing: 16.0,
      borderRadius: BorderRadius.circular(8.0),
    ),
  ],
);
```

Access the theme in your widgets:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Generated BuildContext extension for easy access
    final appTheme = context.appTheme;
    
    return Container(
      padding: EdgeInsets.all(appTheme.spacing),
      decoration: BoxDecoration(
        color: appTheme.primaryColor,
        borderRadius: appTheme.borderRadius,
      ),
      child: Text('Hello World'),
    );
  }
}
```

## 📚 Documentation

### @ThemeExtensions Annotation

The primary annotation for generating `ThemeExtension` classes with full functionality.

#### Basic Usage

```dart
@ThemeExtensions()
class ButtonTheme extends ThemeExtension<ButtonTheme> with _$ButtonThemeMixin {
  const ButtonTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius,
    this.padding,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
}
```

#### Custom Context Accessor Name

```dart
@ThemeExtensions(contextAccessorName: 'customButtonTheme')
class ButtonTheme extends ThemeExtension<ButtonTheme> with _$ButtonThemeMixin {
  // ...
}

// Usage:
final theme = context.customButtonTheme; // Instead of context.buttonTheme
```

#### Disable BuildContext Extension

```dart
@ThemeExtensions(buildContextExtension: false)
class ButtonTheme extends ThemeExtension<ButtonTheme> with _$ButtonThemeMixin {
  // ...
}

// Manual access required:
final theme = Theme.of(context).extension<ButtonTheme>()!;
```

#### Custom Constructor

```dart
@ThemeExtensions(constructor: '_internal')
class ButtonTheme extends ThemeExtension<ButtonTheme> with _$ButtonThemeMixin {
  const ButtonTheme._internal({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;

  // Factory constructor for user convenience
  factory ButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) = ButtonTheme._internal;
}
```

### @ThemeGen Annotation

Alternative annotation for theme data classes that don't extend `ThemeExtension`.

```dart
@ThemeGen()
class AlertThemeData with _$AlertThemeData {
  const AlertThemeData({
    this.transitionDuration = const Duration(milliseconds: 300),
    this.iconPadding,
    this.titleTextStyle,
    this.borderRadius,
  });

  final Duration transitionDuration;
  final EdgeInsetsGeometry? iconPadding;
  final TextStyle? titleTextStyle;
  final double? borderRadius;

  static AlertThemeData lerp(AlertThemeData? a, AlertThemeData? b, double t) =>
      _$AlertThemeData.lerp(a, b, t);
}
```

### Generated Code

The generator creates:

1. **Mixin with methods**:
   - `copyWith()` - Create a copy with modified fields
   - `lerp()` - Interpolate between two theme instances
   - `operator ==` - Equality comparison
   - `hashCode` - Hash code for collections

2. **BuildContext extension** (if enabled):
   - Convenient getter for accessing the theme

**Example of generated code**:

```dart
mixin _$ButtonThemeMixin on ThemeExtension<ButtonTheme> {
  @override
  ThemeExtension<ButtonTheme> copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    final object = this as ButtonTheme;
    return ButtonTheme(
      backgroundColor: backgroundColor ?? object.backgroundColor,
      foregroundColor: foregroundColor ?? object.foregroundColor,
      borderRadius: borderRadius ?? object.borderRadius,
      padding: padding ?? object.padding,
    );
  }

  @override
  ThemeExtension<ButtonTheme> lerp(
    ThemeExtension<ButtonTheme>? other,
    double t,
  ) {
    if (other is! ButtonTheme) return this;
    final value = this as ButtonTheme;
    return ButtonTheme(
      backgroundColor: Color.lerp(value.backgroundColor, other.backgroundColor, t)!,
      foregroundColor: Color.lerp(value.foregroundColor, other.foregroundColor, t)!,
      borderRadius: BorderRadius.lerp(value.borderRadius, other.borderRadius, t),
      padding: EdgeInsets.lerp(value.padding, other.padding, t),
    );
  }

  @override
  bool operator ==(Object other) {
    final value = this as ButtonTheme;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ButtonTheme &&
            identical(value.backgroundColor, other.backgroundColor) &&
            identical(value.foregroundColor, other.foregroundColor) &&
            identical(value.borderRadius, other.borderRadius) &&
            identical(value.padding, other.padding));
  }

  @override
  int get hashCode {
    final value = this as ButtonTheme;
    return Object.hash(
      runtimeType,
      value.backgroundColor,
      value.foregroundColor,
      value.borderRadius,
      value.padding,
    );
  }
}

extension ButtonThemeBuildContext on BuildContext {
  ButtonTheme get buttonTheme => Theme.of(this).extension<ButtonTheme>()!;
}
```

## 🎨 Advanced Examples

### Complex Theme with Multiple Types

```dart
enum LayoutMode { compact, expanded }

@ThemeExtensions()
class AppThemeExtension extends ThemeExtension<AppThemeExtension>
    with _$AppThemeExtensionMixin {
  const AppThemeExtension({
    required this.primaryColor,
    required this.layoutMode,
    required this.insets,
    required this.radius,
    this.animation = const Duration(milliseconds: 300),
    this.padding = const EdgeInsets.all(8),
  });

  final Color primaryColor;
  final LayoutMode layoutMode;
  final EdgeInsets insets;
  final Duration? animation;
  final double radius;
  final EdgeInsetsGeometry? padding;
}
```

### Multiple Theme Extensions

You can define multiple theme extensions in the same project:

```dart
// lib/theme/colors.dart
@ThemeExtensions()
class AppColors extends ThemeExtension<AppColors> with _$AppColorsMixin {
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.error,
  });

  final Color primary;
  final Color secondary;
  final Color error;
}

// lib/theme/typography.dart
@ThemeExtensions()
class AppTypography extends ThemeExtension<AppTypography> with _$AppTypographyMixin {
  const AppTypography({
    required this.heading,
    required this.body,
    required this.caption,
  });

  final TextStyle heading;
  final TextStyle body;
  final TextStyle caption;
}

// Usage in ThemeData
final theme = ThemeData.light().copyWith(
  extensions: [
    AppColors(
      primary: Colors.blue,
      secondary: Colors.green,
      error: Colors.red,
    ),
    AppTypography(
      heading: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      body: TextStyle(fontSize: 16),
      caption: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  ],
);
```

### Nested Theme Extensions

```dart
// Custom nested theme extension
class SubTextTheme extends ThemeExtension<SubTextTheme> {
  const SubTextTheme({
    required this.color,
    required this.fontSize,
  });

  final Color color;
  final double fontSize;

  @override
  ThemeExtension<SubTextTheme> copyWith({Color? color, double? fontSize}) =>
      SubTextTheme(
        color: color ?? this.color,
        fontSize: fontSize ?? this.fontSize,
      );

  @override
  ThemeExtension<SubTextTheme> lerp(
    ThemeExtension<SubTextTheme>? other,
    double t,
  ) {
    if (other is! SubTextTheme) return this;
    return SubTextTheme(
      color: Color.lerp(color, other.color, t)!,
      fontSize: lerpDouble(fontSize, other.fontSize, t)!,
    );
  }
}

// Main theme using nested extension
@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppThemeMixin {
  const AppTheme({
    required this.primaryColor,
    required this.subTextTheme,
  });

  final Color primaryColor;
  final SubTextTheme subTextTheme;
}
```

## 🛠️ IDE Configuration

### VS Code - File Nesting

Add to your `.vscode/settings.json` to automatically nest generated files:

```json
{
  "explorer.fileNesting.enabled": true,
  "explorer.fileNesting.patterns": {
    "*.dart": "${capture}.g.theme.dart"
  }
}
```

### Android Studio / IntelliJ IDEA

1. Go to **Settings** → **Editor** → **File Nesting**
2. Add pattern: `*.dart` → `${name}.g.theme.dart`

## 📦 Packages

This project consists of two packages:

- [theme_extensions_builder](packages/theme_extensions_builder) - The code generator
- [theme_extensions_builder_annotation](packages/theme_extensions_builder_annotation) - Annotations

## 📖 Example

Check out the [example project](packages/theme_extensions_builder/example) for a complete working implementation with:

- Multiple theme extensions
- Light and dark themes
- Theme switching
- Complex types usage

## 🔧 Build Configuration

### build.yaml (Optional)

You can customize the build configuration:

```yaml
targets:
  $default:
    builders:
      theme_extensions_builder:
        enabled: true
        options:
          # Add custom options here if needed
```

## ⚡ Tips and Best Practices

1. **Use descriptive names**: Name your theme extensions clearly (e.g., `ButtonTheme`, `CardTheme`)
2. **Group related properties**: Keep related styling properties in the same extension
3. **Use nullable fields wisely**: Make fields nullable only when they truly need to be optional
4. **Leverage watch mode**: Use `build_runner watch` during development for automatic regeneration
5. **Commit generated files**: Include `.g.theme.dart` files in version control
6. **One extension per file**: Keep each theme extension in its own file for better organization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

- 🐛 [Report bugs](https://github.com/pro100andrey/theme_extensions_builder/issues)
- 💡 [Request features](https://github.com/pro100andrey/theme_extensions_builder/issues)
- 📖 [View documentation](https://github.com/pro100andrey/theme_extensions_builder)
