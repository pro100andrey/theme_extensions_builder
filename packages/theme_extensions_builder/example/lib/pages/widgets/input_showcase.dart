import 'package:flutter/material.dart';

import '../../theme/extensions/spacing_theme.dart';
import '../../theme/extensions/widgets/input_theme.dart';

/// Text inputs driven entirely by [InputThemeExtension].
///
/// Every visible part of a field comes from the extension: the border colour
/// and the fill are `WidgetStateProperty<Color?>` resolved against the state
/// of the field, and the border width, radius, padding, text styles and the
/// duration of the focus animation are plain fields. Toggle the theme to see
/// all of them interpolate at once.
class InputShowcase extends StatefulWidget {
  const InputShowcase({super.key});

  @override
  State<InputShowcase> createState() => _InputShowcaseState();
}

class _InputShowcaseState extends State<InputShowcase> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(text: 'hunter2');
  final _searchController = TextEditingController();
  final _notesController = TextEditingController();
  final _invalidController = TextEditingController(text: 'not-an-email');

  var _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    _notesController.dispose();
    _invalidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacingTheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Inputs', style: textTheme.headlineMedium),
        SizedBox(height: spacing.sm),
        Text(
          'Border and fill colours are WidgetStateProperty<Color?>, resolved '
          'against the state of each field. Focus one to see the state change, '
          'toggle the theme to see the whole set interpolate.',
          style: textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.lg),
        ThemedTextField(
          label: 'Email',
          hint: 'you@example.com',
          helperText: 'We only use it to send the newsletter.',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.alternate_email,
        ),
        SizedBox(height: spacing.md),
        ThemedTextField(
          label: 'Password',
          hint: 'At least 8 characters',
          controller: _passwordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
          ),
        ),
        SizedBox(height: spacing.md),
        ThemedTextField(
          label: 'Search',
          hint: 'Type to filter',
          controller: _searchController,
          prefixIcon: Icons.search,
        ),
        SizedBox(height: spacing.md),
        ThemedTextField(
          label: 'Email (error state)',
          controller: _invalidController,
          errorText: 'Enter a valid email address',
          prefixIcon: Icons.alternate_email,
        ),
        SizedBox(height: spacing.md),
        const ThemedTextField(
          label: 'Account id (disabled)',
          hint: 'Assigned automatically',
          enabled: false,
          prefixIcon: Icons.badge_outlined,
        ),
        SizedBox(height: spacing.md),
        ThemedTextField(
          label: 'Notes',
          hint: 'Anything else we should know?',
          controller: _notesController,
          maxLines: 4,
        ),
      ],
    );
  }
}

/// A text field painted from [InputThemeExtension] rather than from the
/// Material input decoration theme.
class ThemedTextField extends StatefulWidget {
  const ThemedTextField({
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final int maxLines;

  @override
  State<ThemedTextField> createState() => _ThemedTextFieldState();
}

class _ThemedTextFieldState extends State<ThemedTextField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// The states the theme resolves its colours against.
  Set<WidgetState> get _states => {
    if (!widget.enabled) WidgetState.disabled,
    if (widget.errorText != null) WidgetState.error,
    if (_focusNode.hasFocus) WidgetState.focused,
  };

  String _describe(Set<WidgetState> states) =>
      states.isEmpty ? '{}' : states.map((state) => state.name).join(', ');

  @override
  Widget build(BuildContext context) {
    final theme = context.inputTheme;
    final spacing = context.spacingTheme;
    final states = _states;

    final borderColor = theme.borderColor.resolve(states);
    final labelColor = theme.labelColor.resolve(states);
    final isFocused = states.contains(WidgetState.focused);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.labelStyle.copyWith(color: labelColor),
        ),
        SizedBox(height: spacing.xs),
        AnimatedContainer(
          duration: theme.focusDuration,
          curve: Curves.easeOut,
          padding: theme.contentPadding,
          decoration: BoxDecoration(
            color: theme.fillColor.resolve(states),
            borderRadius: theme.borderRadius,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: isFocused ? theme.focusedBorderWidth : theme.borderWidth,
            ),
          ),
          child: Row(
            spacing: spacing.sm,
            children: [
              if (widget.prefixIcon != null)
                Icon(widget.prefixIcon, size: 20, color: labelColor),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  maxLines: widget.maxLines,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: theme.hintColor),
                  ),
                ),
              ),
              if (widget.suffix != null) widget.suffix!,
            ],
          ),
        ),
        if (widget.errorText != null || widget.helperText != null) ...[
          SizedBox(height: spacing.xs),
          Text(
            widget.errorText ?? widget.helperText!,
            style: widget.errorText != null
                ? theme.errorStyle
                : theme.helperStyle,
          ),
        ],
        SizedBox(height: spacing.xs),
        Text('states: ${_describe(states)}', style: theme.helperStyle),
      ],
    );
  }
}
