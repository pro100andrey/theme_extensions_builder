
Welcome to `theme_extensions_builder`, the code generator for Flutter ThemeExtension classes introduced in Flutter 3.0. The generator helps to minimize the required boilerplate code.

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

part 'name.g.theme.dart';
```

## Run the code generator
To run the code generator, run the following commands:

```console
flutter pub run build_runner build --delete-conflicting-outputs
```

## Create Theme Extension

```dart
//file: elevated_button.dart

import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'elevated_button.g.theme.dart';

@themeExtensions
class ElevatedButtonThemeExtension
    extends ThemeExtension<ElevatedButtonThemeExtension>
    with _$ThemeExtensionMixin {
  const ElevatedButtonThemeExtension({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius,
  });

  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color foregroundColor;
}
```

Generated code

```dart

//file: elevated_button.g.theme.dart;   

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element

part of 'elevated_button.dart';

// **************************************************************************
// ThemeExtensionsGenerator
// **************************************************************************

mixin _$ThemeExtensionMixin on ThemeExtension<ElevatedButtonThemeExtension> {
  @override
  ThemeExtension<ElevatedButtonThemeExtension> copyWith({
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final object = this as ElevatedButtonThemeExtension;

    return ElevatedButtonThemeExtension(
      borderRadius: borderRadius ?? object.borderRadius,
      backgroundColor: backgroundColor ?? object.backgroundColor,
      foregroundColor: foregroundColor ?? object.foregroundColor,
    );
  }

  @override
  ThemeExtension<ElevatedButtonThemeExtension> lerp(
    ThemeExtension<ElevatedButtonThemeExtension>? other,
    double t,
  ) {
    final otherValue = other;

    if (otherValue is! ElevatedButtonThemeExtension) {
      return this;
    }

    final value = this as ElevatedButtonThemeExtension;

    return ElevatedButtonThemeExtension(
      borderRadius: BorderRadius.lerp(
        value.borderRadius,
        otherValue.borderRadius,
        t,
      ),
      backgroundColor: Color.lerp(
        value.backgroundColor,
        otherValue.backgroundColor,
        t,
      )!,
      foregroundColor: Color.lerp(
        value.foregroundColor,
        otherValue.foregroundColor,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    final value = this as ElevatedButtonThemeExtension;

    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ElevatedButtonThemeExtension &&
            identical(value.borderRadius, other.borderRadius) &&
            identical(value.backgroundColor, other.backgroundColor) &&
            identical(value.foregroundColor, other.foregroundColor));
  }

  @override
  int get hashCode {
    final value = this as ElevatedButtonThemeExtension;

    return Object.hash(
      runtimeType,
      value.borderRadius,
      value.backgroundColor,
      value.foregroundColor,
    );
  }
}

extension ElevatedButtonThemeExtensionBuildContext on BuildContext {
  ElevatedButtonThemeExtension get elevatedButtonTheme =>
      Theme.of(this).extension<ElevatedButtonThemeExtension>()!;
}

```

## VSCode controls nesting of files in the Explorer.

```json
"explorer.fileNesting.patterns": {
    "*.dart": "${capture}.g.theme.dart"
}
```
