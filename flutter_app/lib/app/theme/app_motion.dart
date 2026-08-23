import 'package:flutter/material.dart';

/// Motion tokens (Motion-Standard M1–M3): the single sanctioned source for
/// animation durations, easing curves, and reduced-motion behavior.
/// Presentation code never hand-rolls `Duration(`/`Curves.` literals — pick
/// the duration by the animated *role*, the curve by the motion *direction*.
///
/// ## Duration scale (M1) — role-based
/// | Role | Token | Value |
/// | --- | --- | --- |
/// | Micro feedback (press/hover tint, chip toggle) | [feedback] | 100ms |
/// | Element state (row expand, tooltip, fade) | [element] | 180ms |
/// | Surface (sheet, dialog, panel) | [surface] | 240ms |
/// | Scene (page transition, hero move) | [scene] | 320ms |
///
/// ## Easing scale (M2) — direction-based
/// | Direction | Token | Curve |
/// | --- | --- | --- |
/// | Enter/reveal | [enter] | `easeOutCubic` — fast out, gentle settle |
/// | Emphasized scene change | [emphasized] | `easeInOutCubicEmphasized` |
/// | Exit/dismiss | [exit] | `easeInCubic` — quick away |
///
/// ## Reduced motion (M3)
/// Every animated widget resolves its duration through [respect] so the OS
/// "remove animations" accessibility setting collapses motion to instant
/// state changes instead of breaking the UI.
///
/// Not motion and out of scope: mock repository/network delays
/// (`Future.delayed`), debounce timers, splash `Duration` in tests.
final class AppMotion {
  const AppMotion._();

  /// 100ms — micro feedback: press/hover tint, chip toggle.
  static const Duration feedback = Duration(milliseconds: 100);

  /// 180ms — element state: row expand, tooltip, opacity fade.
  static const Duration element = Duration(milliseconds: 180);

  /// 240ms — surface: sheets, dialogs, panels.
  static const Duration surface = Duration(milliseconds: 240);

  /// 320ms — scene: page-level transitions, hero moves.
  static const Duration scene = Duration(milliseconds: 320);

  /// Reduced-motion stand-in (M3).
  static const Duration none = Duration.zero;

  /// Enter/reveal — fast out, gentle settle.
  static const Curve enter = Curves.easeOutCubic;

  /// Emphasized scene changes — deliberate in both directions.
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Exit/dismiss — quick away.
  static const Curve exit = Curves.easeInCubic;

  /// Resolves [duration] against the platform's disable-animations setting
  /// (M3): collapsed to [none] when the user asked for reduced motion.
  static Duration respect(BuildContext context, Duration duration) {
    final disabled = MediaQuery.maybeDisableAnimationsOf(context);
    return (disabled ?? false) ? none : duration;
  }
}
