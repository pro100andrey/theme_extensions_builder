import 'package:flutter/material.dart';

import 'extensions/app_theme.dart';
import 'extensions/spacing_theme.dart';
import 'extensions/typography_theme.dart';
import 'extensions/widgets/button_theme.dart';
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
      borderSide: BorderSide.none,
      optionalBorderSide: null,
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
    const ButtonThemeExtension(
      primaryColor: Colors.teal,
      secondaryColor: Colors.deepPurple,
      outlinedBorderColor: Colors.teal,
      textColor: Colors.white,
      disabledColor: .fromRGBO(66, 66, 66, 1),
      smallPadding: .symmetric(horizontal: 12, vertical: 6),
      mediumPadding: .symmetric(horizontal: 16, vertical: 10),
      largePadding: .symmetric(horizontal: 24, vertical: 14),
      smallHeight: 32,
      mediumHeight: 40,
      largeHeight: 48,
      borderRadius: .all(.circular(12)),
      borderWidth: 2,
      elevation: 4,
    ),
    const TypographyThemeExtension(
      displayLarge: .new(fontSize: 57, fontWeight: .bold, color: Colors.white),
      displayMedium: .new(fontSize: 45, fontWeight: .bold, color: Colors.white),
      displaySmall: .new(fontSize: 36, fontWeight: .bold, color: Colors.white),
      headlineLarge: .new(fontSize: 32, fontWeight: .w600, color: Colors.white),
      headlineMedium: .new(
        fontSize: 28,
        fontWeight: .w600,
        color: Colors.white,
      ),
      headlineSmall: .new(fontSize: 24, fontWeight: .w600, color: Colors.white),
      bodyLarge: .new(fontSize: 16, fontWeight: .normal, color: Colors.white70),
      bodyMedium: .new(
        fontSize: 14,
        fontWeight: .normal,
        color: Colors.white70,
      ),
      bodySmall: .new(fontSize: 12, fontWeight: .normal, color: Colors.white70),
      labelLarge: .new(fontSize: 14, fontWeight: .w500, color: Colors.white70),
      labelMedium: .new(fontSize: 12, fontWeight: .w500, color: Colors.white70),
      labelSmall: .new(fontSize: 11, fontWeight: .w500, color: Colors.white70),
      codeStyle: .new(
        fontSize: 14,
        fontFamily: 'monospace',
        color: Colors.cyanAccent,
        backgroundColor: .fromRGBO(33, 33, 33, 1),
      ),
    ),
    const SpacingThemeExtension(
      xs: 4,
      sm: 8,
      md: 16,
      lg: 24,
      xl: 32,
      xxl: 48,
      pageHorizontal: 20,
      pageVertical: 28,
      sectionSpacing: 40,
      cardSpacing: 16,
    ),
  ],
);
