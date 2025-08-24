import 'package:flutter/material.dart';

import 'common/app_theme.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  extensions: const [
    AppThemeExtension(
      primaryColor: Colors.orange,
      layoutMode: LayoutMode.compact,
      insets: EdgeInsets.all(8),
      subTextTheme: MySubTextTheme(
        color: Colors.black,
        fontSize: 14,
      ),
    ),
  ],
);
