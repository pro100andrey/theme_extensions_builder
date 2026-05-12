# Overview

This package removes repetitive manual theme code by generating `copyWith`, `lerp`, `merge`, equality, and `hashCode` methods for your theme models. It also generates optional `BuildContext` extensions, so theme access in widgets is short and type-safe.

It is designed for real app themes where you have many custom tokens and need consistent interpolation between light and dark modes.

## What It Supports

- `@ThemeExtensions` for `ThemeExtension`-based models
- `@ThemeGen` for custom theme data classes
- `@ignore` to exclude specific fields from generated methods
- Complex value types such as `Color`, `TextStyle`, `EdgeInsets`, `Duration`, enums, and custom classes
- Configurable context accessor names and constructor patterns

## Typical Workflow

1. Define a theme class with annotations.
2. Run `build_runner` to generate `*.g.theme.dart` files.
3. Add your generated extensions to `ThemeData.extensions`.
4. Access theme values directly from `BuildContext`.
