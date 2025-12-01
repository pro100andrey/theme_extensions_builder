import 'package:flutter/material.dart';

import '../../theme/extensions/spacing_theme.dart';
import '../../theme/extensions/typography_theme.dart';

class TypographyShowcase extends StatelessWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = context.typographyTheme;
    final spacing = context.spacingTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: typography.displayLarge),
        SizedBox(height: spacing.xs),
        Text('Display Medium', style: typography.displayMedium),
        SizedBox(height: spacing.xs),
        Text('Display Small', style: typography.displaySmall),
        SizedBox(height: spacing.md),
        Text('Headline Large', style: typography.headlineLarge),
        SizedBox(height: spacing.xs),
        Text('Headline Medium', style: typography.headlineMedium),
        SizedBox(height: spacing.xs),
        Text('Headline Small', style: typography.headlineSmall),
        SizedBox(height: spacing.md),
        Text('Body Large', style: typography.bodyLarge),
        SizedBox(height: spacing.xs),
        Text('Body Medium', style: typography.bodyMedium),
        SizedBox(height: spacing.xs),
        Text('Body Small', style: typography.bodySmall),
        SizedBox(height: spacing.md),
        Text('Label Large', style: typography.labelLarge),
        SizedBox(height: spacing.xs),
        Text('Label Medium', style: typography.labelMedium),
        SizedBox(height: spacing.xs),
        Text('Label Small', style: typography.labelSmall),
        SizedBox(height: spacing.md),
        Text('const code = "example";', style: typography.codeStyle),
      ],
    );
  }
}
