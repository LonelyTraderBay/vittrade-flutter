/// Screen-width thresholds for tablet-adaptive layout. Phone-first stays the
/// baseline (`AGENTS.md` UI Rules) — the surface is resolved once at
/// bootstrap (`AppSurfaceResolver`), and module by module page content
/// switches to a tablet composition above this width.
final class AppBreakpoints {
  const AppBreakpoints._();

  /// Material 3 "medium" window-size-class start. At or above this width,
  /// bootstrap resolves `AppSurface.tablet` (navigation rail instead of the
  /// bottom nav) and tablet-adaptive pages (starting with Home, SC-007)
  /// switch layout.
  static const double tablet = 600;

  static bool isTablet(double width) => width >= tablet;
}
