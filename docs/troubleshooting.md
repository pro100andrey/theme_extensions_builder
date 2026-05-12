# Troubleshooting

## Build Runner Generates Nothing

Checklist:

- The class is annotated with `@ThemeExtensions` or `@ThemeGen`
- The source file contains matching `part '<name>.g.theme.dart';`
- `build_runner` and generator dependencies are in `pubspec.yaml`

Command:

```bash
dart run build_runner build --delete-conflicting-outputs
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
dart run build_runner build --delete-conflicting-outputs
```

## Analyzer Errors In Generated Files

Checklist:

- Ensure class signatures are valid (`ThemeExtension<T>` where required)
- Make sure fields are final and constructors match expected arguments
- Rebuild after dependency updates

## Need Deterministic CI Builds

Use a CI step:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Fail the build when generated files differ from committed sources.
