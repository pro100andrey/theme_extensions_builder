## 7.5.0

- **Breaking**: `hashCode` changes for classes that inherit fields, which now come after the class' own.
- **Changed**: `lerp` keeps the endpoints when one side is null (`t = 0` gives `a`, `t = 1` gives `b`), and `merge` keeps the current value when the incoming one is null.
- **New**: The annotated class is validated before generation. A missing constructor, a field without a named parameter, a required parameter the generated code cannot pass, a generic class, a missing `with _$X`, a field named `copyWith`, `merge` or `lerp`, a `@ThemeExtensions` class not extending `ThemeExtension<Self>`, or an invalid `contextAccessorName` now stop the build with a message naming the class and the fix.
- **Fixed**: Generated code that did not compile for an instance `lerp` on a nullable field or with a nullable result, a non-nullable `lerp`/`merge` parameter on a nullable field, a static call on `Box<int>` instead of `Box`, a method declared on a supertype (the result is cast back), a generic field type (methods resolve through the instantiated type), and a field inherited from a generic superclass (`T` is substituted).
- **Fixed**: An unrelated `lerp` or `merge` no longer fails the build or is mistaken for a supported one; an unusable signature is a build warning naming the field and its fallback.
- **Fixed**: A `WidgetStateProperty` generic has to offer a static `lerp` that accepts nulls, and is reported once when it does not; a non-nullable generic is an error at the field, a nested one falls back; `double` and `Duration` generics are detected by element.
- **Fixed**: Field collection follows Dart's resolution: a narrowed field keeps the narrowed type, mixins win over the superclass chain, `implements` contributes nothing, private and static fields are skipped, and `@ignore` on a redeclaration drops the inherited one. `Duration` is detected by element.
- **Fixed**: A field typed as a `@ThemeGen` class, or a subclass of one, merges the same way on clean and incremental builds; a hand-written `merge` is used as declared.
- **Fixed**: `const` follows the constructor named in `constructor:`; `constructor: ''` selects the unnamed one.
- **Fixed**: Annotations are matched by package as well as by name, so a user class called `ThemeGen` is not taken for one.
- **Fixed**: The example is published without its workspace-only files, so it resolves when copied from pub.dev.
- **Updated**: Analyzer `>=13.1.0 <15.0.0` (the lower bound CI tests against) and Dart SDK `>=3.13.0 <4.0.0`; `collection` and `meta` are no longer dependencies; the `platforms` key is gone from the pubspec.

## 7.4.0

- *Updated*: Analyzer dependency to ">=9.0.0 <14.0.0"
- *Updated*: `source_gen` lower bound to ">=4.2.3" for analyzer 12/13 compatibility.

## 7.3.0

- *Updated*: Analyzer dependency to ">=9.0.0 <11.0.0".
- *Updated*: Dependencies in example and annotation packages.

## 7.2.1

- *Update*: Improved documentation.

## 7.2.0

- **New Feature**: Added support for `WidgetStateProperty.lerp` with 4-parameter signature - [#33](https://github.com/pro100andrey/theme_extensions_builder/issues/33)
- **New Feature**: Added `WidgetStatePropertyLerp` class for proper code generation of `WidgetStateProperty` types with validation for nullable generics
- **Improvement**: Enhanced lerp method handling for instance methods with optional results, ensuring correct null safety and type casting
- **Improvement**: Updated code generation logic in both `@ThemeExtensions` and `@ThemeGen` to handle `WidgetStateProperty` fields with appropriate inner lerp functions
- **Improvement**: Refactored internal analysis logic to better validate parameter types and method signatures for lerp methods
- **Improvement**: Added validation that throws descriptive errors when `WidgetStateProperty` is used with non-nullable generic types
- **Testing**: Expanded test suite with new test cases for `WidgetStateProperty` and instance lerp with optional results
- **Code Quality**: Made generator constructors const and cleaned up imports
- **Updated**: Dependencies to latest versions for improved compatibility

## 7.1.0

- **Documentation**: Improved internal code comments for better understanding of the codebase
- **Documentation**: Added `.github/README.md` with quick start guide and installation instructions
- **Documentation**: Separated and clarified `@ThemeExtensions` vs `@ThemeGen` usage patterns
- **Example**: Enhanced example app with 5 comprehensive theme extensions:
  - `ButtonThemeExtension` - Complete button system with variants (primary, secondary, outlined, text) and sizes
  - `TypographyThemeExtension` - Full typography scale (display, headline, body, label, code styles)
  - `SpacingThemeExtension` - Consistent spacing system for layouts
  - `CardThemeExtension` - Customizable card components
  - `AppThemeExtension` - Application-level colors and layout modes
- **Example**: Added multi-page navigation with NavigationBar showcasing different features
- **Example**: Custom button component with loading and disabled states
- **Example**: Typography and button showcase pages
- **Example**: Updated README with detailed feature descriptions and project structure
- **Improvement**: Added more unit tests for better coverage
- **Improvement**: Updated dependencies to latest versions
- **Fixes**: Various bug fixes and stability improvements

## 7.0.1

- **Improvement**: Updated `==` operator to check `runtimeType`.
- **Improvement**: Internal variable renaming in generated code to avoid conflicts.

## 7.0.0

- **Breaking changes**: Removed deprecated `_$ThemeExtensionMixin` mixin. Use `_$[ClassName]Mixin` instead.
- **New Feature**: Added `constructor` parameter to `@ThemeExtensions` and `@ThemeGen` annotations, allowing you to specify a custom constructor name.
- **Improvement**: Added support for inheriting fields from superclasses in both `@ThemeExtensions` and `@ThemeGen` generators.
- **Improvement**: Optimized equality checks (`==` operator) to use type checking with `is!` instead of `runtimeType` comparison.
- **Improvement**: Added `==` and `hashCode` implementations to `FieldInfo` class for better comparison support.
- **Updated**: Dependencies to latest versions.
- **Fixes**: Various bug fixes and improvements - [issues/27](https://github.com/pro100andrey/theme_extensions_builder/issues/27), [issues/28](https://github.com/pro100andrey/theme_extensions_builder/issues/28), Special thanks to [nank1ro](https://github.com/nank1ro)! for finding and reporting issues.

## 6.0.1

- *Fixed*:  `lerpDuration$`, `lerpDouble$` calculation in case of null values.

## 6.0.0

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
