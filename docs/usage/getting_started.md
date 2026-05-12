# Getting Started

This guide shows the fastest path from zero setup to generated theme access in widgets.

## 1. Create a Theme Extension File

Create `lib/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_theme.g.theme.dart';

@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
	const AppTheme({
		required this.primary,
		required this.surface,
		required this.contentPadding,
		this.cornerRadius,
	});

	final Color primary;
	final Color surface;
	final EdgeInsets contentPadding;
	final BorderRadius? cornerRadius;
}
```

## 2. Generate Code

Run:

```bash
dart run build_runner build
```

This generates `lib/theme/app_theme.g.theme.dart`.

## 3. Register Extension in ThemeData

Example theme setup:

```dart
final ThemeData lightTheme = ThemeData.light().copyWith(
	extensions: const <ThemeExtension<dynamic>>[
		AppTheme(
			primary: Colors.blue,
			surface: Colors.white,
			contentPadding: EdgeInsets.all(16),
			cornerRadius: BorderRadius.all(Radius.circular(12)),
		),
	],
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
	extensions: const <ThemeExtension<dynamic>>[
		AppTheme(
			primary: Colors.lightBlue,
			surface: Color(0xFF121212),
			contentPadding: EdgeInsets.all(16),
			cornerRadius: BorderRadius.all(Radius.circular(12)),
		),
	],
);
```

## 4. Read Values in Widgets

With generated context extension enabled (default):

```dart
class ThemedCard extends StatelessWidget {
	const ThemedCard({super.key});

	@override
	Widget build(BuildContext context) {
		final theme = context.appTheme;

		return Container(
			padding: theme.contentPadding,
			decoration: BoxDecoration(
				color: theme.surface,
				borderRadius: theme.cornerRadius,
			),
			child: Text(
				'Hello',
				style: TextStyle(color: theme.primary),
			),
		);
	}
}
```

## 5. Add a Plain Theme Model with `@ThemeGen`

Use `@ThemeGen` for data classes that are not `ThemeExtension`:

```dart
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'button_tokens.g.theme.dart';

@ThemeGen()
class ButtonTokens with _$ButtonTokens {
	const ButtonTokens({
		required this.height,
		required this.horizontalPadding,
	});

	final double height;
	final EdgeInsets horizontalPadding;

	static ButtonTokens? lerp(ButtonTokens? a, ButtonTokens? b, double t) =>
			_$ButtonTokens.lerp(a, b, t);
}
```

## What To Read Next

- Annotations reference for all options
- Build Runner guide for build/watch/clean workflows
- Examples page for multi-extension architecture