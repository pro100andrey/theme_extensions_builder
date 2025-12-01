import 'package:flutter/material.dart';

import '../../theme/extensions/spacing_theme.dart';
import '../../theme/extensions/widgets/button_theme.dart';
import 'custom_button.dart';

class ButtonShowcase extends StatelessWidget {
  const ButtonShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacingTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary buttons
        Text('Primary Buttons', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Small',
                size: ButtonSize.small,
                onPressed: () {},
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: CustomButton(
                label: 'Medium',
                onPressed: () {},
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: CustomButton(
                label: 'Large',
                size: ButtonSize.large,
                onPressed: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.md),

        // Secondary buttons
        Text(
          'Secondary Buttons',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: spacing.sm),
        CustomButton(
          label: 'Secondary Button',
          variant: ButtonVariant.secondary,
          icon: Icons.star,
          onPressed: () {},
        ),
        SizedBox(height: spacing.md),

        // Outlined buttons
        Text(
          'Outlined Buttons',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: spacing.sm),
        CustomButton(
          label: 'Outlined Button',
          variant: ButtonVariant.outlined,
          icon: Icons.bookmark_border,
          onPressed: () {},
        ),
        SizedBox(height: spacing.md),

        // Text buttons
        Text('Text Buttons', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        CustomButton(
          label: 'Text Button',
          variant: ButtonVariant.text,
          onPressed: () {},
        ),
        SizedBox(height: spacing.md),

        // Loading and disabled states
        Text('States', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Loading',
                isLoading: true,
                onPressed: () {},
              ),
            ),
            SizedBox(width: spacing.sm),
            const Expanded(
              child: CustomButton(
                label: 'Disabled',
                onPressed: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
