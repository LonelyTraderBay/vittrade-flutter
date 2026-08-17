/// Which chrome the per-surface app shells render: real device chrome
/// (`native`) or the screenshot-friendly [VitPhoneFrame] wrapper used for
/// visual QA (`visualQa`).
enum ShellRenderMode { native, visualQa }

const bool _visualQaFrameFromEnvironment = bool.fromEnvironment(
  'VISUAL_QA_FRAME',
);

/// Resolves the app-wide [ShellRenderMode] from the `VISUAL_QA_FRAME`
/// compile-time environment flag.
ShellRenderMode defaultShellRenderMode() {
  return _visualQaFrameFromEnvironment
      ? ShellRenderMode.visualQa
      : ShellRenderMode.native;
}

/// Convenience checks derived from a [ShellRenderMode] value.
extension ShellRenderModeState on ShellRenderMode {
  bool get usesVisualQaFrame => this == ShellRenderMode.visualQa;
}
