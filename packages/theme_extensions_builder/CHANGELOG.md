## 6.0.0-dev.4

- *Fixed*: static `lerp` return type to nullable

## 6.0.0-dev.3

- *Fixed*: static `lerp`, `merge` methods.

## 6.0.0-dev.2

- *Fixed*: static `lerp` return type to non-nullable

## 6.0.0-dev.1

- *Updated*: dependencies.
- *Added*: `lerpDuration` property.
- *Added*: `ThemeGen` annotation for theme generation.

## 5.1.1

- **Bug Fix**: Resolved an issue in the `Object.hashAll` implementation that caused incorrect hash code generation when a theme extension contained more than 20 fields.
- **Dependency Updates**: Updated `build` and `source_gen` dependencies to ensure compatibility with the latest versions.

## 5.1.0+1

- Fixed typo's

## 5.1.0

### New Features

- **Improved Code Generation**: Now using the `code_builder` library for generating theme extensions, which results in more structured and reliable code.

- **Multiple Extensions per File**: Added support for defining multiple theme extensions within a single file.

- **New `@ThemeExtension` Annotation Property**: The `contextAccessorName` property has been added to the `@ThemeExtensions` annotation, allowing you to customize the accessor name for your theme extension on `BuildContext`.

- **Automatic `lerp` Method Generation**: The generator now automatically creates `lerp` methods for `double` and other `ThemeExtension` types, simplifying their use in animations.

- **Optimized lerp for non-interpolated types**: `lerp` method generation for types that do not have a `lerp` method now uses a ternary operator (`t < 0.5 ? value : otherValue`). This ensures a more efficient and predictable transition between values.

### Deprecations

- **`_$ThemeExtensionMixin` is Deprecated**: To support multiple extensions per file, the use of `with _$ThemeExtensionMixin` has been deprecated. Please use the newly generated mixin `with _\$[ClassName]Mixin` instead.

## 5.0.0

- *Updated*: dependencies.

## 4.0.1

- *Updated*: dependencies.
- *Added*: DartFormatter.
- *Fix*: element type.

## 4.0.0

- *Updated*: dependencies. Min sdk: 3.6.0

## 3.1.0

- *Updated*: dependencies. Min sdk: 3.3.0

## 3.0.1

- *Fixed*: dependencies. Thanks [felix-barz-brickmakers](https://github.com/felix-barz-brickmakers)!

## 3.0.0

- *Updated*: dependencies. Min sdk: 3.0.0

## 2.0.2

- *Fixed*: generate `lerp` method [issue](https://github.com/pro100andrey/theme_extensions_builder/issues/8) for `MaterialStateProperty`

## 2.0.1+3

- *Updated*: for scores

## 2.0.1+2

- *Updated*: readme, doc

## 2.0.1+1

- *Updated*: readme

## 2.0.1

- *Updated*: `theme_extensions_builder_annotation`: ^2.0.0

## 2.0.0

- *Breaking changes*: rename build_extensions from .g.dart to .g.theme.dart ([issue](https://github.com/pro100andrey/theme_extensions_builder/issues/2))
- *Updated*: analyzer: ">=4.6.0 <6.0.0"

## 1.0.1

- *Added*: Support for types that do not implement method lerp

## 1.0.0+1

- *Updated*: for scores

## 1.0.0

- Initial release.
