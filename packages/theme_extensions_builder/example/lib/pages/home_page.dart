import 'package:flutter/material.dart';

import '../app.dart';
import '../theme/extensions/app_theme.dart';
import 'widgets/base_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Switcher'),
        backgroundColor: appTheme.primaryColor,
      ),
      backgroundColor: appTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BaseCard(
              title: 'Card Title',
              subtitle: 'Card Subtitle Content',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.appState.toggleTheme(),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primaryColor,
              ),
              child: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
