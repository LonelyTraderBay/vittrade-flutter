import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_route_tree.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/router/visual_qa_route_metadata.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/shell/phone/phone_app_shell.dart';
import 'package:vit_trade_flutter/app/shell/web/web_app_shell.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/otp_page.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:vit_trade_flutter/app/router/contracts/auth_route_args.dart';
import 'package:vit_trade_flutter/app/router/route_groups/admin_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/arena_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/auth_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/dca_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/earn_savings_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/earn_staking_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/home_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/launchpad_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/markets_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_marketplace_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_orders_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_account_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_security_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_dispute_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/predictions_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/profile_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/support_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_bots_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_compliance_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_copy_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_terminal_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/utility_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/wallet_routes.dart';

export 'app_route_contracts.dart';
part 'route_groups/root_routes.dart';
part 'router_helpers.dart';

/// Public compatibility facade.
///
/// Surface composition is selected once here for older callers. The Phone
/// and Tablet composition roots themselves remain independent and never
/// import this facade.
GoRouter createAppRouter({
  String? initialLocation,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  AppConfig? appConfig,
  AppSurface? surface,
}) {
  if (surface == AppSurface.tablet) {
    return createTabletAppRouter(
      initialLocation: initialLocation,
      shellRenderMode: shellRenderMode,
      appConfig: appConfig,
    );
  }
  if (surface == AppSurface.web) {
    return createLegacyAppRouter(
      initialLocation: initialLocation,
      shellRenderMode: shellRenderMode,
      appConfig: appConfig,
      surface: surface,
    );
  }
  return createPhoneRouteTree(
    initialLocation: initialLocation,
    shellRenderMode: shellRenderMode,
    appConfig: appConfig,
  );
}
