# Examples and Patterns

This page provides practical patterns for scaling theme code in real apps.

## Pattern 1: Split By Domain

Use multiple extensions instead of one large class.

```dart
@ThemeExtensions()
class AppColors extends ThemeExtension<AppColors> with _$AppColors {
  const AppColors({required this.primary, required this.error});

  final Color primary;
  final Color error;
}

@ThemeExtensions()
class AppSpacing extends ThemeExtension<AppSpacing> with _$AppSpacing {
  const AppSpacing({required this.s, required this.m, required this.l});

  final double s;
  final double m;
  final double l;
}
```

Benefits:

- clear ownership by concern
- easier testing and review
- simpler migration over time

## Pattern 2: Nested Tokens With `@ThemeGen`

Use `@ThemeGen` for reusable token groups, then include them in extensions.

```dart
@ThemeGen()
class ButtonTokens with _$ButtonTokens {
  const ButtonTokens({required this.height, required this.radius});

  final double height;
  final BorderRadius radius;

  static ButtonTokens? lerp(ButtonTokens? a, ButtonTokens? b, double t) =>
      _$ButtonTokens.lerp(a, b, t);
}

@ThemeExtensions()
class ButtonThemeExtension extends ThemeExtension<ButtonThemeExtension>
    with _$ButtonThemeExtension {
  const ButtonThemeExtension({required this.primary, required this.secondary});

  final ButtonTokens primary;
  final ButtonTokens secondary;
}
```

## Pattern 3: Stable Accessor Naming

When renaming classes, keep the same context accessor name to avoid widget churn.

```dart
@ThemeExtensions(contextAccessorName: 'buttonTheme')
class AppButtonTheme extends ThemeExtension<AppButtonTheme>
    with _$AppButtonTheme {
  const AppButtonTheme({required this.height});

  final double height;
}
```

## Pattern 4: Ignore Non-Theme Fields

```dart
@ThemeExtensions()
class AppTheme extends ThemeExtension<AppTheme> with _$AppTheme {
  const AppTheme({required this.primary, this.debugSource = ''});

  final Color primary;

  @ignore
  final String debugSource;
}
```

## Pattern 5: Theme Registration

```dart
ThemeData buildLightTheme() {
  return ThemeData.light().copyWith(
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(primary: Colors.blue, error: Colors.red),
      AppSpacing(s: 4, m: 8, l: 16),
    ],
  );
}
```

## Flutter UI Examples

These examples show how generated extensions look in real Flutter widgets.

### Example 1: Switch between light and dark themes

```dart
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? darkTheme : lightTheme,
      home: HomePage(
        onToggleTheme: () => setState(() => isDark = !isDark),
      ),
    );
  }
}
```

### Example 2: Read extension values from BuildContext

```dart
class HomePage extends StatelessWidget {
  const HomePage({required this.onToggleTheme, super.key});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    final spacing = context.spacingTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        backgroundColor: appTheme.primaryColor,
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),
      backgroundColor: appTheme.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.pageHorizontal,
          vertical: spacing.pageVertical,
        ),
        child: const Text('Theme extensions in action'),
      ),
    );
  }
}
```

### Example 3: Themed custom button

```dart
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.variant = .primary,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = context.buttonTheme;

    final backgroundColor = switch (variant) {
      .primary => buttonTheme.primaryColor,
      .secondary => buttonTheme.secondaryColor,
      .outlined || .text => .transparent,
    };

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: buttonTheme.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: buttonTheme.borderRadius,
        ),
        padding: buttonTheme.mediumPadding,
      ),
      child: Text(label),
    );
  }
}
```

### Example 4: Theme-aware card widget

```dart
class BaseCard extends StatelessWidget {
  const BaseCard({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cardTheme = context.cardTheme;

    return Container(
      padding: cardTheme.padding,
      decoration: BoxDecoration(
        color: cardTheme.backgroundColor,
        borderRadius: cardTheme.borderRadius,
        border: cardTheme.border,
        boxShadow: cardTheme.boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: cardTheme.titleTextStyle),
          const SizedBox(height: 8),
          Text(subtitle, style: cardTheme.subtitleTextStyle),
        ],
      ),
    );
  }
}
```

These snippets are simplified versions of the real `example` app and are ready to adapt in your project.

## Best Practices

- Keep one primary theme model per file
- Prefer explicit, domain-oriented names
- Use nullable fields only when they are truly optional
- Commit generated files for predictable builds
- Add tests for important interpolation behavior
