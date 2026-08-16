import 'package:flutter/widgets.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

const double _arenaVisualQaNavReserve = 90;
const double _arenaNativeNavReserve = 72;

double arenaFooterPadding(
  BuildContext context,
  ShellRenderMode mode, {
  double visualExtra = AppSpacing.x4,
  double nativeExtra = AppSpacing.x3,
}) {
  final shellReserve = mode.usesVisualQaFrame
      ? _arenaVisualQaNavReserve
      : _arenaNativeNavReserve;
  final extra = mode.usesVisualQaFrame ? visualExtra : nativeExtra;
  return shellReserve + extra + MediaQuery.paddingOf(context).bottom;
}
