import 'package:flutter/material.dart';

import '../app.dart';
import '../theme/extensions/app_theme.dart';
import '../theme/extensions/spacing_theme.dart';
import 'widgets/base_card.dart';
import 'widgets/button_showcase.dart';
import 'widgets/custom_button.dart';
import 'widgets/typography_showcase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Extensions Builder Demo'),
        backgroundColor: appTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.appState.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      backgroundColor: appTheme.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildOverviewPage(context),
          _buildButtonsPage(context),
          _buildTypographyPage(context),
          _buildCardsPage(context),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_button_outlined),
            selectedIcon: Icon(Icons.smart_button),
            label: 'Buttons',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields_outlined),
            selectedIcon: Icon(Icons.text_fields),
            label: 'Typography',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Cards',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewPage(BuildContext context) {
    final spacing = context.spacingTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.pageHorizontal,
        vertical: spacing.pageVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome to Theme Extensions Builder',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.md),
          Text(
            'This example demonstrates comprehensive usage of '
            'theme_extensions_builder package with various theme extensions:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: spacing.lg),
          _buildFeatureCard(
            context,
            icon: Icons.palette,
            title: 'App Theme',
            description: 'Custom colors, layout modes, and border styles',
          ),
          SizedBox(height: spacing.md),
          _buildFeatureCard(
            context,
            icon: Icons.smart_button,
            title: 'Button Theme',
            description: 'Multiple variants, sizes, and states',
          ),
          SizedBox(height: spacing.md),
          _buildFeatureCard(
            context,
            icon: Icons.text_fields,
            title: 'Typography',
            description: 'Complete text style system',
          ),
          SizedBox(height: spacing.md),
          _buildFeatureCard(
            context,
            icon: Icons.space_bar,
            title: 'Spacing',
            description: 'Consistent spacing values',
          ),
          SizedBox(height: spacing.md),
          _buildFeatureCard(
            context,
            icon: Icons.dashboard,
            title: 'Card Theme',
            description: 'Customizable card components',
          ),
          SizedBox(height: spacing.xxl),
          CustomButton(
            label: 'Toggle Dark/Light Theme',
            icon: Icons.brightness_6,
            onPressed: () => context.appState.toggleTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) => BaseCard(
    title: title,
    subtitle: description,
  );

  Widget _buildButtonsPage(BuildContext context) {
    final spacing = context.spacingTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.pageHorizontal,
        vertical: spacing.pageVertical,
      ),
      child: const ButtonShowcase(),
    );
  }

  Widget _buildTypographyPage(BuildContext context) {
    final spacing = context.spacingTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.pageHorizontal,
        vertical: spacing.pageVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Typography System',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.lg),
          const TypographyShowcase(),
        ],
      ),
    );
  }

  Widget _buildCardsPage(BuildContext context) {
    final spacing = context.spacingTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.pageHorizontal,
        vertical: spacing.pageVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Card Components',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: spacing.lg),
          const BaseCard(
            title: 'Simple Card',
            subtitle: 'A basic card with title and subtitle',
          ),
          SizedBox(height: spacing.md),
          const BaseCard(
            title: 'Feature Card',
            subtitle: 'Cards automatically adapt to the theme extensions',
          ),
          SizedBox(height: spacing.md),
          const BaseCard(
            title: 'Information Card',
            subtitle: 'Border radius, shadows, and colors are all theme-aware',
          ),
        ],
      ),
    );
  }
}
