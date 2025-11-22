import 'package:flutter/material.dart';

import '../../theme/extensions/widgets/card_theme.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cardTheme = context.cardTheme;

    return Container(
      decoration: BoxDecoration(
        color: cardTheme.backgroundColor,
        borderRadius: cardTheme.borderRadius,
        boxShadow: cardTheme.boxShadow,
        border: cardTheme.border,
      ),
      padding: cardTheme.padding,
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: cardTheme.titleTextStyle,
          ),
          Text(
            subtitle,
            style: cardTheme.subtitleTextStyle,
          ),
        ],
      ),
    );
  }
}
