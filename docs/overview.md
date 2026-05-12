# Overview

`theme_extensions_builder` is a code generator for Flutter that removes repetitive theming boilerplate.

Instead of manually implementing `copyWith`, `lerp`, equality, and `hashCode` for every theme model, you annotate your class and generate production-ready code.

## Why Use It

- Reduces hand-written theming code
- Keeps theme logic consistent across classes
- Improves readability in widgets with optional `BuildContext` accessors
- Supports smooth light/dark interpolation with generated `lerp` logic
- Scales well for design systems with many tokens

## Core Concepts

### `@ThemeExtensions`

Use this for classes that extend `ThemeExtension<T>`.

Generated behavior includes:
- `copyWith`
- `lerp`
- `==` and `hashCode`
- Optional `BuildContext` extension getter (for example `context.appTheme`)

### `@ThemeGen`

Use this for plain theme data classes that do not extend `ThemeExtension`.

Generated behavior includes:
- `copyWith`
- `merge`
- static `lerp`
- `==` and `hashCode`

### `@ignore`

Apply this field annotation to exclude a field from generated methods.

Typical use cases:
- debug-only values
- derived or computed data
- fields that must not affect equality

## Supported Field Types

The generator supports common Flutter types and plain Dart values, including:

- `Color`
- `TextStyle`
- `EdgeInsets` and `EdgeInsetsGeometry`
- numeric values (`double`, `int`)
- `Duration`
- enums
- nullable and non-nullable fields

## Typical Workflow

1. Create an annotated theme class.
2. Add a `part '<file>.g.theme.dart';` directive.
3. Run `dart run build_runner build`.
4. Register theme extensions in `ThemeData.extensions`.
5. Use generated APIs in widgets and theme composition.

## Next Steps

- Continue with Installation
- Follow Getting Started for a complete first example
- Use the Annotations page as the API reference
