import 'package:flutter/material.dart';

import 'pages/home_page.dart';
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
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  );

  void toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }
}

extension ThemeSwitcher on BuildContext {
  AppState get appState => findAncestorStateOfType<AppState>()!;
}
