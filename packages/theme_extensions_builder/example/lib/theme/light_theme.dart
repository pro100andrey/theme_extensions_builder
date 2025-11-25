import 'package:flutter/material.dart';

import 'extensions/app_theme.dart';
import 'extensions/widgets/card_theme.dart';

ThemeData get lightTheme => ThemeData(
  brightness: .light,
  colorScheme: .fromSeed(seedColor: Colors.green),
  extensions: [
    const AppThemeExtension(
      primaryColor: Colors.orange,
      backgroundColor: Colors.white,
      layoutMode: .compact,
      borderSide: BorderSide.none,
      optionalBorderSide: null,
    ),
    CardThemeExtension(
      borderRadius: const .all(.circular(8)),
      backgroundColor: Colors.white,
      border: .all(color: Colors.black12, width: 1),
      padding: const .all(12),
      boxShadow: [
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 1,
          offset: .new(2, -4),
        ),
      ],
    ),
  ],
);
