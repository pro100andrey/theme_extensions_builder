import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'input_theme.g.theme.dart';

/// Theme for text inputs.
///
/// The colours that change with the state of the field are declared as
/// `WidgetStateProperty<Color?>`, which the generator interpolates through
/// `WidgetStateProperty.lerp`. The generic has to be nullable for that: the
/// lerp function it is handed takes nullable arguments.
@themeExtensions
class InputThemeExtension extends ThemeExtension<InputThemeExtension>
    with _$InputThemeExtension {
  const InputThemeExtension({
    required this.borderColor,
    required this.fillColor,
    required this.labelColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.focusedBorderWidth,
    required this.contentPadding,
    required this.labelStyle,
    required this.helperStyle,
    required this.errorStyle,
    required this.focusDuration,
    this.hintColor,
  });

  /// Border colour per state: focused, error, disabled, or plain.
  final WidgetStateProperty<Color?> borderColor;

  /// Background of the field, also per state.
  final WidgetStateProperty<Color?> fillColor;

  /// Colour of the floating label, also per state.
  final WidgetStateProperty<Color?> labelColor;

  final BorderRadius borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;
  final EdgeInsets contentPadding;
  final TextStyle labelStyle;
  final TextStyle helperStyle;
  final TextStyle errorStyle;

  /// How long the border takes to move between states.
  final Duration focusDuration;

  /// Optional, so it also shows a nullable field being interpolated.
  final Color? hintColor;
}
