# Troubleshooting

## Build Runner Generates Nothing

Checklist:

- The class is annotated with `@ThemeExtensions` or `@ThemeGen`
- The source file contains matching `part '<name>.g.theme.dart';`
- `build_runner` and generator dependencies are in `pubspec.yaml`

Command:

```bash
dart run build_runner build
```

## Error About Missing Part File

Cause: incorrect filename in `part` directive.

Fix:

- For `lib/theme/app_theme.dart`, use `part 'app_theme.g.theme.dart';`

## Context Getter Not Generated

Possible causes:

- You used `@ThemeGen` (does not generate `BuildContext` extension)
- `@ThemeExtensions(buildContextExtension: false)` is set

Fix:

- Use `@ThemeExtensions()` for `ThemeExtension` classes
- Or manually access via `Theme.of(context).extension<MyTheme>()`

## Lerp Or Merge Behavior Is Not What You Expect

Recommendations:

- Verify nullable vs non-nullable field intent
- Inspect generated `*.g.theme.dart` output
- Use `@ignore` for fields that must not participate in generated behavior

## Conflicting Outputs

Run:

```bash
dart run build_runner clean
dart run build_runner build
```

## The Build Stops With A Generator Error

The generator checks the annotated class before writing anything. Each message names the class and what to change:

- **`` `X` has no constructor named `_internal`. ``** The `constructor:` option names a constructor that does not exist. Declare it, or point the option at an existing one.
- **`` `X` has no unnamed constructor, which the generated code calls. ``** The class only has named constructors. Add `constructor: 'name'` to the annotation.
- **`` The constructor `X` has no named parameter for the field `y` ``** Every field is passed to the constructor by name. Add `this.y` to the constructor, or mark the field with `@ignore`.
- **`` `X` must extend `ThemeExtension<X>` ``** `@ThemeExtensions` needs a class that extends `ThemeExtension` of itself. Extend it, or use `@ThemeGen` for a plain class.
- **`` `...` is not a valid Dart identifier ``** `contextAccessorName` is written into the generated code as a getter name. Use an identifier.
- **`` WidgetStateProperty must have a nullable generic type ``** `WidgetStateProperty.lerp` takes a lerp function with nullable parameters, so the generic has to be nullable: `WidgetStateProperty<Color?>`.

A warning such as `` The `lerp` method of X has an unsupported signature `` does not stop the build. The field type declares a `lerp` or `merge` the generator cannot call, so the field switches over at `t = 0.5` or is overwritten instead. Rename the method or give it a supported signature if it was meant to be used.

## Analyzer Errors In Generated Files

Checklist:

- Ensure class signatures are valid (`ThemeExtension<T>` where required)
- Make sure fields are final and constructors match expected arguments
- Rebuild after dependency updates

## Need Deterministic CI Builds

Use a CI step:

```bash
dart run build_runner build
```

Fail the build when generated files differ from committed sources.
