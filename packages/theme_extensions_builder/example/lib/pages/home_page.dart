import 'package:flutter/material.dart';

import '../app.dart';
import '../theme/common/app_theme.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: appTheme.layoutMode == LayoutMode.compact ? 200 : 300,
              height: 100,
              color: appTheme.primaryColor,
              child: Center(
                child: Text(
                  'Mode: ${appTheme.layoutMode.name}',
                  style: TextStyle(
                    color: appTheme.primaryColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
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
