// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/phone/route_groups/earn_savings_routes.dart';
import 'package:vit_trade_flutter/app/router/phone/route_groups/earn_staking_routes.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

/// Aggregator kept for transitional imports (ADR-011).
List<RouteBase> earnRoutes(ShellRenderMode shellRenderMode) {
  return [
    ...earnStakingRoutes(shellRenderMode),
    ...earnSavingsRoutes(shellRenderMode),
  ];
}
