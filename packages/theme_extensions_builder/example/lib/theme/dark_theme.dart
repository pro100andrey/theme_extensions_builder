import 'package:flutter/material.dart';

import 'extensions/app_theme.dart';
import 'extensions/widgets/card_theme.dart';

ThemeData get darkTheme => ThemeData(
  brightness: .dark,
  colorScheme: .fromSeed(
    seedColor: Colors.blue,
    brightness: .dark,
  ),
  extensions: [
    const AppThemeExtension(
      primaryColor: Colors.teal,
      backgroundColor: Colors.black,
      layoutMode: .expanded,
    ),
    CardThemeExtension(
      borderRadius: const .all(.circular(16)),
      backgroundColor: Colors.black,
      border: .all(color: Colors.white24, width: 1),
      padding: const .all(20),
      boxShadow: [
        const BoxShadow(
          color: Colors.white24,
          blurRadius: 1,
          offset: .new(-2, 4),
        ),
      ],
    ),
  ],
);
