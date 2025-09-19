import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'theme/custom/alert_theme.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: _isDark ? darkTheme : lightTheme,
    home: const HomePage(),
  );

  void toggleTheme() {
    const alertTheme = AlertTheme();
    const alertTheme2 = AlertTheme(canMerge: false);

    final _ = AlertTheme.lerp(alertTheme, alertTheme2, 0.5);

    setState(() {
      _isDark = !_isDark;
    });
  }
}

extension ThemeSwitcher on BuildContext {
  AppState get appState => findAncestorStateOfType<AppState>()!;
}
