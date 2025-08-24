import 'package:flutter/material.dart';

import 'common/app_theme.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  extensions: const [
    AppThemeExtension(
      primaryColor: Colors.teal,
      insets: EdgeInsets.all(16),
      layoutMode: LayoutMode.expanded,
      subTextTheme: MySubTextTheme(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ],
);
