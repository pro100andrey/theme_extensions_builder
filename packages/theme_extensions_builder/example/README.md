# theme_extensions_builder Example

This is a comprehensive Flutter example demonstrating advanced usage of **theme_extensions_builder** to create type-safe theme extensions.

## 🎯 Overview

This example showcases how to build a complete theming system using `theme_extensions_builder` with multiple theme extensions covering different aspects of your app's design system.

## 🎨 Features Demonstrated

### 1. **App Theme Extension**

Custom application-level theme properties:

- Primary and background colors
- Layout modes (compact/expanded)
- Border styles with optional values

### 2. **Button Theme Extension**

Complete button system with:

- Multiple variants (primary, secondary, outlined, text)
- Three sizes (small, medium, large)
- Custom colors and styling
- Loading and disabled states
- Icon support with configurable spacing

### 3. **Typography Theme Extension**

Full typography scale:

- Display styles (large, medium, small)
- Headlines (large, medium, small)
- Body text (large, medium, small)
- Labels (large, medium, small)
- Code style with monospace font

### 4. **Spacing Theme Extension**

Consistent spacing system:

- Base spacing scale (xs, sm, md, lg, xl, xxl)
- Layout-specific spacing (page padding, section spacing)
- Component spacing (card spacing)

### 5. **Card Theme Extension**

Customizable card components:

- Border radius and colors
- Box shadows
- Padding and borders
- Text styles for title and subtitle

## 🚀 Running the Example

1. Install dependencies:

```bash
flutter pub get
```

1. Generate theme extensions:

```bash
dart run build_runner build
```

1. Run the app:

```bash
flutter run
```

## 💡 Key Concepts

### Creating Theme Extensions

Define a theme extension using the `@themeExtensions` annotation:

```dart
@themeExtensions
class ButtonThemeExtension extends ThemeExtension<ButtonThemeExtension>
    with _$ButtonThemeExtension {
  const ButtonThemeExtension({
    required this.primaryColor,
    required this.borderRadius,
    this.elevation = 2.0,
  });

  final Color primaryColor;
  final BorderRadius borderRadius;
  final double elevation;
}
```

### Using Theme Extensions

Access theme extensions in your widgets:

```dart
@override
Widget build(BuildContext context) {
  final buttonTheme = context.buttonTheme;
  final spacing = context.spacing;
  
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: buttonTheme.borderRadius,
      ),
    ),
    child: Text('Button'),
  );
}
```

### Theme Configuration

Register extensions in your theme:

```dart
ThemeData get lightTheme => ThemeData(
  brightness: Brightness.light,
  extensions: [
    ButtonThemeExtension(
      primaryColor: Colors.orange,
      borderRadius: BorderRadius.circular(8),
    ),
    SpacingThemeExtension(
      md: 16,
      lg: 24,
    ),
  ],
);
```

## 🎬 Demo Features

The example app includes:

1. **Overview Page** - Introduction to all theme extensions
2. **Buttons Page** - Complete button system showcase with all variants and sizes
3. **Typography Page** - All text styles in the typography system
4. **Cards Page** - Card components with theme-aware styling

## 🌗 Theme Switching

The example demonstrates seamless switching between light and dark themes with all extensions properly adapting through lerp interpolation.

## 📚 Learn More

- [theme_extensions_builder Documentation](../README.md)
- [Flutter ThemeExtension](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)

## 📄 License

This example is part of the `theme_extensions_builder` package and is licensed under the MIT License.
