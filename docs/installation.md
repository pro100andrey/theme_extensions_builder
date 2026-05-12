# Installation

This page explains the minimum setup required to generate theme code.

## Prerequisites

- Flutter SDK installed and available in PATH
- Dart SDK compatible with the package constraints
- Existing Flutter project

## Add Dependencies

Install with `flutter pub add`:

```bash
flutter pub add theme_extensions_builder_annotation
flutter pub add --dev theme_extensions_builder
flutter pub add --dev build_runner
```

Or edit `pubspec.yaml` manually:

```yaml
dependencies:
  theme_extensions_builder_annotation: ^7.3.0

dev_dependencies:
  build_runner: ^2.13.0
  theme_extensions_builder: ^7.3.0
```

Then fetch dependencies:

```bash
flutter pub get
```

## Add Part File Directive

In every source file that contains annotated classes, add a matching `part` directive:

```dart
part 'app_theme.g.theme.dart';
```

Rule: generated filename must follow `<source_file>.g.theme.dart`.

## Run Code Generation

One-time generation:

```bash
dart run build_runner build
```

Continuous generation while developing:

```bash
dart run build_runner watch
```

If stale outputs appear, clean first:

```bash
dart run build_runner clean
dart run build_runner build
```

## Verify Setup

After successful generation you should see files like:

- `app_theme.g.theme.dart`
- `button_theme.g.theme.dart`

These files contain generated mixins and helper methods used by your annotated classes.

## Optional IDE File Nesting

VS Code example:

```json
{
  "explorer.fileNesting.enabled": true,
  "explorer.fileNesting.patterns": {
    "*.dart": "${capture}.g.theme.dart"
  }
}
```