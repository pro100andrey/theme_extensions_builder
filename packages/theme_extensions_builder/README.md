
Welcome to `theme_extensions_builder`, the code generator for supercharging Flutter ThemeExtension classes introduced in Flutter 3.0! The generator helps to minimize the required boilerplate code.

# How to use
## Install

Make sure to add these packages to the project dependencies:
- [build_runner] tool to run code generators (dev dependency)
- [theme_extensions_builder] this package (dev dependency)
- [theme_extensions_builder_annotation] annotations for [theme_extensions_builder]


```bash
flutter pub add --dev build_runner
flutter pub add --dev theme_extensions_builder
flutter pub add theme_extensions_builder_annotation
```

## Add imports and part directive
theme_extensions_builder is a generator for annotation that generates code in a part file that needs to be specified. Make sure to add the following imports and part directive in the file where you use the annotation.

Make sure to specify the correct file name in a part directive. In the example below, replace "name" with the file name.


```dart
//file: name.dart

import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'name.g.dart';
```

## Run the code generator
To run the code generator, run the following commands:

```console
flutter run build_runner build --delete-conflicting-outputs
```

## Create Theme Extension

```dart
//file: elevated_button_theme.dart

import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'elevated_button_theme.g.dart';

@themeExtensions
class ElevatedButtonThemeExtension extends ThemeExtension<ElevatedButtonThemeExtension> with _$ThemeExtensionMixin {
    const ElevatedButtonThemeExtension({
        required this.backgroundColor,
        required this.foregroundColor,
        this.borderRadius,
    });

    @ignore // 
    final BorderRadius? borderRadius;
    final Color backgroundColor;
    final Color foregroundColor;
}
```