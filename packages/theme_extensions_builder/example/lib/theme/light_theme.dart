import 'package:flutter/material.dart';

import 'extensions/app_theme.dart';
import 'extensions/spacing_theme.dart';
import 'extensions/typography_theme.dart';
import 'extensions/widgets/button_theme.dart';
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
    const ButtonThemeExtension(
      primaryColor: Colors.orange,
      secondaryColor: Colors.blue,
      outlinedBorderColor: Colors.orange,
      textColor: Colors.white,
      disabledColor: .fromRGBO(224, 224, 224, 1),
      smallPadding: .symmetric(horizontal: 12, vertical: 6),
      mediumPadding: .symmetric(horizontal: 16, vertical: 10),
      largePadding: .symmetric(horizontal: 24, vertical: 14),
      smallHeight: 32,
      mediumHeight: 40,
      largeHeight: 48,
      borderRadius: .all(.circular(8)),
      borderWidth: 2,
    ),
    const TypographyThemeExtension(
      displayLarge: .new(
        fontSize: 57,
        fontWeight: .bold,
        color: Colors.black87,
      ),
      displayMedium: .new(
        fontSize: 45,
        fontWeight: .bold,
        color: Colors.black87,
      ),
      displaySmall: .new(
        fontSize: 36,
        fontWeight: .bold,
        color: Colors.black87,
      ),
      headlineLarge: .new(
        fontSize: 32,
        fontWeight: .w600,
        color: Colors.black87,
      ),
      headlineMedium: .new(
        fontSize: 28,
        fontWeight: .w600,
        color: Colors.black87,
      ),
      headlineSmall: .new(
        fontSize: 24,
        fontWeight: .w600,
        color: Colors.black87,
      ),
      bodyLarge: .new(fontSize: 16, fontWeight: .normal, color: Colors.black87),
      bodyMedium: .new(
        fontSize: 14,
        fontWeight: .normal,
        color: Colors.black87,
      ),
      bodySmall: .new(fontSize: 12, fontWeight: .normal, color: Colors.black87),
      labelLarge: .new(fontSize: 14, fontWeight: .w500, color: Colors.black87),
      labelMedium: .new(fontSize: 12, fontWeight: .w500, color: Colors.black87),
      labelSmall: .new(fontSize: 11, fontWeight: .w500, color: Colors.black87),
      codeStyle: .new(
        fontSize: 14,
        fontFamily: 'monospace',
        color: Colors.purple,
        backgroundColor: .fromRGBO(245, 245, 245, 1),
      ),
    ),
    const SpacingThemeExtension(
      xs: 4,
      sm: 8,
      md: 16,
      lg: 24,
      xl: 32,
      xxl: 48,
      pageHorizontal: 16,
      pageVertical: 24,
      sectionSpacing: 32,
      cardSpacing: 12,
    ),
  ],
);
