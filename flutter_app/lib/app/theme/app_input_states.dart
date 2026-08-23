import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

/// Input-state tokens for interactive surfaces (Tablet-Input-Standard I1/I2):
/// the single sanctioned source for pointer-hover and keyboard-focus visuals.
/// Presentation code never hand-rolls hover/focus colors — shared widgets
/// (VitCard, VitCtaButton, list/menu rows, inputs) consume these tokens
/// through their InkWell/border so every surface inherits identical
/// interaction states.
///
/// | Role | Token | Visual |
/// | --- | --- | --- |
/// | Pointer hover on a control | [hoverOverlay] | 5% white tint fill |
/// | Keyboard focus on a control | [focusOverlay] | 12% primary tint fill |
/// | Keyboard focus on a text input | [focusInputBorder] | border → primary |
///
/// Both overlays are *fills*, never size changes — hover/focus must not shift
/// layout (I5). Inputs use a border (not a fill) so the caret stays the only
/// bright element inside the field.
final class AppInputStates {
  const AppInputStates._();

  static const Color hoverOverlay = AppColors.hoverBg;
  static const Color focusOverlay = AppColors.primary12;
  static const Color focusInputBorder = AppColors.primary;
}
