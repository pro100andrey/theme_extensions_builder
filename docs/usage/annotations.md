# Annotations Reference

This page documents all annotations provided by `theme_extensions_builder_annotation`.

## `@ThemeExtensions`

Use for classes that extend `ThemeExtension<T>`.

Example:

```dart
@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
  const AppTheme({required this.primary});

  final Color primary;
}
```

### Parameters

#### `buildContextExtension`

Type: `bool`  
Default: `true`

When enabled, generator creates a `BuildContext` extension getter:

```dart
context.appTheme
```

Set to `false` when you prefer manual access:

```dart
Theme.of(context).extension<AppTheme>()!
```

#### `contextAccessorName`

Type: `String?`  
Default: `null`

Overrides generated accessor name.

```dart
@ThemeExtensions(contextAccessorName: 'design')
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
  const AppTheme({required this.primary});

  final Color primary;
}

// usage:
// context.design.primary
```

#### `constructor`

Type: `String?`  
Default: `null`

Specifies constructor name used by generated methods.

```dart
@ThemeExtensions(constructor: '_internal')
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
  const AppTheme._internal({required this.primary});

  final Color primary;

  factory AppTheme({required Color primary}) = AppTheme._internal;
}
```

## `@ThemeGen`

Use for plain classes (not `ThemeExtension`) that still need generated `copyWith`, `merge`, and `lerp`.

```dart
@ThemeGen()
class ButtonTokens with _$ButtonTokens {
  const ButtonTokens({required this.height});

  final double height;

  static ButtonTokens? lerp(ButtonTokens? a, ButtonTokens? b, double t) =>
      _$ButtonTokens.lerp(a, b, t);
}
```

### Parameters

#### `constructor`

Type: `String?`  
Default: `null`

Same meaning as in `@ThemeExtensions`: generated code will instantiate using that constructor.

## `@ignore`

Use on a field to exclude it from all generated operations.

```dart
@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
  const AppTheme({required this.primary, this.debugLabel = ''});

  final Color primary;

  @ignore
  final String debugLabel;
}
```

Ignored fields are excluded from:

- `copyWith`
- `merge`
- `lerp`
- `==`
- `hashCode`

## Choosing The Right Annotation

- Use `@ThemeExtensions` when integrating with `ThemeData.extensions`
- Use `@ThemeGen` for nested or standalone theme token classes
- Use `@ignore` for non-theming fields that should not affect generated behavior
