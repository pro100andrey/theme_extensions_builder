# Build Runner Guide

This package uses `build_runner` to generate `*.g.theme.dart` files.

## Common Commands

### One-time generation

```bash
dart run build_runner build
```

Use for CI and local verification.

### Watch mode

```bash
dart run build_runner watch
```

Use during development for automatic regeneration on file changes.

### Clean stale outputs

```bash
dart run build_runner clean
```

Follow with a full build:

```bash
dart run build_runner build
```

## Typical Development Flow

1. Edit annotated classes.
2. Keep `watch` running in a terminal.
3. Commit both source files and generated `*.g.theme.dart` files.

## CI Recommendation

Run generation in CI to ensure committed generated files are up to date:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Troubleshooting Build Issues

- Missing `part` directive: add `part '<name>.g.theme.dart';`
- Wrong part filename: must match source filename
- Outdated cache: run `build_runner clean`
- Conflicting outputs: run with `--delete-conflicting-outputs`

## Optional Builder Config

The package exposes a builder named `theme_extensions_builder`. In most projects, default behavior is enough and no custom config is required.
