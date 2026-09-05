import 'package:flutter/material.dart';

import '../../app.dart';
import '../../theme/dark_theme.dart';
import '../../theme/extensions/app_theme.dart';
import '../../theme/extensions/spacing_theme.dart';
import '../../theme/light_theme.dart';
import 'custom_button.dart';

/// Shows what `lerp` produces for a nullable field at every point of a theme
/// transition.
///
/// `AppThemeExtension.optionalBorderSide` is set in the dark theme and absent
/// in the light one, so one side of the interpolation is always null. An
/// instance of `BorderSide` cannot be interpolated with nothing, so the
/// generated code has to pick a side; this page shows where it picks it, next
/// to what the generator emitted before 7.5.0.
class LerpShowcase extends StatefulWidget {
  const LerpShowcase({super.key});

  @override
  State<LerpShowcase> createState() => _LerpShowcaseState();
}

class _LerpShowcaseState extends State<LerpShowcase>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: kThemeAnimationDuration,
  )..addListener(() => setState(() {}));

  late final AppThemeExtension _light = lightTheme
      .extension<AppThemeExtension>()!;
  late final AppThemeExtension _dark = darkTheme
      .extension<AppThemeExtension>()!;

  var _toDark = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppThemeExtension get _from => _toDark ? _light : _dark;

  AppThemeExtension get _to => _toDark ? _dark : _light;

  /// What the generator emits today.
  AppThemeExtension get _current =>
      _from.lerp(_to, _controller.value) as AppThemeExtension;

  /// What the generator emitted before 7.5.0: the null side won outright, at
  /// every `t` including the endpoints.
  BorderSide? get _previousBorderSide {
    final a = _from.optionalBorderSide;
    final b = _to.optionalBorderSide;

    if (a == null) {
      return b;
    }

    if (b == null) {
      return a;
    }

    return BorderSide.lerp(a, b, _controller.value);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacingTheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Nullable field interpolation', style: textTheme.headlineMedium),
        SizedBox(height: spacing.sm),
        Text(
          'optionalBorderSide is a BorderSide? that only the dark theme sets. '
          'Drag t, or press play to run it at the real theme animation speed.',
          style: textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.lg),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('light → dark')),
            ButtonSegment(value: false, label: Text('dark → light')),
          ],
          selected: {_toDark},
          onSelectionChanged: (selection) =>
              setState(() => _toDark = selection.first),
        ),
        SizedBox(height: spacing.md),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () => _controller
                ..reset()
                ..forward(),
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Play the transition',
            ),
            Expanded(
              child: Slider(
                value: _controller.value,
                label: _controller.value.toStringAsFixed(2),
                divisions: 100,
                onChanged: (value) => _controller.value = value,
              ),
            ),
            SizedBox(
              width: 56,
              child: Text(
                't = ${_controller.value.toStringAsFixed(2)}',
                style: textTheme.labelMedium,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.md),
        Row(
          spacing: spacing.md,
          children: [
            Expanded(
              child: _BorderPreview(
                label: 'Generated now',
                side: _current.optionalBorderSide,
                fill: _current.primaryColor,
              ),
            ),
            Expanded(
              child: _BorderPreview(
                label: 'Before 7.5.0',
                side: _previousBorderSide,
                fill: _current.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        Text(
          'The fill is primaryColor, a non-nullable Color: it interpolates '
          'smoothly and is identical in both boxes. Only the border differs, '
          'and only because one side of it is null.',
          style: textTheme.bodySmall,
        ),
        SizedBox(height: spacing.sectionSpacing),
        Text('Live theme', style: textTheme.titleLarge),
        SizedBox(height: spacing.sm),
        Text(
          'The same field, read from the real theme. Toggle and watch when the '
          'border shows up: it lands halfway through the transition rather '
          'than on its first frame.',
          style: textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.md),
        _BorderPreview(
          label: 'context.appTheme',
          side: context.appTheme.optionalBorderSide,
          fill: context.appTheme.primaryColor,
        ),
        SizedBox(height: spacing.md),
        CustomButton(
          label: 'Toggle Dark/Light Theme',
          icon: Icons.brightness_6,
          onPressed: () => context.appState.toggleTheme(),
        ),
      ],
    );
  }
}

class _BorderPreview extends StatelessWidget {
  const _BorderPreview({
    required this.label,
    required this.side,
    required this.fill,
  });

  final String label;
  final BorderSide? side;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacingTheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 96,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(12),
            border: side == null ? null : Border.fromBorderSide(side!),
          ),
        ),
        SizedBox(height: spacing.sm),
        Text(label, style: textTheme.labelLarge),
        Text(
          side == null ? 'null' : 'width ${side!.width.toStringAsFixed(1)}',
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
